//
//  Business_N_Cell.m
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Business_N_Cell.h"
#import "GoodsView2.h"

@interface Business_N_Cell()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation Business_N_Cell
@synthesize businessArray = _businessArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat width = 80;
    CGFloat height = 140;
    CGFloat space = 5;
    for (int i = 0; i < 20; i++) {
        GoodsView2 *view = [[GoodsView2 alloc] initWithFrame:CGRectMake(10 + i * (width + space), 10, width, height)];
        view.tag = 100 + i;
        view.nameLabel.numberOfLines = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToBusiness:)];
        [view addGestureRecognizer:tap];
        [self.scrollView addSubview:view];
        
//        view.backgroundColor = [UIColor greenColor];
//        view.imgView.backgroundColor = [UIColor redColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setBusinessArray:(NSArray *)businessArray {
    [super setBusinessArray:businessArray];
    _businessArray = businessArray;
    for (UIView *view in self.scrollView.subviews) {
        view.hidden = YES;
    }
    for (int i = 0; i < businessArray.count; i++) {
        ActivityBusinessModel *model = businessArray[i];
        GoodsView2 *view = [self.scrollView viewWithTag:100 + i];
        view.hidden = NO;
        [view setModel:model];
    }
    CGFloat width = 80;
    CGFloat height = 140;
    CGFloat space = 5;
    self.scrollView.contentSize = CGSizeMake(10 + (width + space) * businessArray.count, height);

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
