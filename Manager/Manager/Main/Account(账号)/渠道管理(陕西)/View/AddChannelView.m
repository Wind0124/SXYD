//
//  AddChannelView.m
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "AddChannelView.h"

@interface AddChannelView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *channelCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation AddChannelView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.channelCodeTF.delegate = self;
        self.channelCodeTF.keyboardType = UIKeyboardTypeASCIICapable;
        self.citySelectIndex = -1;
    } else {
        self = [super init];
    }
    return self;
}

- (void)setSelectCityName:(NSString *)selectCityName {
    _selectCityName = selectCityName;
    [self.cityBtn setTitle:selectCityName forState:UIControlStateNormal];
}

#pragma mark - 按钮点击
- (IBAction)selectCityAction:(UIButton *)sender {
    [self.channelCodeTF endEditing:YES];
    self.selectCityBlock ? self.selectCityBlock() : nil;
}

- (IBAction)searchAction:(UIButton *)sender {
    NSLog(@"搜索");
    [self.channelCodeTF endEditing:YES];
    self.searchBlock ? self.searchBlock(self.channelCodeTF.text) : nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"停止输入");
}
@end
