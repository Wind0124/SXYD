//
//  BusinessAdvertCell.h
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessAdvertCell : UITableViewCell

typedef void (^ModelActionBlock)(BaseModel* baseModel);

@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,copy) ModelActionBlock block;

@end

NS_ASSUME_NONNULL_END
