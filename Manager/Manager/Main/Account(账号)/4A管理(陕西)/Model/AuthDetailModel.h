//
//  AuthDetailModel.h
//  Manager
//
//  Created by vpclub on 2018/12/24.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthDetailModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * date;
@property (nonatomic, strong) NSString<Optional> * info_id; // == id;
@property (nonatomic, strong) NSString<Optional> * mobile;
@property (nonatomic, strong) NSString<Optional> * name;

@end

NS_ASSUME_NONNULL_END
