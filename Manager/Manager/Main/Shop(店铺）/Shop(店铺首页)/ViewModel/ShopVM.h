//
//  ShopVM.h
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShopFinishedBlock)(NSDictionary * _Nullable result);
typedef void(^ShopFailedBlock)(NSError * _Nullable error);

@interface ShopVM : NSObject

// 滚动banner数据
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
// 广告数据
@property (nonatomic, strong) NSMutableArray *categoryArray;
// 头条公告数据
@property (nonatomic, strong) NSMutableArray *headlineArray;
// 专区数据
@property (nonatomic, strong) NSMutableArray * activityArray;

/**
 banner
 */
-(void)requestBannerFinish:(void(^)(BOOL success))block;

/**
 类目列表
 */
-(void)requestCategoryFinish:(void(^)(BOOL success))block;

/**
 头条消息 公告
 */
-(void)requestHeadlineFinish:(void(^)(BOOL success))block;

/**
 首页专题
 */
-(void)requestActivityFinish:(void(^)(BOOL success))block;

// 获取用户数据
- (void)getUserData:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
