//
//  ShopBusinessSelectCell.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopBusinessSelectCell.h"
#import "ShopBusinessView.h"

@interface ShopBusinessSelectCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ShopBusinessSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.scrollView];
        self.selectIndex = 0;
        [self addBusinessView];
    }
    return self;
}

- (void)addBusinessView {
    CGFloat space = 15;
    CGFloat width = 140;
    CGFloat height = 50;
    for (int i = 0; i < 10; i++) {
        ShopBusinessView *view = [[ShopBusinessView alloc] initWithFrame:CGRectMake(space + (space + width) * i, 15, width, height)];
        view.tag = 1000 + i;
        view.isSelected = (self.selectIndex == i);
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

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.whiteColor;
    }
    return _scrollView;
}

@end
