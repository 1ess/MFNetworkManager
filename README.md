[![](https://github.com/GodzzZZZ/MFNetworkManager/blob/master/SnapShot/1.png)]()

# MFNetworkManager

![DUB](https://img.shields.io/dub/l/vibe-d.svg)
![Total-downloads](https://img.shields.io/cocoapods/dt/MFNetworkManager.svg)
![Version](https://img.shields.io/cocoapods/v/MFNetworkManager.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/MFNetworkManager.svg?style=flat)
![Language](https://img.shields.io/badge/language-objectivec-blue.svg)

- 支持iOS 8及以上

<img src="https://github.com/GodzzZZZ/MFNetworkManager/blob/master/SnapShot/2.gif" width="25%"/><img src="https://github.com/GodzzZZZ/MFNetworkManager/blob/master/SnapShot/3.gif" width="25%"/><img src="https://github.com/GodzzZZZ/MFNetworkManager/blob/master/SnapShot/4.gif" width="25%"/><img src="https://github.com/GodzzZZZ/MFNetworkManager/blob/master/SnapShot/5.gif" width="25%"/>

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


- 处理网络连接的两种情况的代理方法([推荐使用MFHUDManager](https://github.com/GodzzZZZ/MFHUDManager))
```
- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt;
- (void)networkManager:(MFNetworkManager *)manager disDisConnectedWithPrompt:(NSString *)prompt;
```

- 调用MFNETWORK的 get，post，upload，download方法即可
```
//get
- (NSURLSessionDataTask *)get:(NSString *)url params:(id)params success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;

//post
- (NSURLSessionDataTask *)post:(NSString *)url params:(id)params success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;

//upload with images
- (NSURLSessionDataTask *)upload:(NSString *)url params:(id)params name:(NSString *)name images:(NSArray<UIImage *> *)images imageScale:(CGFloat)imageScale imageType:(MFImageType)imageType progress:(MFProgress)progress success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;

//upload with datas
- (NSURLSessionDataTask *)upload:(NSString *)url params:(id)params name:(NSString *)name imageDatas:(NSArray<NSData *> *)imageDatas progress:(MFProgress)progress success:(MFNetworkSuccessHandle)success failure:(MFNetworkFailureHandle)failure;

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
 delegate
*/
@property (nonatomic, weak) id<MFNetworkManagerDelegate> delegate;

/**
 baseURL
*/

@property (nonatomic, strong) NSString *baseURL;

/**
 timeoutInterval 30 default
*/
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/**
 sets the common parameter of the HTTP client. if value is `nil`, removes the existing value which associated to the field.
 @param value - the value of the parameter
 @param field - the parameter, or `nil`
*/
- (void)setValue:(id)value forParameterField:(NSString *)field;

/**
 sets the common headerField of the HTTP client. if value is `nil`, removes the existing value which associated to the field.
 @param value - the value of the HTTP header
 @param field - the HTTP header, or `nil`
*/
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 request serialization    MFHTTPRequestSerialization default
*/
@property (nonatomic, assign) MFRequestSerialization requestSerialization;

/**
 response serialization    MFJSONResponseSerialization default
*/
@property (nonatomic, assign) MFResponseSerialization responseSerialization;

```

## License
MIT
