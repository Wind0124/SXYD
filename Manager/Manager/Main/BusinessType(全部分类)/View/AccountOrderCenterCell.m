//
//  AccountOrderCenterCell.m
//  Manager
//
//  Created by vpclub on 2019/2/18.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "AccountOrderCenterCell.h"

@interface AccountOrderCenterCell()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end

@implementation AccountOrderCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.actionBtn.layer.cornerRadius = 3;
    self.actionBtn.layer.borderWidth = 1;
    self.actionBtn.layer.borderColor = hexStringToColor(@"0084CF").CGColor;
    self.actionBtn.layer.masksToBounds = YES;
    self.detailBtn.layer.cornerRadius = 3;
    self.detailBtn.layer.borderWidth = 1;
    self.detailBtn.layer.borderColor = hexStringToColor(@"979797").CGColor;
    self.detailBtn.layer.masksToBounds = YES;
}

- (void)setModel:(OrderCenterModel *)model {
    _model = model;
    self.phoneLabel.text = model.mobile;
    self.dateLabel.text = model.billCreateTime;
    self.cityLabel.text = model.cityName;
    self.activityLabel.text = model.businessGradeName;
    self.businessLabel.text = model.gradeName;
    self.nameLabel.text = model.custName;
    self.actionBtn.hidden = NO;
    switch (self.type) {
        case 0:
            // 待激活
            [self.actionBtn setTitle:@"待激活" forState:UIControlStateNormal];
            break;
        case 1:
            // 待支付
            [self.actionBtn setTitle:@"待支付" forState:UIControlStateNormal];
            break;
        default:
            // 已完成，已取消
            self.actionBtn.hidden = YES;
            break;
    }
}

- (IBAction)action:(UIButton *)sender {
    NSLog(@"激活或支付");
    self.ClickBlock ? self.ClickBlock(self.type) : nil;
}

- (IBAction)detailAction:(UIButton *)sender {
    NSLog(@"跳转详情");
    self.ClickBlock ? self.ClickBlock(-1) : nil;
}

@end
