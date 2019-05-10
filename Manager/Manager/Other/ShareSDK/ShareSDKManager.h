//
//  ShareSDKManager.h
//  Manager
//
//  Created by vpclub on 2018/12/8.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ShareManger [ShareSDKManager shareInstanceShareSDKManager]

typedef void (^ShareCodeResultBlock)(SSDKResponseState code);


@interface ShareSDKManager : NSObject

+(instancetype)shareInstanceShareSDKManager;
/**
 *  初始化shareSDK的分享账号
 */
-(void)connectShareSDK;

- (void)shareWithModel:(ShareSDKModel *)shareModel andType:(SSDKPlatformType)type block:(ShareCodeResultBlock)block;

@end

NS_ASSUME_NONNULL_END
