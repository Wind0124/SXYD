//
//  PrefectureModel.h
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrefectureModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * prefectureIcon;// 专题图标
@property (nonatomic, strong) NSString<Optional> * prefectureId;// 专题id
@property (nonatomic, strong) NSString<Optional> * prefectureImgUrl;// 专题图片链接地址
@property (nonatomic, strong) NSString<Optional> * prefectureIntentUrl;// 专题跳转链接地址
@property (nonatomic, strong) NSString<Optional> * prefectureName;// 专题名称
@property (nonatomic, strong) NSString<Optional> * prefectureNameColor;// 专题名称颜色
@property (nonatomic, strong) NSString<Optional> * shelf;// 隔离

@end

NS_ASSUME_NONNULL_END
