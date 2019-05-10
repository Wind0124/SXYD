//
//  OpenAccountStepCell.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountStepCell.h"

@interface OpenAccountStepCell()

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@end

@implementation OpenAccountStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.oneBtn.layer.cornerRadius = 9;
    self.oneBtn.layer.masksToBounds = YES;
    self.twoBtn.layer.cornerRadius = 9;
    self.twoBtn.layer.masksToBounds = YES;
    self.threeBtn.layer.cornerRadius = 9;
    self.threeBtn.layer.masksToBounds = YES;
}

- (void)setStep:(NSInteger)step {
    _step = step;
    UIColor *unSelectColor = hexStringToColor(@"999999");
    self.oneBtn.backgroundColor = (step >= 1) ? hexStringToColor(COLOR_Btn) : unSelectColor;
    self.oneLabel.textColor = (_step >= 1) ? hexStringToColor(@"333333") : unSelectColor;
    self.twoBtn.backgroundColor = (step >= 2) ? hexStringToColor(COLOR_Btn) : unSelectColor;
    self.twoLabel.textColor = (step >= 2) ? hexStringToColor(@"333333") : unSelectColor;
    self.threeBtn.backgroundColor = (step >= 3) ? hexStringToColor(COLOR_Btn) : unSelectColor;
    self.threeLabel.textColor = (step >= 3) ? hexStringToColor(@"333333") : unSelectColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
