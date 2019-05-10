//
//  CCAES128.m
//  Srpingrass
//
//  Created by Wind on 2017/5/6.
//  Copyright © 2017年 Wind.Cai. All rights reserved.
//

#import "CCAES128.h"
#import <CommonCrypto/CommonCryptor.h>

//AES CBC模式 128位秘钥（sign前16位），偏移量为sign后16位
//补码方式PKCS5Padding，加密结果编码方式：base64
@implementation CCAES128

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
//加密
+ (NSString *)aes128_encryptKey:(NSString *)key Encrypttext:(NSString *)text{
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    //对数据进行加密
    NSData *result = [CCAES128 AES128ParmEncryptWithKey:key EncryptData:data];
    
    //Data转换为2进制字符串
    //    if (result && result.length > 0) {
    //
    //        Byte *datas = (Byte*)[result bytes];
    //        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
    //        for(int i = 0; i < result.length; i++){
    //            [output appendFormat:@"%02x", datas[i]];
    //        }
    //        return output;
    //    }
    //Data转化为base64后的字符串
    if (result && result.length > 0) {
        NSString *ret = base64_encode_data(result);
        return ret;
    }
    
    return nil;

}
//解密
+ (NSString *)aes128_decryptKey:(NSString *)key Decrypttext:(NSString *)text{
    // 字符串转换为2进制Data
    //    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    //    unsigned char whole_byte;
    //    char byte_chars[3] = {'\0','\0','\0'};
    //    int i;
    //    for (i=0; i < [self length] / 2; i++) {
    //        byte_chars[0] = [self characterAtIndex:i*2];
    //        byte_chars[1] = [self characterAtIndex:i*2+1];
    //        whole_byte = strtol(byte_chars, NULL, 16);
    //        [data appendBytes:&whole_byte length:1];
    //    }
    // 字符串转化为base64后的Data
    NSData *data = base64_decode(text);
    //对数据进行解密
    NSData* result = [self AES128ParmDecryptWithKey:key DecryptData:data];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


//加密
+(NSData *)AES128ParmEncryptWithKey:(NSString *)key EncryptData:(NSData *)data{
    NSString *aesIV = [key substringWithRange:NSMakeRange(16, 16)];
    key = [key substringWithRange:NSMakeRange(0, 16)];
//    NSLog(@"128位秘钥===%@,偏移量===%@",key,aesIV);
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding ,
                                          keyPtr, kCCBlockSizeAES128,
                                          [aesIV UTF8String],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;

}
//解密
+(NSData *)AES128ParmDecryptWithKey:(NSString *)key DecryptData:(NSData *)data
{
    NSString *aesIV = [key substringWithRange:NSMakeRange(16, 16)];
    key = [key substringWithRange:NSMakeRange(0, 16)];
//    NSLog(@"128位秘钥===%@,偏移量===%@",key,aesIV);
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding ,
                                          keyPtr, kCCBlockSizeAES128,
                                          [aesIV UTF8String],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    free(buffer);
    return nil;
}



@end
