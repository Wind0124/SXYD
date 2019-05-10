//
//  StopWatchView.h
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface StopWatchView : UIView

@property (nonatomic, strong) AuthUserInfoModel *model;
//高度
@property (nonatomic, assign) CGFloat SWheight;

@property (nonatomic, copy) void (^clickHideBlock)(CGFloat floatValue);
@property (nonatomic, copy) void (^clickDetailBlock)(void);

@property (nonatomic, strong) BaseVC *fatherVC;

@property (nonatomic, copy) NSString *phoneNumStr;



@end
