//
//  PreSaveFeeView.m
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "PreSaveFeeView.h"

@interface PreSaveFeeView()


@end

@implementation PreSaveFeeView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {

    } else {
        self = [super init];
    }
    return self;
}

- (void)setFee:(NSString *)fee {
    _fee = fee;
    NSArray *feeArray = [fee componentsSeparatedByString:@","];
    CGFloat y = 55;
    CGFloat space = 20;
    CGFloat width = 95;
    CGFloat heigh = 35;
    for (int i = 0; i < feeArray.count; i++) {
        UIView *feeView = [[UIView alloc] initWithFrame:CGRectMake(space + i * (space+width), y, width, heigh)];
        feeView.tag = 10 + i;
        feeView.layer.borderWidth = 1;
        feeView.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
        feeView.layer.cornerRadius = 4;
        feeView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPreFee:)];
        [feeView addGestureRecognizer:tap];
        [self addSubview:feeView];

        UIImageView *cornerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        cornerImgView.image = [UIImage imageNamed:@"shop_business_check"];
        cornerImgView.tag = 1000;
        cornerImgView.hidden = YES;
        [feeView addSubview:cornerImgView];
        
        UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, feeView.viewWidth, feeView.viewHeight)];
        feeLabel.font = [UIFont systemFontOfSize:14];
        feeLabel.textColor = hexStringToColor(@"333333");
        NSString *fee = feeArray[i];
        feeLabel.text = [NSString stringWithFormat:@"%.2f元", fee.integerValue / 10000.0];
        feeLabel.textAlignment = NSTextAlignmentCenter;
        feeLabel.tag = 2000;
        [feeView addSubview:feeLabel];
        
        if (i == 0) {// 默认选中第一个
            [self selectPreFee:tap];
        }
    }
}

- (void)selectPreFee:(UITapGestureRecognizer *)sender {
    NSArray *feeArray = [self.fee componentsSeparatedByString:@","];
    for (int i = 0; i < feeArray.count; i++) {
        UIView *view = [self viewWithTag:(10+i)];
        view.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
        view.layer.masksToBounds = YES;
        UIImageView *cornerImgView = [view viewWithTag:1000];
        cornerImgView.hidden = YES;
        UILabel *feeLabel = [view viewWithTag:2000];
        feeLabel.textColor = hexStringToColor(@"333333");
    }
    // 选中的价格
    UIView *selectView = sender.view;
    selectView.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    selectView.layer.masksToBounds = YES;
    UIImageView *cornerImgView = [selectView viewWithTag:1000];
    cornerImgView.hidden = NO;
    UILabel *feeLabel = [selectView viewWithTag:2000];
    feeLabel.textColor = hexStringToColor(COLOR_Btn);
    
    NSInteger selectIndex = sender.view.tag - 10;
    self.selectFeeBlock ? self.selectFeeBlock(feeArray[selectIndex]) : nil;
    
}


@end
