//
//  AuthUserInfoView.h
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthUserInfoView : UIView

@property (nonatomic, strong) AuthUserInfoModel *model;
// 点击用户切换
@property (nonatomic, copy) void(^AuthUserChangeBlock)(void);
// 点击业务推荐
@property (nonatomic, copy) void(^AuthUserRecommedBlock)(void);
// 查询余额
@property (nonatomic, copy) void(^AuthUserCheckBalanceBlock)(void);
// 查询积分
@property (nonatomic, copy) void(^AuthUserCheckScoreBlock)(void);
// 查询话费
@property (nonatomic, copy) void(^AuthUserCheckCostBlock)(void);
// 隐藏码表，更新UI
@property (nonatomic, copy) void(^AuthUserUpdateUIBlock)(void);
// 查看流量、通话详情
@property (nonatomic, copy) void(^AuthUserClickDetailBlock)(void);

- (id)initWithNib;

@end

NS_ASSUME_NONNULL_END
