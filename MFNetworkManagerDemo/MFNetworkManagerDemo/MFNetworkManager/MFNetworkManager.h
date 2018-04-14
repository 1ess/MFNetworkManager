//
//  MFNetworkManager.h
//
//  Created by 张冬冬.
//  Copyright © 2018年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#define MFNETWROK [MFNetworkManager shareInstance]
typedef void (^MFDownloadSuccessHandle) (NSString *filePath, NSInteger statusCode);
typedef void (^MFNetworkSuccessHandle) (id result, NSInteger statusCode, NSURLSessionDataTask *task);
typedef void (^MFNetworkFailureHandle) (NSError *error, NSInteger statusCode, NSURLSessionDataTask *task);
typedef void (^MFProgress) (NSProgress *progress);

typedef NS_ENUM(NSInteger, MFResponseSerialization) {
    MFJSONResponseSerialization,
    MFHTTPResponseSerialization
};

typedef NS_ENUM(NSInteger, MFRequestSerialization) {
    MFHTTPRequestSerialization,
    MFJSONRequestSerialization
};

typedef NS_ENUM(NSInteger, MFImageType) {
    MFImageTypeJPEG,
    MFImageTypePNG,
    MFImageTypeGIF,
    MFImageTypeTIFF,
    MFImageTypeUNKNOWN
};

@class MFNetworkManager;
@protocol MFNetworkManagerDelegate<NSObject>
@optional
- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt;
- (void)networkManager:(MFNetworkManager *)manager disDisConnectedWithPrompt:(NSString *)prompt;

@end

@interface MFNetworkManager : NSObject

/**
 delegate
 */
@property (nonatomic, weak) id<MFNetworkManagerDelegate> delegate;

/**
 baseURL
 */

@property (nonatomic, strong) NSString *baseURL;

/**
 timeoutInterval   30 default
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
 request serialization
 */
@property (nonatomic, assign) MFRequestSerialization requestSerialization;

/**
 response serialization
*/
@property (nonatomic, assign) MFResponseSerialization responseSerialization;

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

//network indicator state
- (void)openNetworkActivityIndicator:(BOOL)open;

//cancel request
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

- (NSURLSessionDataTask *)put:(NSString *)url
                       params:(id)params
                      success:(MFNetworkSuccessHandle)success
                      failure:(MFNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)delete:(NSString *)url
                          params:(id)params
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure;
//upload with images
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                          images:(NSArray<UIImage *> *)images
                      imageScale:(CGFloat)imageScale
                       imageType:(MFImageType)imageType
                        progress:(MFProgress)progress
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure;
//upload with image datas
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                      imageDatas:(NSArray<NSData *> *)imageDatas
                        progress:(MFProgress)progress
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure;

//upload with video url
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        videoURL:(NSString *)videoURL
                        progress:(MFProgress)progress
                         success:(MFNetworkSuccessHandle)success
                         failure:(MFNetworkFailureHandle)failure;

//download
- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(MFProgress)progress
                               success:(MFDownloadSuccessHandle)success
                               failure:(MFNetworkFailureHandle)failure;
@end


