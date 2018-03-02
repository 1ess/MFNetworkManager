//
//  MFNetworkManager.m
//
//  Created by 张冬冬.
//  Copyright © 2018年 张冬冬. All rights reserved.
//

#import "MFNetworkManager.h"
#import <RealReachability/RealReachability.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

typedef NS_ENUM(NSInteger, MFImageType) {
    MFImageTypeJPEG,
    MFImageTypePNG,
    MFImageTypeGIF,
    MFImageTypeTIFF,
    MFImageTypeUNKNOWN
};

@interface MFNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer *httpResponseSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;

@property (nonatomic, strong) NSMutableArray *allSessionTask;
@property (nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@property (nonatomic, strong) NSMutableDictionary *mutableParameters;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@end

@implementation MFNetworkManager

+ (instancetype)shareInstance {
    static MFNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFNetworkManager alloc] init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allSessionTask = @[].mutableCopy;
        _mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];
        _mutableParameters = [NSMutableDictionary dictionary];
        _timeoutInterval = 30;
    }
    return self;
}

- (void)setValue:(id)value forParameterField:(NSString *)field {
    [self.mutableParameters setValue:value forKey:field];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.mutableHTTPRequestHeaders setValue:value forKey:field];
}

- (void)setHTTPRequestHeaders:(NSDictionary<NSString *, NSString *> *)dictionary {
    NSArray *allKeys = [dictionary allKeys];
    if (allKeys.count) {
        for (NSString *headerField in allKeys) {
            NSString *value = dictionary[headerField];
            [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:headerField];
        }
    }
}

- (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

- (void)cancelAllRequest {
    @synchronized(self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
            [self openNetworkActivityIndicator:NO];
        }];
        [self.allSessionTask removeAllObjects];
    }
}

- (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized(self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString isEqualToString:url]) {
                [task cancel];
                [self.allSessionTask removeObject:task];
                *stop = YES;
            }
        }];
    }
}

- (NSString *)dealWithURL:(NSString *)url params:(id)params {
    [self setHTTPRequestHeaders:self.mutableHTTPRequestHeaders];
    [self.mutableParameters addEntriesFromDictionary:params];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    self.sessionManager.requestSerializer.timeoutInterval = self.timeoutInterval;
    return urlString;
}

- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(id)params
                      success:(MFNetworkSuccessHandle)success
                      failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    NSString *urlString = [self dealWithURL:url params:params];
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:urlString parameters:self.mutableParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (success) {
            success(responseObject, statusCode, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (failure) {
            failure(error, statusCode, task);
        }
    }];
    dataTask ? [self.allSessionTask addObject:dataTask] : nil;
    [self resetSerialization];
    return dataTask;
}

- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(id)params
                       success:(MFNetworkSuccessHandle)success
                       failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    NSString *urlString = [self dealWithURL:url params:params];
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlString parameters:self.mutableParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (success) {
            success(responseObject, statusCode, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (failure) {
            failure(error, statusCode, task);
        }
    }];
    dataTask ? [self.allSessionTask addObject:dataTask] : nil;
    [self resetSerialization];
    return dataTask;
}

- (NSURLSessionDataTask *)upload:(NSString *)url
                      params:(id)params
                        name:(NSString *)name
                      images:(NSArray<UIImage *> *)images
                  imageScale:(CGFloat)imageScale
                    progress:(MFProgress)progress
                     success:(MFNetworkSuccessHandle)success
                     failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    NSString *urlString = [self dealWithURL:url params:params];
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlString parameters:self.mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale);
            MFImageType imageType = [self typeForImageData:imageData];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *suffix = @"";
            switch (imageType) {
                case MFImageTypeJPEG:
                    suffix = @"jpeg";
                    break;
                case MFImageTypePNG:
                    suffix = @"png";
                    break;
                case MFImageTypeGIF:
                    suffix = @"gif";
                    break;
                case MFImageTypeTIFF:
                    suffix = @"tiff";
                    break;
                default:
                    suffix = @"png";
                    break;
            }
            NSString *imageFileName = [NSString stringWithFormat:@"%@%@.%@", str, @(i), suffix];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",suffix]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (success) {
            success(responseObject, statusCode, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (failure) {
            failure(error, statusCode, task);
        }
    }];
    dataTask ? [self.allSessionTask addObject:dataTask] : nil;
    [self resetSerialization];
    return dataTask;
    
}

- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                          imageDatas:(NSArray<NSData *> *)imageDatas
                        progress:(MFProgress)progress
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    NSString *urlString = [self dealWithURL:url params:params];
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlString parameters:self.mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < imageDatas.count; i++) {
            NSData *imageData = imageDatas[i];
            MFImageType imageType = [self typeForImageData:imageData];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *suffix = @"";
            switch (imageType) {
                case MFImageTypeJPEG:
                    suffix = @"jpeg";
                    break;
                case MFImageTypePNG:
                    suffix = @"png";
                    break;
                case MFImageTypeGIF:
                    suffix = @"gif";
                    break;
                case MFImageTypeTIFF:
                    suffix = @"tiff";
                    break;
                default:
                    suffix = @"png";
                    break;
            }
            NSString *imageFileName = [NSString stringWithFormat:@"%@%@.%@", str, @(i), suffix];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",suffix]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (success) {
            success(responseObject, statusCode, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.allSessionTask removeObject:task];
        NSInteger statusCode = [self getStatusCodeWithTask:task];
        [self openNetworkActivityIndicator:NO];
        if (failure) {
            failure(error, statusCode, task);
        }
    }];
    dataTask ? [self.allSessionTask addObject:dataTask] : nil;
    [self resetSerialization];
    return dataTask;
    
}

- (MFImageType)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return MFImageTypeJPEG;
        case 0x89:
            return MFImageTypePNG;
        case 0x47:
            return MFImageTypeGIF;
        case 0x49:
        case 0x4D:
            return MFImageTypeTIFF;
    }
    return MFImageTypeUNKNOWN;
}

- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(MFProgress)progress
                               success:(MFDownloadSuccessHandle)success
                               failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    [self setHTTPRequestHeaders:self.mutableHTTPRequestHeaders];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    __block NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self.allSessionTask removeObject:downloadTask];
        NSInteger statusCode = [self getStatusCodeWithTask:downloadTask];
        [self openNetworkActivityIndicator:NO];
        if (error && failure) {
            failure(error, statusCode, nil);
            return ;
        }
        
        if (success) {
            success(filePath.path, statusCode);
        }
        
    }];
    [downloadTask resume];
    downloadTask ? [self.allSessionTask addObject:downloadTask] : nil;
    [self resetSerialization];
    return downloadTask;
}

- (NSInteger)getStatusCodeWithTask:(NSURLSessionTask *)task {
    NSURLResponse *response = [task response];
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];
    return statusCode;
}

- (void)resetSerialization {
    if (self.requestSerialization) {
        self.requestSerialization = MFHTTPRequestSerialization;
    }
    if (self.responseSerialization) {
        self.responseSerialization = MFJSONResponseSerialization;
    }
}

- (void)setRequestTimeoutInterval:(NSTimeInterval)requestTimeoutInterval {
    self.timeoutInterval = requestTimeoutInterval;
}

- (void)setRequestSerialization:(MFRequestSerialization)requestSerialization {
    switch (requestSerialization) {
        case MFHTTPRequestSerialization:
            self.sessionManager.requestSerializer = self.httpRequestSerializer;
            break;
        case MFJSONRequestSerialization:
            self.sessionManager.requestSerializer = self.jsonRequestSerializer;
    }
}

- (void)setResponseSerialization:(MFResponseSerialization)responseSerialization {
    switch (responseSerialization) {
        case MFHTTPResponseSerialization:
            self.sessionManager.responseSerializer = self.httpResponseSerializer;
            break;
        case MFJSONResponseSerialization:
            self.sessionManager.responseSerializer = self.jsonResponseSerializer;
    }
}


#pragma mark - getters
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFHTTPResponseSerializer *)httpResponseSerializer {
    if (!_httpResponseSerializer) {
        _httpResponseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _httpResponseSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer {
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _jsonRequestSerializer;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}


#pragma mark - network state
- (void)startMonitorNetworkType {
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kRealReachabilityChangedNotification object:nil];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSString *prompt;
    BOOL isReachable = YES;
    BOOL isNeeNotice = YES;
    switch (status) {
        case RealStatusNotReachable:
        {
            prompt = @"网络已断开";
            isReachable = NO;
        }
            break;
        case RealStatusViaWiFi:
        {
            prompt = @"已切换到 WIFI";
        }
            break;
        case RealStatusViaWWAN:
        {
            WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
            if (accessType == WWANType2G)
            {
                prompt = @"已切换到 2G";
            }
            else if (accessType == WWANType3G)
            {
                prompt = @"已切换到 3G";
            }
            else if (accessType == WWANType4G)
            {
                prompt = @"已切换到 4G";
            }
        }
            break;
        default:
        {
            isNeeNotice = NO;
        }
            break;
    }
    
    if (isNeeNotice) {
        if (isReachable) {
            if ([self.delegate respondsToSelector:@selector(networkManager:didConnectedWithPrompt:)]) {
                [self.delegate networkManager:self didConnectedWithPrompt:prompt];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(networkManager:disDisConnectedWithPrompt:)]) {
                [self.delegate networkManager:self disDisConnectedWithPrompt:prompt];
            }
        }
    }
}

- (BOOL)isWIFI {
    if ([GLobalRealReachability currentReachabilityStatus] == RealStatusViaWiFi) {
        return YES;
    }else {
        return NO;
    }
}
@end

