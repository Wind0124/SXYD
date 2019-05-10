//
//  AccountOrderCenterDetailVC.m
//  Manager
//
//  Created by vpclub on 2019/2/18.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "AccountOrderCenterDetailVC.h"

@interface AccountOrderCenterDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *preSaveFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation AccountOrderCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单详情";
    self.actionBtn.layer.cornerRadius = 3;
    self.actionBtn.layer.borderWidth = 1;
    self.actionBtn.layer.borderColor = hexStringToColor(@"0084CF").CGColor;
    self.actionBtn.layer.masksToBounds = YES;
    // 显示数据
    self.phoneLabel.text = self.model.mobile;
        self.dateLabel.text = self.model.billCreateTime;
    self.cityLabel.text = self.model.cityName;
    self.activityLabel.text = self.model.businessGradeName;
    self.businessLabel.text = self.model.gradeName;
    self.nameLabel.text = self.model.custName;
//    self.phoneFeeLabel.text = self.model.
//    self.preSaveFeeLabel.text = self.model.
//    self.totalFeeLabel.text = self.model.
    self.payStyleLabel.text = @"支付宝扫码支付";// self.model.payType
    self.orderLabel.text = [NSString stringWithFormat:@"%@", self.model.info_id];
    switch (self.type) {
        case 0:
            {
                self.statusLabel.text = @"待激活";
                self.actionView.hidden = NO;
                [self.actionBtn setTitle:@"去激活" forState:UIControlStateNormal];
            }
            break;
        case 1:
        {
            self.statusLabel.text = @"待支付";
            self.actionView.hidden = NO;
            [self.actionBtn setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"已完成";
            self.actionView.hidden = YES;
        }
        case 3:
        {
            self.statusLabel.text = @"已取消";
            self.actionView.hidden = YES;
        }
        default:
            
            break;
    }
}

#pragma mark - 内部事件
- (IBAction)action:(UIButton *)sender {
    NSLog(@"事件");
    if (self.type == 0) {
        // 激活
        
    } else if (self.type == 1) {
        // 支付
        
    }
}

@end
