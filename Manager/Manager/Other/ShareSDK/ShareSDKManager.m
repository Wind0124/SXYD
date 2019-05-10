//
//  ShareSDKManager.m
//  Manager
//
//  Created by vpclub on 2018/12/8.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShareSDKManager.h"

@implementation ShareSDKManager

+ (instancetype)shareInstanceShareSDKManager {
    static ShareSDKManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ShareSDKManager alloc] init];
    });
    return instance;
}

#pragma 分享的相关配置
- (void)connectShareSDK {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信 等待微信开放平台审核完成才有id和secret
//        [platformsRegister setupWeChatWithAppId:@"wx617c77c82218ea2c" appSecret:@"c7253e5289986cf4c4c74d1ccc185fb1"];
        [platformsRegister setupWeChatWithAppId:@"wx1c24db16686f9f0a" appSecret:@"c07510f0efc97c4e14b4da469cec83cb"];

//        //QQ
//        [platformsRegister setupQQWithAppId:@"100371282" appkey:@"aed9b0303e3ed1e27bae87c33761161d"];
//        //新浪
//        [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];
//        //Facebook
//        [platformsRegister setupFacebookWithAppkey:@"1412473428822331" appSecret:@"a42f4f3f867dc947b9ed6020c2e93558" displayName:@"shareSDK"];
//        //Twitter
//        [platformsRegister setupTwitterWithKey:@"viOnkeLpHBKs6KXV7MPpeGyzE" secret:@"NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey" redirectUrl:@"http://mob.com"];
//        //支付宝
//        [platformsRegister setupAliSocialWithAppId:@"2017062107540437"];
//        //豆瓣
//        [platformsRegister setupDouBanWithApikey:@"02e2cbe5ca06de5908a863b15e149b0b" appSecret:@"9f1e7b4f71304f2f" redirectUrl:@"http://www.sharesdk.cn"];
//        //腾讯微博
//        [platformsRegister setupTencentWeiboWithAppkey:@"801307650" appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c" redirectUrl:@"http://www.sharesdk.cn"];
//        //SMS
//        [platformsRegister setupSMSOpenCountryList:NO];
    }];
}


- (void)shareWithModel:(ShareSDKModel *)shareModel andType:(SSDKPlatformType)type block:(ShareCodeResultBlock)block {
    // 分享url反转码
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    NSMutableArray *imageArray = [NSMutableArray array];
    if (shareModel.shareImg) {
        [imageArray addObject:shareModel.shareImg];
        [shareParams SSDKSetupShareParamsByText:shareModel.shareDesc
                                         images:imageArray
                                            url:[NSURL URLWithString:shareModel.shareLink]
                                          title:shareModel.shareTitle
                                           type:SSDKContentTypeImage];
    } else {
        [imageArray addObject:shareModel.shareImgurl];
        [shareParams SSDKSetupShareParamsByText:shareModel.shareDesc
                                         images:imageArray
                                            url:[NSURL URLWithString:shareModel.shareLink]
                                          title:shareModel.shareTitle
                                           type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch(state) {
            case SSDKResponseStateBegin:
                if (block) {
                    NSLog(@"分享开始");
                    block(SSDKResponseStateBegin);
                }
                break;
                
            case SSDKResponseStateSuccess:
                if (block) {
                    NSLog(@"分享成功");
                    block(SSDKResponseStateSuccess);
                }
                break;
                
            case SSDKResponseStateFail:
//                [self alertWithTitle:@"分享失败" msg:[NSString stringWithFormat:@"%@",error] cancelTitle:@"OK"];
                if (block) {
                    NSLog(@"分享失败");
                    block(SSDKResponseStateFail);
                }
                break;
                
            case SSDKResponseStateCancel:
                if (block) {
                    NSLog(@"分享取消");
                    block(SSDKResponseStateCancel);
                }
            default:
                break;
        }
    }];
}
@end
