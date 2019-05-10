//
//  BusinessContractModel.m
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "BusinessContractModel.h"

@implementation BusinessContractModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"info_description", @"id":@"info_id"}];
}
@end
