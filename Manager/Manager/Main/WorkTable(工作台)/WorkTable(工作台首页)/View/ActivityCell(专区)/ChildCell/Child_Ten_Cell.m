//
//  Child_Ten_Cell.m
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Child_Ten_Cell.h"

@implementation Child_Ten_Cell
@synthesize childArray = _childArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChildArray:(NSArray *)childArray {
    [super setChildArray:childArray];
    _childArray = childArray;
    for (int i = 0; i < 10; i++) {
        UIButton *btn = [self viewWithTag:i + 100];
        btn.hidden = YES;
    }
    for (int i = 0; i < childArray.count; i++) {
        UIButton *btn = [self viewWithTag:i + 100];
        if (btn) {
            btn.hidden = NO;
            ActivityChildModel *model = childArray[i];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.cover server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)pictureAction:(UIButton *)sender {
    // 根据按钮的（tag - 100）获取对应的数据
    // 若要调整显示顺序，则改变按钮的tag顺序值
    NSInteger index = sender.tag - 100;
    if (index + 1 > self.childArray.count) {
        return;
    }
    ActivityChildModel *childModel = self.childArray[index];
    if (self.pictureActionBlock) {
        self.pictureActionBlock(childModel);
    }
}
@end
