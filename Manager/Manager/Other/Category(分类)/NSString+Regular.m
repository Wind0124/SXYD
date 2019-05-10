//
//  NSString+Regular.m
//  Manager
//
//  Created by vpclub on 2018/11/27.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

- (BOOL)isMobile{
    
    NSString * phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|(7[0[059]|6｜7｜8])|8[0-9])\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    NSString * phoneRegex2 = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    NSPredicate *phoneTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex2];
    
    if ([phoneTest evaluateWithObject:self]||[phoneTest2 evaluateWithObject:self]) {
        return YES;
    }else{
        return NO;
    }
    
}

/**
 * 密码 6-16个字符，可由中英文、数字组成
 */
- (BOOL)isPassWord{
    
    NSString * inputString = @"^[0-9a-zA-Z]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",inputString];
    return  [predicate evaluateWithObject:self];
}

/**
 * 密码 4个字符，由数字组成
 */
- (BOOL)isMessCode{
    
    NSString * inputString = @"^[0-9]{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",inputString];
    return  [predicate evaluateWithObject:self];
}

@end
