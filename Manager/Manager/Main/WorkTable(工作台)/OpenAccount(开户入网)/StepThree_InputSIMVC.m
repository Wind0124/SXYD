//
//  StepThree_InputSIMVC.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepThree_InputSIMVC.h"

@interface StepThree_InputSIMVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *SIMTF;

@end

@implementation StepThree_InputSIMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.SIMTF.delegate = self;
    self.navigationItem.title = @"开始选号";
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.scrollView addGestureRecognizer:tap];
//#if ENVIRONMENT == 0
//    // 西安SIM卡号
//    self.SIMTF.text = @"0B0261874588020";
//#endif
}

- (void)endEdit {
    [self.view endEditing:YES];
}

#pragma mark - 按钮点击
- (IBAction)checkAction:(UIButton *)sender {
    if (self.SIMTF.text.length != 15) {
        [self alertWithMessage:@"请输入15位SIM卡号"];
        return;
    }
    [self.view endEditing:YES];
    
    // 查询SIM卡号码
//    NSDictionary *para = @{@"addressCode": CurrentUser.crmCityCode,
//                           @"simCardNo": self.SIMTF.text,
//                           @"mobile": self.openAccountInfo.mobileModel.mobile,
//                           };
    NSDictionary *para = [[NSDictionary alloc] initWithObjectsAndKeys:
                          CurrentUser.crmCityCode, @"addressCode",
                          self.SIMTF.text, @"simCardNo",
                          self.openAccountInfo.mobileModel.mobile, @"mobile",
                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 getSimCardInfoWithDic:para block:^(NSString *string, BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            self.inputSIMBlock ? self.inputSIMBlock(self.SIMTF.text) : nil;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (string) {
                [self alertWithMessage:string];
            } else {
                [self alertWithMessage:[NSString stringWithFormat:@"%@%@",error.code, error.msg]];
            }
        }
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 0;
    if (textField == self.SIMTF) {
        maxLength = 15;
    } else {
        return YES;
    }
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger caninputlen = maxLength - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

@end
