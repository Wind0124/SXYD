//
//  WorkTabHeaderView.h
//  智汇随身厅
//
//  Created by panda on 2018/1/15.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkTabHeaderViewDelegate<NSObject>
// 进入流量包/套餐变更/宽带/充值/开户 查询界面
-(void)enterVC:(NSInteger)tag;

// 本日/本月 预估酬金/业务量    dateType       IncomeOrNum  1预估酬金/2业务量
// tag:     1预估酬金(左)/2业务量(右)
// istoday:  1本日/0本月
-(void)enterIncomeVcWithDateType:(NSInteger)tag :(BOOL)isToday;
@end

@interface WorkTabHeaderView : UIView
// 进入流量包/套餐变更/宽带/充值/开户 查询界面
@property (nonatomic, copy) void(^HeaderCheckSingleBusinessBlock)(BOOL isTody, StatisticsModel *model);
// 进入本日/本月 业务量界面
@property (nonatomic, copy) void(^HeaderCheckALLBusinessBlock)(BOOL isTody);

// 业务统计 月
@property (nonatomic, strong) AllStatisticsModel *monthModel;
// 业务统计 日
@property (nonatomic, strong) AllStatisticsModel *todayModel;

@end
