//
//  AuthDetailVC.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "AuthDetailVC.h"

@interface AuthDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *unBindBtn;

@end

@implementation AuthDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"授权详情";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    self.unBindBtn.layer.cornerRadius = 4;
    self.unBindBtn.layer.borderWidth = 1;
    self.unBindBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
    self.unBindBtn.layer.masksToBounds = YES;
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameTF.placeholder = self.model.name;
    self.phoneLabel.text = self.model.mobile;
    self.timeLabel.text = self.model.date;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 按钮事件
- (IBAction)closeWarningAction:(UIButton *)sender {
    self.warningView.hidden = YES;
    self.warningViewHeightConstraint.constant = 15;
}

- (IBAction)saveAction:(id)sender {
    if (!self.nameTF.text.length) {
        [self alertWithMessage:@"请输入新用户名"];
        return;
    }
    NSDictionary *parameters = @{@"id": self.model.info_id,
                                 @"name": self.nameTF.text,
                                 };
    [VPAPI authorizeModifyWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

- (IBAction)unBindAction:(UIButton *)sender {
    NSDictionary *parameters = @{@"id": self.model.info_id,};
    [VPAPI authorizeUnbindWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        if (successed) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

@end
