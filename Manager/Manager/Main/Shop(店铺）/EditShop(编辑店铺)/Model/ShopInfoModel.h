//
//  ShopInfoModel.h
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopInfoModel : BaseModel

@property (nonatomic, strong) NSNumber<Optional> * allowContact;// 是否允许联系. 1:允许 2：不允许
@property (nonatomic, strong) NSString<Optional> * businessAddress;// 营业厅地址
@property (nonatomic, strong) NSString<Optional> * channelCode;// 渠道编码
@property (nonatomic, strong) NSString<Optional> * channelManager;// 渠道经理
@property (nonatomic, strong) NSString<Optional> * channelName;// 渠道名称
@property (nonatomic, strong) NSString<Optional> * channnelManagerMobile;// 渠道经理号码
@property (nonatomic, strong) NSString<Optional> * city;// 城市
@property (nonatomic, strong) NSString<Optional> * coverUrl;// 店铺封面
@property (nonatomic, strong) NSString<Optional> * shopDescription;// 店铺描述
@property (nonatomic, strong) NSString<Optional> * district;// 地区
@property (nonatomic, strong) NSString<Optional> * employeeNumber;// 工号
@property (nonatomic, strong) NSString<Optional> * info_id; // == id 店铺id
@property (nonatomic, strong) NSString<Optional> * isAgent;// 是否为代理商 ‘true’/‘false’
@property (nonatomic, strong) NSString<Optional> * latitude;// 纬度
@property (nonatomic, strong) NSString<Optional> * longitude;// 经度
@property (nonatomic, strong) NSString<Optional> * mobile;// 手机号
@property (nonatomic, strong) NSString<Optional> * name;// 店铺名称
@property (nonatomic, strong) NSString<Optional> * pictureUrl;// 店铺图片,多个用’,’拼接
@property (nonatomic, strong) NSString<Optional> * province;// 省份
@property (nonatomic, strong) NSString<Optional> * userInfoId;// 用户id

@end

NS_ASSUME_NONNULL_END
