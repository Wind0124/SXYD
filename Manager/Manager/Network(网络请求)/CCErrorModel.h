//
//  CCErrorModel.h
//  Srpingrass
//
//  Created by tianlong on 17/3/11.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CC_User_Not_Bind_Wechat         100101 //用户微信未绑定
#define CC_User_Token_Invalid           900003//用户token失效
#define CC_User_Unlogin                 0   //用户未登陆


@interface CCErrorModel : JSONModel

@property (nonatomic,assign) NSInteger errorCode;//错误状态码
@property (nonatomic,assign) NSString* errorMessage;//错误描述

@end
