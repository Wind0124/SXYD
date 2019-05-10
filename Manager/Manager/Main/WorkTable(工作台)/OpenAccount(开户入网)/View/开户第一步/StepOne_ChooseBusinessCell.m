//
//  StepOne_ChooseBusiness.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepOne_ChooseBusinessCell.h"
#import "ShopBusinessView.h"

@interface StepOne_ChooseBusinessCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation StepOne_ChooseBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectIndex = 0;
    [self addBusinessView];
}

#pragma mark - 数据
// 显示档次数据
- (void)setContractArray:(NSMutableArray *)contractArray {
    _contractArray = contractArray;
    for (int i = 0; i < contractArray.count; i++) {
        BusinessContractModel *model = (BusinessContractModel *)contractArray[i];
        ShopBusinessView *view = (ShopBusinessView *)[self.scrollView viewWithTag:(1000 + i)];
        // 是否选中
        view.isSelected = (self.selectIndex == i);
        // 显示合约名称
        view.nameString = model.contractConfigureName;
        view.hidden = NO;
    }
    // 调整scrollview大小
    CGFloat space = 15;
    CGFloat width = 140;
    self.scrollView.contentSize = CGSizeMake(contractArray.count * (space + width) + space, self.scrollView.viewHeight);
}

#pragma mark - UI
- (void)addBusinessView {
    CGFloat space = 15;
    CGFloat width = 140;
    CGFloat height = 50;
    for (int i = 0; i < 10; i++) {
        ShopBusinessView *view = [[ShopBusinessView alloc] initWithFrame:CGRectMake(space + (space + width) * i, 15, width, height)];
        view.tag = 1000 + i;
        view.isSelected = (self.selectIndex == i);
        view.hidden = YES;
        [self.scrollView addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBusiness:)];
        [view addGestureRecognizer:tap];
    }
    self.scrollView.contentSize = CGSizeMake(10 * (space + width) + space, self.scrollView.viewHeight);
}

- (void)selectBusiness:(UITapGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag - 1000;
    CGFloat space = 15;
    CGFloat width = 140;
    CGFloat centerX = (space + width) * tag + space + width / 2;
    CGFloat x;
    if (centerX < SCREEN_WIDTH / 2) {
        x = 0;
    } else if (centerX + SCREEN_WIDTH/2 > self.scrollView.contentSize.width) {
        x = self.scrollView.contentSize.width - SCREEN_WIDTH;
        if (x < 0) {
            x = 0;
        }
    } else {
        x = centerX - SCREEN_WIDTH / 2;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(x, 0);
    }];
    if (self.selectIndex != tag) {
        self.selectBusinessBlock ? self.selectBusinessBlock(tag) : nil;
        ShopBusinessView *selectNewView = (ShopBusinessView *)sender.view;
        selectNewView.isSelected = YES;
        ShopBusinessView *selectOldView = (ShopBusinessView *)[self.scrollView viewWithTag:(1000 + self.selectIndex)];
        selectOldView.isSelected = NO;
        self.selectIndex = tag;
    }
}

@end
