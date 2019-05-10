//
//  ShopSettingVC.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopSettingVC.h"
#import "ShopSelectCityCell.h"
#import "ShopSettingCell.h"
#import "SelectCityView.h"
#import "ShopBusinessSettingVC.h"

@interface ShopSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *shopTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShopSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"店铺设置";
    [self.view addSubview:self.shopTableView];
    [self.dataArray addObjectsFromArray:@[@"1",@"1",@"1"]];
    [self.shopTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifyString = NSStringFromClass([ShopSelectCityCell class]);
        ShopSelectCityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (!cell) {
            cell = [[ShopSelectCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
        }
        return cell;
    } else {
        NSString *identifyString = NSStringFromClass([ShopSettingCell class]);
        ShopSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"选择城市");
        SelectCityView *cityView = [[SelectCityView alloc] initWithNib];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        cityView.selectCityBlock = ^(NSInteger index) {
            NSLog(@"选中了第%zd个城市", index);
        };
        [dele.window addSubview:cityView];
    } else {
        NSLog(@"进入业务设置");
        ShopBusinessSettingVC *businessSettingVC = [[ShopBusinessSettingVC alloc] init];
        [self.navigationController pushViewController:businessSettingVC animated:YES];
    }
}

#pragma mark - 懒加载
- (UITableView *)shopTableView {
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _shopTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _shopTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
