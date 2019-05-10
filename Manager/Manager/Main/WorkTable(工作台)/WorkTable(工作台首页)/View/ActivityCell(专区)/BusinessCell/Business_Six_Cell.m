//
//  Business_Six_Cell.m
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Business_Six_Cell.h"
#import "GoodsView2.h"

@implementation Business_Six_Cell
@synthesize businessArray = _businessArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = hexStringToColor(COLOR_Background);
    
    for (int i = 0; i < 6; i++) {
        GoodsView2 *view = [self.contentView viewWithTag:100 + i];
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
    for (int i = 0; i < 6; i++) {
        GoodsView2 *view = [self.contentView viewWithTag:100 + i];
        view.hidden = YES;
    }
    for (int i = 0; i < businessArray.count; i++) {
        ActivityBusinessModel *model = businessArray[i];
        GoodsView2 *view = [self.contentView viewWithTag:100 + i];
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
