//
//  IDInfoModel.m
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "IDInfoModel.h"

@implementation IDInfoModel

+ (JSONKeyMapper *)keyMapper{
    NSDictionary *dic = @{@"id": @"info_id",
                          @"name": @"custName",
                          @"sex": @"gender",
                          @"psptAddress": @"custCertAddr",
                          @"certExpdate": @"certExpDate",
                          @"certValiddate": @"certValidDate",
                          };
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end
