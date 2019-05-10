//
//  CCHTTPClient.h
//  Srpingrass
//
//  Created by Wind.Cai on 2017/3/10.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CCHTTPClient : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
