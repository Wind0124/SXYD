//
//  ActivityModel.h
//  Manager
//
//  Created by vpclub on 2018/12/1.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"
//#import "ActivityBusinessModel.h"
//#import "ActivityChildModel.h"
#import "ActivityHeadModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ActivityBusinessModel
@end
@protocol ActivityChildModel
@end
@protocol ActivityHeadModel
@end

@interface ActivityModel : BaseModel

@property (nonatomic, strong) NSNumber<Optional> * childSubject;// 是否有子专区(1：有 2：没有 )
@property (nonatomic, strong) NSString<Optional> * dictionaryBusinessTypeCode;// 商品业务类型
@property (nonatomic, strong) NSString<Optional> * dictionaryChildStyleCode;// 子专区样式
@property (nonatomic, strong) NSString<Optional> * dictionaryGoodsStyleCode;// 商品样式
// 父专区样式
// displayName：显示名称，displayNameAndPicture：显示名称和图片，displayPicture：显示图片，nodisplay：不显示
@property (nonatomic, strong) NSString<Optional> * dictionaryStyleCode;
@property (nonatomic, strong) NSString<Optional> * dictionaryOneLevleTypeCode;// 未用
@property (nonatomic, strong) NSString<Optional> * dictionaryTwoLevelTypeCode;// 未用
@property (nonatomic, strong) NSString<Optional> * info_id;// 父专区id ==id

@property (nonatomic, strong) NSArray<ActivityBusinessModel, Optional> * activityBusinessList;
@property (nonatomic, strong) NSArray<ActivityChildModel, Optional> * activityChildList;
@property (nonatomic, strong) ActivityHeadModel<Optional> * activityHead;

@end

NS_ASSUME_NONNULL_END
