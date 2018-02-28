//
//  MFNetworkManager.m
//
//  Created by 张冬冬.
//  Copyright © 2018年 张冬冬. All rights reserved.
//

#import "MFNetworkManager.h"
#import <RealReachability/RealReachability.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
@interface MFNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer *httpResponseSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;

@property (nonatomic, strong) NSMutableArray *allSessionTask;
@end

@implementation MFNetworkManager

/**
 存储着所有的请求task数组
 */
- (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [NSMutableArray array];
    }
    return _allSessionTask;
}

+ (instancetype)shareInstance {
    static MFNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFNetworkManager alloc]init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.requestSerializer.timeoutInterval = 30.f;
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
    });
    return manager;
}

- (void)addHeaderFieldWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    NSArray *allKeys = [dictionary allKeys];
    for (NSString *headerField in allKeys) {
        NSString *value = dictionary[headerField];
        [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:headerField];
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

- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(id)params
                      success:(MFNetworkSuccessHandle)success
                      failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    if (self.commonHeaderFields) {
        [self addHeaderFieldWithDictionary:self.commonHeaderFields];
    }
    NSMutableDictionary *appendParams = [NSMutableDictionary dictionary];
    if (self.commonParams) {
        [appendParams addEntriesFromDictionary:self.commonParams];
    }
    [appendParams addEntriesFromDictionary:params];
    NSString *urlInfo = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:urlInfo parameters:appendParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [self resetType];
    return dataTask;
}

- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(id)params
                       success:(MFNetworkSuccessHandle)success
                       failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    if (self.commonHeaderFields) {
        [self addHeaderFieldWithDictionary:self.commonHeaderFields];
    }
    NSMutableDictionary *appendParams = [NSMutableDictionary dictionary];
    if (self.commonParams) {
        [appendParams addEntriesFromDictionary:self.commonParams];
    }
    [appendParams addEntriesFromDictionary:params];
    NSString *urlInfo = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlInfo parameters:appendParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [self resetType];
    return dataTask;
}

- (NSURLSessionDataTask *)upload:(NSString *)url
                      params:(id)params
                        name:(NSString *)name
                      images:(NSArray<UIImage *> *)images
                  imageScale:(CGFloat)imageScale
                   imageType:(NSString *)imageType
                    progress:(MFProgress)progress
                     success:(MFNetworkSuccessHandle)success
                     failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    if (self.commonHeaderFields) {
        [self addHeaderFieldWithDictionary:self.commonHeaderFields];
    }
    NSMutableDictionary *appendParams = [NSMutableDictionary dictionary];
    if (self.commonParams) {
        [appendParams addEntriesFromDictionary:self.commonParams];
    }
    [appendParams addEntriesFromDictionary:params];
    NSString *urlInfo = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:urlInfo parameters:appendParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale);
            // 默认图片的文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = [NSString stringWithFormat:@"%@%@.%@", str, @(i), imageType];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",imageType]];
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
    [self resetType];
    return dataTask;
    
}

- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(MFProgress)progress
                               success:(MFDownloadSuccessHandle)success
                               failure:(MFNetworkFailureHandle)failure {
    [self openNetworkActivityIndicator:YES];
    if (self.commonHeaderFields) {
        [self addHeaderFieldWithDictionary:self.commonHeaderFields];
    }
    NSString *urlInfo = [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:self.baseURL]].absoluteString;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlInfo]];
    __block NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接下载目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
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
    [self resetType];
    return downloadTask;
}

- (NSInteger)getStatusCodeWithTask:(NSURLSessionTask *)task {
    NSURLResponse *response = [task response];
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];
    return statusCode;
}

- (void)resetType {
    if (self.requestType) {
        self.requestType = MFRequestTypeHTTP;
    }
    if (self.responseType) {
        self.responseType = MFResponseTypeJSON;
    }
}

- (void)setRequestTimeoutInterval:(NSTimeInterval)requestTimeoutInterval {
    self.sessionManager.requestSerializer.timeoutInterval = requestTimeoutInterval;
}

- (void)setRequestType:(MFRequestType)requestType {
    switch (requestType) {
        case MFRequestTypeHTTP:
            self.sessionManager.requestSerializer = self.httpRequestSerializer;
            break;
        case MFRequestTypeJSON:
            self.sessionManager.requestSerializer = self.jsonRequestSerializer;
    }
}

- (void)setResponseType:(MFResponseType)responseType {
    switch (responseType) {
        case MFResponseTypeHTTP:
            self.sessionManager.responseSerializer = self.httpResponseSerializer;
            break;
        case MFResponseTypeJSON:
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
    NSString *state;
    BOOL isReachable = YES;
    BOOL isNeeNotice = YES;
    switch (status) {
        case RealStatusNotReachable:
        {
            state = @"网络已断开";
            isReachable = NO;
        }
            break;
        case RealStatusViaWiFi:
        {
            state = @"已切换到 WIFI";
        }
            break;
        case RealStatusViaWWAN:
        {
            WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
            if (accessType == WWANType2G)
            {
                state = @"已切换到 2G";
            }
            else if (accessType == WWANType3G)
            {
                state = @"已切换到 3G";
            }
            else if (accessType == WWANType4G)
            {
                state = @"已切换到 4G";
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
            self.canReachable(state);
        }else {
            self.notReachable(state);
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

