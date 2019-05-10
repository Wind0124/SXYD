//
//  WorkbenchModel.h
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkbenchModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * isDefault;
@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * code;
@property (nonatomic, strong) NSString<Optional> * isCurrent;
@end

NS_ASSUME_NONNULL_END
