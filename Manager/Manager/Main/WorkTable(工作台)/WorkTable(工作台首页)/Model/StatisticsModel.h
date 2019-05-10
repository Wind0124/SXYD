//
//  StatisticsModel.h
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsModel : BaseModel
@property (nonatomic, strong) NSString<Optional> * businessCount;// 业务办理数量
@property (nonatomic, strong) NSString<Optional> * commissionAmount;// 佣金(单位：万分之一)
@property (nonatomic, strong) NSString<Optional> * date;// 时间
@property (nonatomic, strong) NSString<Optional> * dictionaryBusinessTypeCode;// 业务类型 (数字字典)
@property (nonatomic, strong) NSString<Optional> * dictionaryBusinessTypeName;// 业务类型名称 (数字字典)
@property (nonatomic, strong) NSString<Optional> * handleUserId;// 用户id

@property (nonatomic, strong) NSString<Optional> * sortBy;// 新接口删除
@property (nonatomic, strong) NSString<Optional> * groupBy;// 新接口删除

@end

NS_ASSUME_NONNULL_END
