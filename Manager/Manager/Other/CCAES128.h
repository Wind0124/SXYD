//
//  CCAES128.h
//  Srpingrass
//
//  Created by Wind on 2017/5/6.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAES128 : NSObject

+(NSString *)aes128_encryptKey:(NSString *)key Encrypttext:(NSString *)text;  //加密
+(NSString *)aes128_decryptKey:(NSString *)key Decrypttext:(NSString *)text;  //解密

+(NSData *)AES128ParmEncryptWithKey:(NSString *)key EncryptData:(NSData *)data;   //加密
+(NSData *)AES128ParmDecryptWithKey:(NSString *)key DecryptData:(NSData *)data;   //解密


@end
