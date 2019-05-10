//
//  OpenAccountStepOneVC.m
//  Manager
//
//  Created by vpclub on 2018/12/27.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountStepOneVC.h"
#import "OpenAccountStepCell.h"

@interface OpenAccountStepOneVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OpenAccountStepOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择套餐和号码";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 67;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }
        return 80;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifyString = NSStringFromClass([OpenAccountStepCell class]);
        OpenAccountStepCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        cell.step = 1;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = hexStringToColor(COLOR_Background);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end
