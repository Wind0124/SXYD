//
//  ShopVM.m
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import "ShopVM.h"

@implementation ShopVM

/**
 banner
 */
-(void)requestBannerFinish:(void(^)(BOOL success))block {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": HomePageBanner},
                           };
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        if (object) {
            PageModel *pageModel = (PageModel *)object;
            NSArray *dataArray = pageModel.datas;
            NSMutableArray *recordsArray = [NSMutableArray array];
            self.imageArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *dic = dataArray[i];
                AdvertInfoModel *infoModel = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
//                NSLog(@"滚动广告栏:%@", infoModel);
                [recordsArray addObject:infoModel];
                // 处理图片地址
                [self.imageArray addObject:[NSString getFullImageUrlString:infoModel.image server:CurrentUser.imgServerPrefix]];
            }
            [self.bannerArray removeAllObjects];
            [self.bannerArray addObjectsFromArray:recordsArray];
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

/**
 类目列表
 */
-(void)requestCategoryFinish:(void(^)(BOOL success))block {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": HomePageBusisnessAdvert},
                           };
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        if (object) {
            PageModel *pageModel = (PageModel *)object;
            NSArray *dataArray = pageModel.datas;
            NSMutableArray *recordsArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *dic = dataArray[i];
                AdvertInfoModel *infoModel = [[AdvertInfoModel alloc] initWithDictionary:dic error:nil];
                //                NSLog(@"业务广告:%@", infoModel);
                [recordsArray addObject:infoModel];
            }
            [self.categoryArray removeAllObjects];
            [self.categoryArray addObjectsFromArray:recordsArray];
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

/**
 头条消息 公告
 */
-(void)requestHeadlineFinish:(void(^)(BOOL success))block {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"dictionaryDisplayPositionCode": HomePageMessage},
                           };
    [VPAPI getMessageNoticeWithDic:para block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            PageModel *pageModel = (PageModel *)object;
            [self.headlineArray removeAllObjects];
            [self.headlineArray addObjectsFromArray:pageModel.datas];
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

/**
 首页专题
 */
- (void)requestActivityFinish:(void(^)(BOOL success))block {
    NSString *supplierName = CurrentUser.defaultSupplierName ?: @"";
    NSString *supplierId = CurrentUser.defaultSupplierId ?: @"";
    NSString *shopId = CurrentUser.shopId ?: @"";
    NSDictionary *para = @{@"dictionaryOneLevleTypeCode": @"prefectureActivity",
                           @"supplierName": supplierName,
                           @"supplierId": supplierId,
                           @"userShopId": shopId,
                           };
    [VPAPI2 getShopPrefectureWith:para block:^(NSArray *objects, HeadModel *error) {
        if (objects) {
            [self.activityArray removeAllObjects];
            [self.activityArray addObjectsFromArray:objects];
            block ? block(YES) : nil;
        } else {
            block ? block(NO) : nil;
        }
    }];
}

// 获取用户数据
- (void)getUserData:(void(^)(BOOL success))block {
    [VPAPI getUserInfo:^(BOOL succeeded, HeadModel *error) {
        if (block) {
            block(succeeded);
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc]init];
    }
    return _bannerArray;
}
- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc]init];
    }
    return _categoryArray;
}
- (NSMutableArray *)headlineArray {
    if (!_headlineArray) {
        _headlineArray = [[NSMutableArray alloc]init];
    }
    return _headlineArray;
}
- (NSMutableArray *)activityArray {
    if (!_activityArray) {
        _activityArray = [[NSMutableArray alloc]init];
    }
    return _activityArray;
}

@end
