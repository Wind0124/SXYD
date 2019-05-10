//
//  BusinessApiGradeModel.h
//  Manager
//
//  Created by vpclub on 2019/1/4.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BusinessGradeModel
@end
@protocol BusinessContractModel
@end

@interface BusinessApiGradeModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * businessBackgroundUrl;// 业务包背景图片url
@property (nonatomic, strong) NSString<Optional> * businessCode;// 业务编码(唯一)
@property (nonatomic, strong) NSString<Optional> * businessName;// 业务名
@property (nonatomic, strong) NSString<Optional> * businessPicUrl;// 业务包图片url
@property (nonatomic, strong) NSString<Optional> * businessPosterUrl;// 海报图片url
@property (nonatomic, strong) NSString<Optional> * info_id;// 业务id 
@property (nonatomic, strong) NSArray<BusinessGradeModel, Optional> *gradeList;// 档次列表
@property (nonatomic, strong) NSArray<BusinessContractModel, Optional> *contractList;// 合约列表

@end

NS_ASSUME_NONNULL_END
