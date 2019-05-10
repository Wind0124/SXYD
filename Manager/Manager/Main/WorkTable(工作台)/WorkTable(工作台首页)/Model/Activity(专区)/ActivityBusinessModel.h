//
//  ActivityBusinessModel.h
//  Manager
//
//  Created by vpclub on 2018/12/1.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityBusinessModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * businessId;// 业务id
@property (nonatomic, strong) NSString<Optional> * name;// 业务名称
@property (nonatomic, strong) NSNumber<Optional> * sellPrice;// 销售价格（取’商品销售规格’里面最低的）（单位：万分之一元）
@property (nonatomic, strong) NSString<Optional> * summary;// 内容摘要
@property (nonatomic, strong) NSString<Optional> * url;// 商品原始图片

@end

NS_ASSUME_NONNULL_END
