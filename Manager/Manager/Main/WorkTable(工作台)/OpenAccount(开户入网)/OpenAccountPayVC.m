//
//  OpenAccountPayVC.m
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "OpenAccountPayVC.h"
#import "UIImage+LXDCreateBarcode.h"

@interface OpenAccountPayVC ()

@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImgView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSString *qrCodeString;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSTimer *payTimer;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@end

@implementation OpenAccountPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"二维码支付";
    self.num = -1;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.totalFee];
    [self getQRCode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.payTimer) {
        [self.payTimer invalidate];
        self.payTimer = nil;
    }
}

#pragma mark - 网络、按钮
- (void)getQRCode {
//    @"frontUrl": @"shanxiyidongyundian",

//    NSDictionary *para = @{@"orderId": self.openAccountInfo.orderId,
//                           @"payCode": @"5001",
//                           };
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.openAccountInfo.orderId, @"orderId",
                          @"5001", @"payCode",
                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 payOrderWithDic:para block:^(NSString *string, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (string) {
            // 显示二维码
            NSLog(@"支付链接：%@",string);
            self.qrCodeString = string;
            [self.QRCodeImgView setImage:[UIImage imageOfQRFromURL:string]];
            // 二维码有效期倒计时
            self.num = 120;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            // 定时请求支付状态
            self.payTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getPayStatus) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.payTimer forMode:NSRunLoopCommonModes];
            [self.payTimer fire];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 倒计时
- (void)countDown {
    if (self.num <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        // 超时
        
    } else {
        self.num -= 1;
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%zd", self.num];
    }
}

// 定时请求支付状态
- (void)getPayStatus {
//    NSDictionary *para = @{@"orderId": self.openAccountInfo.orderId};
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.openAccountInfo.orderId, @"orderId",
                          nil];
    [VPAPI2 queryPayStatusWithDic:para block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            self.openAccountPaySuccessBlock ? self.openAccountPaySuccessBlock() : nil;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"%@%@", error.code, error.msg);
            self.logLabel.text = [NSString stringWithFormat:@" 时间：%@\n 手机号：%@\n SIM卡：%@\n 订单号：%@\n 支付状态：%@", [NSDate date], self.openAccountInfo.mobileModel.mobile, self.openAccountInfo.SIMString, self.openAccountInfo.orderId, @"未完成"];
        }
    }];
}

// 刷新支付二维码
- (IBAction)refreshAction:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self.payTimer invalidate];
    self.payTimer = nil;
    [self getQRCode];
}

@end
