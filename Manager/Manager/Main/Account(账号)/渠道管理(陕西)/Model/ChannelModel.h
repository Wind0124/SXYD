//
//  ChannelModel.h
//  Manager
//
//  Created by vpclub on 2018/12/25.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * channelCode;// 渠道编码
@property (nonatomic, strong) NSString<Optional> * channelId;// 渠道id
@property (nonatomic, strong) NSString<Optional> * channelName;// 渠道名称
@property (nonatomic, strong) NSString<Optional> * channelType;// 渠道类型

@property (nonatomic, strong) NSString<Optional> * cityCode;// 地市编码
@property (nonatomic, strong) NSString<Optional> * cityName;// 地市名称
@property (nonatomic, strong) NSString<Optional> * hasBind;// 是否绑定

@property (nonatomic, strong) NSString<Optional> * supplierId;// 机构id
@property (nonatomic, strong) NSString<Optional> * supplierName;// 机构名称

@property (nonatomic, strong) NSString<Optional> * areaCode;// 业务区编码
@property (nonatomic, strong) NSString<Optional> * areaName;// 业务区名称

@end

NS_ASSUME_NONNULL_END
