//
//  DisplayResultViewController.m
//  MFNetworkManagerDemo
//
//  Created by pipelining on 2018/2/26.
//  Copyright © 2018年 pipelining. All rights reserved.
//

#import "DisplayResultViewController.h"
#import "MFNetworkManager.h"
#import <YYImage.h>
@interface DisplayResultViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation DisplayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 150)];
    self.textView.backgroundColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    self.textView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    self.imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textView.frame) + 10, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    self.imageView.backgroundColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
    [self.view addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView.frame), self.view.bounds.size.width - 20, 0)];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    self.progressView.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1];
    self.progressView.trackTintColor = [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1];
    [self.view addSubview:self.progressView];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progressView.transform = transform;
    [self load];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"--------------------");
    [MFNETWROK cancelRequestWithURL:@"https://cdn.gratisography.com/photos/440H.jpg"];
    
}

- (void)load {
    if (self.type == 0) {
        [MFNETWROK get:@"http://httpbin.org/get"
                params:@{
                         @"params_key": @"params_value"
                         }
               success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                   NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                   NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), str];
                   });
               }
               failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                   });
               }];
    }else if (self.type == 1) {
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"http://httpbin.org/post"
                 params:@{
                          @"params_key": @"params_value"
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), str];
                    });
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                    });
                }];

    }else if (self.type == 2) {
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK put:@"http://httpbin.org/put"
                params:@{
                         @"params_key": @"params_value"
                         }
               success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                   NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                   NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), str];
                   });
               }
               failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                   });
               }];
    }else if (self.type == 3) {
        [MFNETWROK delete:@"http://httpbin.org/delete"
                   params:@{
                            @"params_key": @"params_value"
                            }
                  success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                      NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), str];
                      });
                  }
                  failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                      });
                  }];
    }else if (self.type == 4) {
        [MFNETWROK upload:@"http://httpbin.org/post"
                   params:@{
                            @"params_key": @"params_value"
                            }
                     name:@"name"
                   images:self.imageList
               imageScale:0.1
                imageType:self.imageType
                 progress:^(NSProgress *progress) {
                     //这个progress不准确！！！
                     //这个progress并不是上传到服务器的进度，只是上传到TCP Send Buffer的进度，
                     //而不是发送到TCP Receive Buffer，更不是发送到Server的进度
                     //每次写入Send Buffer 就会更新progress，所以小图片可能瞬间100%。
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.progressView.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
                         
                     });
                 } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                     NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                     NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     NSString *base64 = [result[@"files"][@"name"] substringFromIndex:22];
                     NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), str];
                         self.imageView.image = [YYImage imageWithData:base64Data];
                     });
                 } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                     });
                 }];
    }else {
        [MFNETWROK download:@"https://cdn.gratisography.com/photos/440H.jpg"
                    fileDir:@"Download"
                   progress:^(NSProgress *progress) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           self.progressView.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
                       });
                   }
                    success:^(NSString *path, NSInteger statusCode) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imageView.image = [UIImage imageWithContentsOfFile:path];
                            self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), path];;
                        });
                    }
                    failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.textView.text = [NSString stringWithFormat:@"%@\n%@", @(statusCode), error.localizedDescription];
                        });
                    }];
    }
}


@end
