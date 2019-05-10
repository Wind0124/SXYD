//
//  BusinessCell.m
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusinessArray:(NSArray *)businessArray {
    _businessArray = businessArray;
}
@end
