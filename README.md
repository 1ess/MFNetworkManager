[![](https://github.com/GodzzZZZ/MFNetworkManager/blob/master/image/FotoJet.png)]()

# MFNetworkManager

[![DUB](https://img.shields.io/dub/l/vibe-d.svg)]()

- 支持iOS 8及以上

## 集成方式
- cocoapod

```
pod 'MFNetworkManager'
```

## 使用方式

- 导入
```
#import "MFNetworkManager.h"
```

- 在 appDelegate 里设置网络监听
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //全局监控
    [MFNETWROK startMonitorNetworkType];
}
```

- 调用MFNETWORK的 get，post，upload，download方法即可
```
//get
- (NSURLSessionDataTask *)get:(NSString *)url params:(id)params success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;
//post
- (NSURLSessionDataTask *)post:(NSString *)url params:(id)params success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;
//upload
- (NSURLSessionDataTask *)upload:(NSString *)url params:(id)params name:(NSString *)name images:(NSArray<UIImage *> *)images imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(MFProgress)progress success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;
//download
- (NSURLSessionDownloadTask *)download:(NSString *)url fileDir:(NSString *)fileDir progress:(MFProgress)progress success:(void(^)(NSString *))success failure:(MFNetworkFailureHandle)failure;
```

- 取消请求
```
//cancel
- (void)cancelAllRequest;

- (void)cancelRequestWithURL:(NSString *)url;
```

- 其他配置
```
/**
delegate  处理网络连接的两种情况
*/
@property (nonatomic, weak) id<MFNetworkManagerDelegate> delegate;

/**
公共headerField
*/
@property (nonatomic, strong) NSDictionary *commonHeaderFields;

/**
公共参数
*/
@property (nonatomic, strong) NSDictionary *commonParams;

/**
超时时间 默认：30s 全局属性
*/
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/**
请求序列化类型 默认：MFRequestTypeHTTP 单一请求属性
*/
@property (nonatomic, assign) MFRequestType requestType;

/**
响应序列化类型 默认：MFResponseTypeJSON 单一请求属性
*/
@property (nonatomic, assign) MFResponseType responseType;

```

- 处理网络连接的两种情况的代理方法
```
- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt;
- (void)networkManager:(MFNetworkManager *)manager disDisConnectedWithPrompt:(NSString *)prompt;
```

## License
MIT
