//
//  BaseModel.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(id)initWithDictionary:(NSDictionary*)d error:(NSError* __autoreleasing *)err {
    return [super initWithDictionary:d error:err];
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"info_id"}];
}

@end
