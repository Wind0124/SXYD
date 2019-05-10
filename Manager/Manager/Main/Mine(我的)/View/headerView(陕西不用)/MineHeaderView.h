//
//  MineHeaderView.h
//  智汇随身厅
//
//  Created by BiuBiu on 2018/1/17.
//  Copyright © 2018年 vivian. All rights reserved.
//
//  头部View

#import <UIKit/UIKit.h>

typedef void(^MineSettingBlock)(void);
typedef void(^MineAvatarBlock)(void);
typedef void(^MineActionBlock)(NSInteger actionType);// 0 业务办理 1 商品订单 2 我的常客 3 本日酬金 4 本月酬金

@interface MineHeaderView : UIView

//@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;
@property (nonatomic, copy) MineSettingBlock settingBlock;
@property (nonatomic, copy) MineAvatarBlock avatarBlock;
@property (nonatomic, copy) MineActionBlock actionBlock;

@property (nonatomic, strong) WeekMonthRewardModel *model;

// 更新用户信息 Wind
- (void)updateUserInfo;

@end
