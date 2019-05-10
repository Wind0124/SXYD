//
//  ShopInfoModel.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopInfoModel.h"

@implementation ShopInfoModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"shopDescription", @"id":@"info_id"}];
}

@end
