//
//  MarketHomeVC.m
//  Manager
//
//  Created by vpclub on 2018/11/28.
//  Copyright © 2018 vpclub. All rights reserved.
//

#import "MarketHomeVC.h"

@interface MarketHomeVC ()

@end

@implementation MarketHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@, %s",self, __func__);
    self.navigationItem.title = @"营销";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
