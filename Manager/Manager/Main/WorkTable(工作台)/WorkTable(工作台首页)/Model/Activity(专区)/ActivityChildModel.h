//
//  ActivityChildModel.h
//  Manager
//
//  Created by vpclub on 2018/12/1.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
//@protocol ActivityBusinessModel
//@end

@interface ActivityChildModel : BaseModel

@property (nonatomic, strong) NSArray<ActivityBusinessModel, Optional> * childPrefectureBusinessInfos;// 子专区商品信息列表
@property (nonatomic, strong) NSString<Optional> * cover;// 封面图片
@property (nonatomic, strong) NSString<Optional> * describe;// 描述
// 业务类型{businessTypeProduct：商品，activityBusinessPackage：业务，externalLink：外部链接 }
@property (nonatomic, strong) NSString<Optional> * dictionaryBusinessTypeCode;
@property (nonatomic, strong) NSNumber<Optional> * differentNetwork;// 是否支持异网 (1. 是 2. 否)
@property (nonatomic, strong) NSNumber<Optional> * forceShelves;// 是否强制上架（1：是 2：否）
@property (nonatomic, strong) NSString<Optional> * icon;// 专题图标
@property (nonatomic, strong) NSString<Optional> * info_id;// 主键id == id
@property (nonatomic, strong) NSString<Optional> * name;// 专题名称
@property (nonatomic, strong) NSString<Optional> * nameColor;// 专题名称颜色
@property (nonatomic, strong) NSNumber<Optional> * share;// 是否可以分享 (1. true 2.false)
@property (nonatomic, strong) NSString<Optional> * shareDescribe;// 分享描述
@property (nonatomic, strong) NSString<Optional> * shareImage;// 分享图片
@property (nonatomic, strong) NSString<Optional> * shareTitle;// 分享标题
@property (nonatomic, strong) NSString<Optional> * url;//     外链url

@end

NS_ASSUME_NONNULL_END
