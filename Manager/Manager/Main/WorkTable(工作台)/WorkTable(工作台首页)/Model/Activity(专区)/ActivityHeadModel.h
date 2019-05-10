//
//  ActivityHeadModel.h
//  
//
//  Created by vpclub on 2018/12/1.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityHeadModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * cover;// 封面图片
@property (nonatomic, strong) NSString<Optional> * describe;// 描述
@property (nonatomic, strong) NSNumber<Optional> * differentNetwork;// 是否支持异网 (1. 是 2. 否)
@property (nonatomic, strong) NSNumber<Optional> * forceShelves;// 是否强制上架（1：是 2：否）
@property (nonatomic, strong) NSString<Optional> * icon;// 专题图标
@property (nonatomic, strong) NSString<Optional> * name;// 专题名称
@property (nonatomic, strong) NSString<Optional> * nameColor;// 专题名称颜色
@property (nonatomic, strong) NSNumber<Optional> * share;// 是否可以分享 (1. true 2.false)
@property (nonatomic, strong) NSString<Optional> * shareDescribe;// 分享描述
@property (nonatomic, strong) NSString<Optional> * shareImage;// 分享图片
@property (nonatomic, strong) NSString<Optional> * shareTitle;// 分享标题
@property (nonatomic, strong) NSString<Optional> * url;// 外链url

@end

NS_ASSUME_NONNULL_END
