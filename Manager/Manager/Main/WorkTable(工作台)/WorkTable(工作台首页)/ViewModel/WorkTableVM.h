//
//  WorkTableVM.h
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^WorkFinishedBlock)(NSDictionary * _Nullable result);
typedef void(^WorkFailedBlock)(NSString * _Nullable errorMessage);

@interface WorkTableVM : NSObject
// 业务统计 月
@property (nonatomic, strong) AllStatisticsModel *monthModel;
// 业务统计 日
@property (nonatomic, strong) AllStatisticsModel *todayModel;

// 工号列表
@property (nonatomic, strong) NSMutableArray *employeeArray;
// 广告数据
@property (nonatomic, strong) NSMutableArray *categoryArray;
// 专区数据
@property (nonatomic, strong) NSMutableArray * activityArray;
@property (nonatomic, strong) NSMutableArray * activityHeightArray;
@property (nonatomic, strong) NSMutableArray * activityCellArray;


// 本日业务量
- (void)requestTodayAllStatisticsNumber:(WorkFinishedBlock _Nullable)finishedBlock failed:(WorkFailedBlock _Nullable)failedBlock;
// 本月业务量
- (void)requestMonthAllStatisticsNumber:(WorkFinishedBlock _Nullable)finishedBlock failed:(WorkFailedBlock _Nullable)failedBlock;

/**
 工号列表
 */
- (void)getEmployeeList:(WorkFinishedBlock)finishedBlock failed:(WorkFailedBlock)failedBlock;
/**
 类目列表
 */
-(void)requestCategoryFinish:(WorkFinishedBlock)finishedBlock failed:(WorkFailedBlock)failedBlock;

/**
 首页专题
 */
-(void)requestActivityFinish:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
