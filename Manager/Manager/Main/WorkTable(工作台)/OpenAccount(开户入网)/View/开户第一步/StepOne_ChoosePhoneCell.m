//
//  StepOne_ChoosePhoneCell.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepOne_ChoosePhoneCell.h"

@interface StepOne_ChoosePhoneCell()


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end
@implementation StepOne_ChoosePhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.phoneLabel.hidden = YES;
    self.tipLabel.hidden = YES;
    self.feeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OpenAccountMobileModel *)model {
    _model = model;
    self.phoneLabel.hidden = NO;
    self.phoneLabel.text = model.mobile;
    self.tipLabel.hidden = NO;
    self.feeLabel.hidden = NO;
    self.feeLabel.text = [NSString stringWithFormat:@"%.0f元", model.fee.integerValue / 10000.0];
}

- (IBAction)choosePhoneAction:(UITapGestureRecognizer *)sender {
    self.StepOne_ChoosePhoneAction ? self.StepOne_ChoosePhoneAction() : nil;
}

@end
