//
//  ShopBusinessSettingVC.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopBusinessSettingVC.h"
#import "SDCycleScrollView.h"
#import "ShopBusinessSelectCell.h"
#import "ShopBusinessCell.h"
#import "UIViewController+BackButtonHandler.h"

@interface ShopBusinessSettingVC ()<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>

@property (nonatomic, strong) UITableView *businessTableView;
// bannerView
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, assign) BOOL isChanged;
@end

@implementation ShopBusinessSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"业务设置";
    
    [self.view addSubview:self.businessTableView];
    [self.view addSubview:self.changeBtn];
    
    [self.dataArray addObjectsFromArray:@[@"1",@"1",@"1"]];
    [self.businessTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 禁用手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // 假数据
    self.bannerScrollView.imageURLStringsGroup = @[@"http://imgdev.central.vpclub.cn/1a834114ffdc52b7db723bcda76ef312?f=png", @"http://imgdev.central.vpclub.cn/dcc0afef7ccebf636f11a093dc1eab7e?f=png"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//在这个方法里写返回按钮的事件处理
- (BOOL)navigationShouldPopOnBackButton {
    [self alertWithMessage:@"返回" complete:^{
        //这里写要处理的代码
        [self.navigationController popViewControllerAnimated:YES];
    }];
    return NO;//返回NO 不会执行
}

#pragma mark - 事件
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeAction {
    NSLog(@"保存变更");
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    } else {
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = hexStringToColor(COLOR_Background);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifyString = NSStringFromClass([ShopBusinessSelectCell class]);
        ShopBusinessSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (!cell) {
            cell = [[ShopBusinessSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
        }
        cell.selectBusinessBlock = ^(NSInteger index) {
            NSLog(@"选中第%ld个套餐", index);
        };
        return cell;
    } else {
        NSString *identifyString = NSStringFromClass([ShopBusinessCell class]);
        ShopBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
        }
        
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)businessTableView {
    if (!_businessTableView) {
        _businessTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        _businessTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _businessTableView.delegate = self;
        _businessTableView.dataSource = self;
        // 头部
        _businessTableView.tableHeaderView = self.bannerScrollView;
        _businessTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _businessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _businessTableView;
}

- (SDCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 375 * 100)];
        _bannerScrollView.autoScroll = true;
        _bannerScrollView.autoScrollTimeInterval = 5.0;
        _bannerScrollView.backgroundColor = UIColor.whiteColor;
        //    _bannerScrollView.delegate = self;
        //    _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //    _bannerScrollView.currentPageDotColor = [UIColor grayColor];
        //    _bannerScrollView.pageDotColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _bannerScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"下标：%zd", currentIndex);
            
        };
    }
    return _bannerScrollView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _changeBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        [_changeBtn setTitle:@"上架变更" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
@end
