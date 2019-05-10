//
//  WUGestureUnlockViewController.h
//  WUGesturesToUnlock
//
//  Created by wuqh on 16/4/1.
//  Copyright © 2016年 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WUUnlockType) {
    WUUnlockTypeCreatePwd,//创建手势密码
    WUUnlockTypeValidatePwd,//校验手势密码
    WUUnlockTypeModifyPwd,// 修改密码:校验手势密码
    WUUnlockTypeCreatePwdForModify// 修改密码:创建手势密码
};

@interface WUGesturesUnlockViewController : BaseVC

//+ (void)deleteGesturesPassword;//删除手势密码
//+ (NSString *)gesturesPassword;//获取手势密码

- (instancetype)initWithUnlockType:(WUUnlockType)unlockType;

@property (nonatomic, assign)BOOL isManyEmpNum;//是否多个工号

@end
