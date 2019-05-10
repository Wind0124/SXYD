//
//  ShareModel.h
//  Manager
//
//  Created by vpclub on 2018/12/10.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareModel : BaseModel
// 海报 字段
@property (nonatomic, strong) NSString<Optional> * businessAddress;// 营业厅地址
@property (nonatomic, strong) NSString<Optional> * city;// 城市
@property (nonatomic, strong) NSString<Optional> * coverUrl;// 店铺封面
@property (nonatomic, strong) NSString<Optional> * district;// 地区
@property (nonatomic, strong) NSString<Optional> * mobile;// 手机号
@property (nonatomic, strong) NSString<Optional> * name;// 店铺名称
@property (nonatomic, strong) NSString<Optional> * province;// 省份
@property (nonatomic, strong) NSString<Optional> * qrCodeUrl;// 二维码链接地址

// 分享二维码 字段
@property (nonatomic, strong) NSString<Optional> * linkUrl;// 链接地址

// 分享微信等 字段
@property (nonatomic, strong) NSString<Optional> * content;// 内容简介
@property (nonatomic, strong) NSString<Optional> * picUrl;// 图片地址
@property (nonatomic, strong) NSString<Optional> * title;// 标题



@end

NS_ASSUME_NONNULL_END
