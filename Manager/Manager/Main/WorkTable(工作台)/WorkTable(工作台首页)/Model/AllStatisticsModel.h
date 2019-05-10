//
//  AllStatisticsModel.h
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol StatisticsModel
@end

@interface AllStatisticsModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * allBusinessCount;// 业务量
@property (nonatomic, strong) NSString<Optional> * allCommissioin;// 酬金
@property (nonatomic, strong) NSArray<StatisticsModel, Optional> * statisticsList;

@end

NS_ASSUME_NONNULL_END
