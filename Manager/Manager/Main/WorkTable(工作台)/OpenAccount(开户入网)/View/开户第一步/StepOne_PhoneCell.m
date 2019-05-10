//
//  StepOne_PhoneCell.m
//  Manager
//
//  Created by vpclub on 2019/1/5.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "StepOne_PhoneCell.h"

@interface StepOne_PhoneCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cornerImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation StepOne_PhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.bgView.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    self.cornerImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *viewColor = self.bgView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.bgView.backgroundColor = viewColor;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.bgView.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.cornerImgView.hidden = NO;
    } else {
        self.bgView.layer.borderColor = hexStringToColor(@"E0DFDF").CGColor;
        self.cornerImgView.hidden = YES;
    }
    self.bgView.layer.masksToBounds = YES;
}

- (void)setModel:(OpenAccountMobileModel *)model {
    _model = model;
    self.phoneLabel.text = model.mobile;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f", model.fee.integerValue/10000.0 ];
}

@end
