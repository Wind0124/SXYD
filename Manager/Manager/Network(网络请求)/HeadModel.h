//
//  HeadModel.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

/*http返回数据模型，对应服务端的response中的head字段*/
#import "BaseModel.h"

@interface HeadModel : BaseModel

@property (nonatomic, strong) NSString<Optional> * code;
@property (nonatomic, strong) NSString<Optional> * msg;
@property (nonatomic, strong) NSString<Optional> *error;

@end
