//
//  BusinessGradeModel.h
//  Manager
//
//  Created by vpclub on 2019/1/4.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessGradeModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * appId;//
@property (nonatomic, strong) NSString<Optional> * businessCode;// 业务编码
@property (nonatomic, strong) NSString<Optional> * businessInfoId;// 业务管理id
@property (nonatomic, strong) NSString<Optional> * businessName;// 业务名称
@property (nonatomic, strong) NSString<Optional> * businessPicUrl;// 业务包图片url
@property (nonatomic, strong) NSString<Optional> * businessPosterUrl;// 海报图片url
@property (nonatomic, strong) NSString<Optional> * createBy;//
@property (nonatomic, strong) NSString<Optional> * createdTime;//
@property (nonatomic, strong) NSString<Optional> * deleteBy;//
@property (nonatomic, strong) NSString<Optional> * deleteState;//
@property (nonatomic, strong) NSString<Optional> * deleteTime;//
@property (nonatomic, strong) NSString<Optional> * desc;// 业务信息展示
@property (nonatomic, strong) NSString<Optional> * dictionaryBusinessCode;// 业务类型
@property (nonatomic, strong) NSString<Optional> * downOnlineTime;// 下线时间
@property (nonatomic, strong) NSString<Optional> * extend;// 扩展字段
@property (nonatomic, strong) NSString<Optional> * info_id;// 主键ID
@property (nonatomic, strong) NSString<Optional> * isEnable;// 是否启用（1是 2否）
@property (nonatomic, strong) NSString<Optional> * isPay;//
@property (nonatomic, strong) NSString<Optional> * isShare;// 能否分享（1是, 2不是 ）
@property (nonatomic, strong) NSString<Optional> * remark;// 备注
@property (nonatomic, strong) NSString<Optional> * shareDesc;// 分享描述
@property (nonatomic, strong) NSString<Optional> * shareTitle;// 分享标题
@property (nonatomic, strong) NSString<Optional> * sortNo;// 排序(数字越小越向前) 
@property (nonatomic, strong) NSString<Optional> * upOnlineTime;//
@property (nonatomic, strong) NSString<Optional> * updateBy;//
@property (nonatomic, strong) NSString<Optional> * updatedTime;//

@end

NS_ASSUME_NONNULL_END
