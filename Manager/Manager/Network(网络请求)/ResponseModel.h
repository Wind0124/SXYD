//
//  ResponseModel.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"

@interface ResponseModel : BaseModel

@property (nonatomic, strong) id<Optional> body;
@property (nonatomic, strong) id<Optional> head;
@property (nonatomic, strong) NSString<Optional> *timestamp;

@end
