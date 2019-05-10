//
//  AdvertInfoModel.h
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"
@protocol AdvertInfoModel
@end

@interface AdvertInfoModel : BaseModel

@property (nonatomic, strong) NSNumber<Optional> * authentication;
@property (nonatomic, strong) NSString<Optional> * describe;
@property (nonatomic, strong) NSString<Optional> * dictionaryAdvertTypeCode;
@property (nonatomic, strong) NSString<Optional> * dictionaryLinkTypeCode;
@property (nonatomic, strong) NSString<Optional> * info_id; // == id
@property (nonatomic, strong) NSString<Optional> * image;
@property (nonatomic, strong) NSNumber<Optional> * isDifferentWeb;
@property (nonatomic, strong) NSString<Optional> * linkAddr;
@property (nonatomic, strong) NSString<Optional> * linkName;
@property (nonatomic, strong) NSString<Optional> * mixin;
@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * nameColor;
@property (nonatomic, strong) NSString<Optional> * reserveImage;
@property (nonatomic, strong) NSNumber<Optional> * selectStatus;
@property (nonatomic, strong) NSNumber<Optional> * share;
@property (nonatomic, strong) NSString<Optional> * shareDescribe;
@property (nonatomic, strong) NSString<Optional> * shareImage;
@property (nonatomic, strong) NSString<Optional> * shareTitle;
@property (nonatomic, strong) NSString<Optional> * urlKey;

// 所有类别接口中增加该字段
// 业务类别中的个数    @"businessContents" : @"1 element"
@property (nonatomic, strong) NSArray<AdvertInfoModel, Optional> * businessContents;

@end
