//
//  CCHTTPClient.m
//  Srpingrass
//
//  Created by Wind.Cai on 2017/3/10.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

      
//----------ESB接口


#import "CCHTTPClient.h"

@implementation CCHTTPClient

+ (instancetype)sharedInstance {
    static CCHTTPClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CCHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        _sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedInstance.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _sharedInstance.requestSerializer.timeoutInterval = 15.0f;
    });
    return _sharedInstance;
}

@end
