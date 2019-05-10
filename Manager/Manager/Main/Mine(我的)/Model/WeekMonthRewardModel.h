//
//  WeekMonthRewardModel.h
//  Manager
//
//  Created by vpclub on 2018/12/11.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeekMonthRewardModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * businessCount;// 本月业务办理
@property (nonatomic, strong) NSString<Optional> * dayCommission;// 本日酬金
@property (nonatomic, strong) NSString<Optional> * monthCommission;// 本月酬金
@property (nonatomic, strong) NSString<Optional> * weekCommission;// 本周酬金


@end

NS_ASSUME_NONNULL_END
