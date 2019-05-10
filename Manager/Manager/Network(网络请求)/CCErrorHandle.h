//
//  CCErrorHandle.h
//  Srpingrass
//
//  Created by Wind.Cai on 2017/3/10.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//



 //错误处理器,网络请求错误统一在这里处理


#import <Foundation/Foundation.h>
#import "CCErrorModel.h"
@interface CCErrorHandle : NSObject
+(void)handleWithError:(CCErrorModel*)errorModel;
@end
