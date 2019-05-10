//
//  WorkTableVM.m
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "WorkTableVM.h"

@implementation WorkTableVM

// 本日业务量
- (void)requestTodayAllStatisticsNumber:(WorkFinishedBlock _Nullable)finishedBlock failed:(WorkFailedBlock _Nullable)failedBlock {
    NSString *channelCode = CurrentUser.defaultChannelCode ?: @"";
    NSDictionary *para = @{@"channelCode": channelCode,
                           @"statisticsType" : @"2",
                           };
    [VPAPI getTodayOrMonthWithDic:para block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            // 保存数据
            self.todayModel = (AllStatisticsModel *)object;
            if (finishedBlock) {
                finishedBlock(nil);
            }
        } else {
            if (failedBlock) {
                failedBlock(nil);
            }
        }
    }];
}
// 本月业务量
- (void)requestMonthAllStatisticsNumber:(WorkFinishedBlock _Nullable)finishedBlock failed:(WorkFailedBlock _Nullable)failedBlock {
    NSString *channelCode = CurrentUser.defaultChannelCode ?: @"";
    NSDictionary *para = @{@"channelCode": channelCode,
                           @"statisticsType" : @"3",
                           };
    [VPAPI getTodayOrMonthWithDic:para block:^(BaseModel *object, HeadModel *error) {
        if (object) {
            // 保存数据
            self.monthModel = (AllStatisticsModel *)object;
            if (finishedBlock) {
                finishedBlock(nil);
            }
        } else {
            if (failedBlock) {
                failedBlock(nil);
            }
        }
    }];
}

/**
 工号列表
 */
- (void)getEmployeeList:(WorkFinishedBlock)finishedBlock failed:(WorkFailedBlock)failedBlock {
    [VPAPI getListEmployeeNumber:^(NSArray *objects, HeadModel *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
//            [self alertWithMessage:message];
            if (failedBlock) {
                failedBlock(message);
            }
        } else {
            if (objects.count > 0) {
                [self.employeeArray removeAllObjects];
                [self.employeeArray addObjectsFromArray:objects];
                if (finishedBlock) {
                    finishedBlock(nil);
                }
            } else {
                if (failedBlock) {
                    failedBlock(@"工号列表为空");
                }
            }
        }
    }];
}

/**
 类目列表
 */
-(void)requestCategoryFinish:(WorkFinishedBlock)finishedBlock failed:(WorkFailedBlock)failedBlock {
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : @{@"type": WorkbenchBusiness},
                           };
    [VPAPI getAdvertInfoWithDic:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        if (object) {
            [self.categoryArray removeAllObjects];
            [self.categoryArray addObjectsFromArray:array];
            if (finishedBlock) {
                finishedBlock(nil);
            }
        } else {
            if (failedBlock) {
                failedBlock(nil);
            }
        }
    }];
}

/**
 首页专题
 */
