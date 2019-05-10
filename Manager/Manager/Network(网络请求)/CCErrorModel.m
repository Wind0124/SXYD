//
//  CCErrorModel.m
//  Srpingrass
//
//  Created by tianlong on 17/3/11.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import "CCErrorModel.h"

@implementation CCErrorModel
+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"code": @"errorCode",
                                                       @"msg": @"errorMessage"
                                                       }];
}
@end
