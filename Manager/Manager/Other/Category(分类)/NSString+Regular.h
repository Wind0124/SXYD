//
//  NSString+Regular.h
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

/**
 * 手机号码验证
 */
- (BOOL)isMobile;
/**
 * 密码验证
 */
- (BOOL)isPassWord;
/**
 * 短信验证
 */
- (BOOL)isMessCode;


@end
