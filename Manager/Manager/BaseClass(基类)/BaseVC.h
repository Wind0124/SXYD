//
//  BaseVC.h
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertInfoModel.h"
#import "ChannelModel.h"

@interface BaseVC : UIViewController
// 检测是否有设置默认渠道
- (BOOL)checkChannelStatus;
// 跳H5业务界面
- (void)showAdvertWithModel:(AdvertInfoModel *)model Supplier:(ChannelModel *)supplierModel;

- (void)alertWithMessage:(NSString *)message;
- (void)alertWithMessage:(NSString *)message complete:(void (^)(void))block;
- (void)showWithMessage:(NSString *)message;

@end
