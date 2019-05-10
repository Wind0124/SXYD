//
//  ShareView.h
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareView : UIView



- (id)initWithNib;
// 分享店铺,未有分享数据
- (void)showInVC:(BaseVC *)fatherVC;
// 分享，带分享数据
- (void)showShareView:(ShareSDKModel *)model;

@end

NS_ASSUME_NONNULL_END
