//
//  OpenAccountInfo.m
//  Manager
//
//  Created by vpclub on 2019/1/9.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "OpenAccountInfo.h"

@implementation OpenAccountInfo

- (id)copyWithZone:(NSZone *)zone {
    
    OpenAccountInfo *info = [[[self class] allocWithZone:zone] init];
    info.model = self.model;
    info.contractModel = self.contractModel;
    info.mobileModel = self.mobileModel;
    info.idModel = self.idModel;
    info.SIMString = self.SIMString;
    info.orderId = self.orderId;
    
    return info;
}

@end
