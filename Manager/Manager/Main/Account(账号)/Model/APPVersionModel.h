//
//  APPVersionModel.h
//  Manager
//
//  Created by vpclub on 2018/12/14.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPVersionModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * downloadUrl;// APP下载链接
@property (nonatomic, strong) NSString<Optional> * fileName;// app文件名称
@property (nonatomic, strong) NSNumber<Optional> * info_id;// == id
// 是否强制升级：1不强制升级，2强制升级，3不升级,4审核中
@property (nonatomic, strong) NSNumber<Optional> * isUpgrade;
@property (nonatomic, strong) NSString<Optional> * releaseTime;// 发布时间
// 状态(1可用, 2正在审核 3灰度发布 4不可用)
@property (nonatomic, strong) NSNumber<Optional> * status;
// 升级提示 标题前通过&分开，内容通过;分开 如：标题&1.内容;2.升级提示第二行
@property (nonatomic, strong) NSString<Optional> * updateHints;


@end

NS_ASSUME_NONNULL_END