- (void)requestActivityFinish:(void(^)(BOOL success))block {
    NSDictionary *para = @{@"dictionaryOneLevleTypeCode": @"workbenchPrefecture",
                           };
    [VPAPI getActivityInfoWithDic:para block:^(NSArray *objects, HeadModel *error) {
        if (objects) {
            [self.activityArray removeAllObjects];
            [self.activityHeightArray removeAllObjects];
            [self.activityCellArray removeAllObjects];
            [self.activityArray addObjectsFromArray:objects];
            for (int i = 0; i < self.activityArray.count; i++) {
                float fatherHeight = 0;
                float sonHeight = 0;
                NSString *fatherCellName = @"";
                NSString *sonCellName = @"";
                ActivityModel *model = self.activityArray[i];
                // displayName：显示名称，displayNameAndPicture：显示名称和图片，displayPicture：显示图片，nodisplay：不显示
                NSString *fatherStyle = model.dictionaryStyleCode;
                float fatherPictureHeight = SCREEN_WIDTH / 750 * 200;
                if ([fatherStyle isEqualToString:@"nodisplay"]) {
                    fatherHeight = 0;
                    fatherCellName = @"ActivityHeadCell";
                } else if ([fatherStyle isEqualToString:@"displayName"]) {
                    fatherHeight = 50;
                    fatherCellName = @"ActivityHeadCell";
                } else if ([fatherStyle isEqualToString:@"displayPicture"]) {
                    fatherHeight = fatherPictureHeight;
                    fatherCellName = @"ActivityHeadCell";
                } else if ([fatherStyle isEqualToString:@"displayNameAndPicture"]) {
                    fatherHeight = fatherPictureHeight + 50;
                    fatherCellName = @"ActivityHeadCell";
                }
                if (model.childSubject.integerValue == 1) {// 有子专区
                    // childNodisplay：不显示，childPrefectureFourPicture：4图，fivePicture：5图，tenPicture：10图，threePicture：3图，twoPicture：2图，simpleGraph：单图
                    NSString *sonStyle = model.dictionaryChildStyleCode;
                    if ([sonStyle isEqualToString:@"childNodisplay"]) {
                        sonHeight = 0;
                        sonCellName = @"ChildCell";
                    } else if ([sonStyle isEqualToString:@"simpleGraph"]) {
                        sonHeight = SCREEN_WIDTH / 1500 * 550;
                        sonCellName = @"Child_Simple_Cell";
                    } else if ([sonStyle isEqualToString:@"twoPicture"]) {
                        sonHeight = SCREEN_WIDTH / 750 * 460;
                        sonCellName = @"Child_Two_Cell";
                    } else if ([sonStyle isEqualToString:@"threePicture"]) {
                        sonHeight = SCREEN_WIDTH / 750 * 420;
                        sonCellName = @"Child_Three_Cell";
                    } else if ([sonStyle isEqualToString:@"childPrefectureFourPicture"]) {
                        sonHeight = SCREEN_WIDTH / 750 * 420;
                        sonCellName = @"Child_Four_Cell";
                    } else if ([sonStyle isEqualToString:@"fivePicture"]) {
                        sonHeight = SCREEN_WIDTH / 750 * 500;
                        sonCellName = @"Child_Five_Cell";
                    } else if ([sonStyle isEqualToString:@"tenPicture"]) {
                        sonHeight = SCREEN_WIDTH / 1500 * 1300;
                        sonCellName = @"Child_Ten_Cell";
                    }
                } else {// 商品
                    // businessNodisplay：不显示，doublePicture：双图，sixPicture：6图，fourAndNPicture：4+N图，fourPicture：4图，NPicture：N图，singlePicture：单图
                    NSString *businessStyle = model.dictionaryGoodsStyleCode;
                    if ([businessStyle isEqualToString:@"businessNodisplay"]) {
                        sonHeight = 0;
                        sonCellName = @"BusinessCell";
                    } else if ([businessStyle isEqualToString:@"singlePicture"]) {
                        sonHeight = SCREEN_WIDTH / 750 * 240;
                        sonCellName = @"Business_Single_Cell";
                    } else if ([businessStyle isEqualToString:@"doublePicture"]) {
                        sonHeight = 80;
                        sonCellName = @"Business_Two_Cell";
                    } else if ([businessStyle isEqualToString:@"fourPicture"]) {
                        sonHeight = 160;
                        sonCellName = @"Business_Four_Cell";
                    } else if ([businessStyle isEqualToString:@"sixPicture"]) {
                        sonHeight = ((SCREEN_WIDTH - 5 * 2) / 3 + 70) * 2;
                        sonCellName = @"Business_Six_Cell";
                    } else if ([businessStyle isEqualToString:@"NPicture"]) {
                        sonHeight = 150;
                        sonCellName = @"Business_N_Cell";
                    } else if ([businessStyle isEqualToString:@"fourAndNPicture"]) {
                        sonHeight = 310;
                        sonCellName = @"Business_FourAndN_Cell";
                    }
                }
                [self.activityHeightArray addObject:@[[NSNumber numberWithFloat:fatherHeight], [NSNumber numberWithFloat:sonHeight]]];
                [self.activityCellArray addObject:sonCellName];
            }
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

#pragma mark - 懒加载
- (NSMutableArray *)employeeArray {
    if (!_employeeArray) {
        _employeeArray = [[NSMutableArray alloc]init];
    }
    return _employeeArray;
}

- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc]init];
    }
    return _categoryArray;
}
- (NSMutableArray *)activityArray {
    if (!_activityArray) {
        _activityArray = [[NSMutableArray alloc]init];
    }
    return _activityArray;
}
- (NSMutableArray *)activityHeightArray {
    if (!_activityHeightArray) {
        _activityHeightArray = [NSMutableArray array];
    }
    return _activityHeightArray;
}
- (NSMutableArray *)activityCellArray {
    if (!_activityCellArray) {
        _activityCellArray = [NSMutableArray array];
    }
    return _activityCellArray;
}

@end
