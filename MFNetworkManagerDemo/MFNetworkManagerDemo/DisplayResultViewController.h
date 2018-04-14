//
//  DisplayResultViewController.h
//  MFNetworkManagerDemo
//
//  Created by pipelining on 2018/2/26.
//  Copyright © 2018年 pipelining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFNetworkManager.h"
@interface DisplayResultViewController : UIViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, assign) MFImageType imageType;
@property (nonatomic, strong) NSString *videoURL;
@end
