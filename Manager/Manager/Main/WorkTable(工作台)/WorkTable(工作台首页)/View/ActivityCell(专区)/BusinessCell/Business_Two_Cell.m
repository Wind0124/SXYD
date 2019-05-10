//
//  Business_Two_Cell.m
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Business_Two_Cell.h"
#import "GoodsView1.h"

@implementation Business_Two_Cell
@synthesize businessArray = _businessArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = hexStringToColor(COLOR_Background);

    for (int i = 0; i < 2; i++) {
        GoodsView1 *view = [self.contentView viewWithTag:100 + i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToBusiness:)];
        [view addGestureRecognizer:tap];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusinessArray:(NSArray *)businessArray {
    [super setBusinessArray:businessArray];
    _businessArray = businessArray;
    for (int i = 0; i < 2; i++) {
        GoodsView1 *view = [self.contentView viewWithTag:100 + i];
        view.hidden = YES;
    }
    for (int i = 0; i < businessArray.count; i++) {
        ActivityBusinessModel *model = businessArray[i];
        GoodsView1 *view = [self.contentView viewWithTag:100 + i];
        view.hidden = NO;
        [view setModel:model];
    }
}

- (void)jumpToBusiness:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    NSInteger index = view.tag - 100;
    if (index + 1 > self.businessArray.count) {
        return;
    }
    ActivityBusinessModel *model = self.businessArray[index];
    if (self.actionBlock) {
        self.actionBlock(model);
    }
}

@end
