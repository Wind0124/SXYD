//
//  AuthUserInfoModel.h
//  Manager
//
//  Created by vpclub on 2018/12/7.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthUserInfoModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * buffetTotalMinutes;// 自助餐总分钟数
@property (nonatomic, strong) NSString<Optional> * consumerMinutes; // 已打分钟数
@property (nonatomic, strong) NSNumber<Optional> * latestBalance; // 最新余额（单位：万分之一万）
@property (nonatomic, strong) NSString<Optional> * linkPhone;// 联系电话
@property (nonatomic, strong) NSNumber<Optional> * realtimeCallCharge;// 实时话费（单位：万分之一万）
@property (nonatomic, strong) NSString<Optional> * remainingMinutes;// 剩余分钟数
@property (nonatomic, strong) NSString<Optional> * totalScore;// 总积分
@property (nonatomic, strong) NSString<Optional> * userName;// 用户名
@property (nonatomic, strong) NSString<Optional> * userStatus;// 用户状态
@property (nonatomic, strong) NSString<Optional> * packageName;// 套餐名
@property (nonatomic, strong) NSString<Optional> * fluxUnit; // 流量单位
@property (nonatomic, strong) NSString<Optional> * surplusflow; // 剩余流量
@property (nonatomic, strong) NSString<Optional> * totalFlow; // 总流量

@end

NS_ASSUME_NONNULL_END
