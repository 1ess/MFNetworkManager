//
//  MFNetworkManager.h
//
//  Created by 张冬冬.
//  Copyright © 2018年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#define MFNETWROK [MFNetworkManager shareInstance]
typedef void (^MFNetworkSuccessHandle) (id result, NSURLSessionDataTask *task);
typedef void (^MFNetworkFailureHandle) (NSError *error, NSURLSessionDataTask *task);
typedef void (^MFProgress) (NSProgress *progress);

typedef void (^MFNotReachable) (NSString *string);
typedef void (^MFCanReachable) (NSString *string);

typedef NS_ENUM(NSInteger, MFResponseType) {
    MFResponseTypeJSON,
    MFResponseTypeHTTP
};

typedef NS_ENUM(NSInteger, MFRequestType) {
    MFRequestTypeHTTP,
    MFRequestTypeJSON
};

@interface MFNetworkManager : NSObject

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


/**
 全局处理网络连接的两种情况， 通常用HUD展示给用户（推荐MFHUDManager）
 */
@property (nonatomic, copy) MFNotReachable notReachable;
@property (nonatomic, copy) MFCanReachable canReachable;

/**
 Create manager
 
 @return manager
 */
+ (instancetype)shareInstance;

/**
 Start monitor network
 */
- (void)startMonitorNetworkType;

/**
 Judge is wifi ?
 
 @return isWifi
 */
- (BOOL)isWIFI;

//打开请求网络状态指示器
- (void)openNetworkActivityIndicator:(BOOL)open;

//cancel
- (void)cancelAllRequest;

- (void)cancelRequestWithURL:(NSString *)url;

//get
- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(id)params
                      success:(MFNetworkSuccessHandle)success
                      failure:(MFNetworkFailureHandle)failure;
//post
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(id)params
                       success:(MFNetworkSuccessHandle)success
                       failure:(MFNetworkFailureHandle)failure;
//upload
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                          images:(NSArray<UIImage *> *)images
                      imageScale:(CGFloat)imageScale
                       imageType:(NSString *)imageType
                        progress:(MFProgress)progress
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure;
//download
- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(MFProgress)progress
                               success:(void(^)(NSString *))success
                               failure:(MFNetworkFailureHandle)failure;
@end

