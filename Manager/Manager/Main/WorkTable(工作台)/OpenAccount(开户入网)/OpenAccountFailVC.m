//
//  OpenAccountFailVC.m
//  Manager
//
//  Created by vpclub on 2019/1/9.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "OpenAccountFailVC.h"
#import "UIViewController+BackButtonHandler.h"

@interface OpenAccountFailVC ()<UINavigationBarDelegate>

@end

@implementation OpenAccountFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提交失败";
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
