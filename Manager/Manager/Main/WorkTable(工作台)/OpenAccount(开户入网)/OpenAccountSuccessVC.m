//
//  OpenAccountSuccessVC.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountSuccessVC.h"
#import "UIViewController+BackButtonHandler.h"

@interface OpenAccountSuccessVC ()<UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *comboLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractLabel;

@end

@implementation OpenAccountSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提交成功";
    self.orderLabel.text = self.openAccountInfo.orderId;
    self.comboLabel.text = self.openAccountInfo.model.businessName;
    self.cityLabel.text = CurrentUser.crmCityName;
    self.phoneLabel.text = self.openAccountInfo.mobileModel.mobile;
    self.nameLabel.text = self.openAccountInfo.idModel.custName;
    self.IDLabel.text = self.openAccountInfo.idModel.psptId;
    self.addressLabel.text = self.openAccountInfo.idModel.custCertAddr;
    self.contractLabel.text = self.openAccountInfo.contractModel.contractConfigureName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 禁用手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

//在这个方法里写返回按钮的事件处理
- (BOOL)navigationShouldPopOnBackButton {
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //这里写要处理的代码
    [self.navigationController popToRootViewControllerAnimated:YES];

    return NO;//返回NO 不会执行
}

@end
