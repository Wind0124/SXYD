//
//  ShopSettingCell.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopSettingCell.h"

@interface ShopSettingCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

@implementation ShopSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusBtn.layer.cornerRadius = 3;
    self.statusBtn.layer.borderWidth = 1;
    self.statusBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;// @"979797"
    [self.statusBtn setTitle:@"已上架" forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
    
    [self.coverImgView setImage:[UIImage imageNamed:@"临时背景"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)switchStatusAction:(UIButton *)sender {
    NSLog(@"切换上下架");
    self.switchStatusBlock ? self.switchStatusBlock() : nil;
}

@end
