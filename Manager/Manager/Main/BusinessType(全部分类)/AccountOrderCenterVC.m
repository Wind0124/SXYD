//
//  AccountOrderCenterVC.m
//  Manager
//
//  Created by vpclub on 2019/2/18.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "AccountOrderCenterVC.h"
#import "AccountOrderCenterCell.h"
#import "AccountOrderCenterDetailVC.h"

@interface AccountOrderCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *activeArray;// 待激活
@property (nonatomic, strong) NSMutableArray *payArray;// 待支付
@property (nonatomic, strong) NSMutableArray *finishArray;// 已完成
@property (nonatomic, strong) NSMutableArray *cancelArray;// 已取消
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSString *selectPhone;// 筛选的手机号
@end

@implementation AccountOrderCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单中心";
    self.selectIndex = 0;

    [self addSwitchBtn];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        switch (self.selectIndex) {
            case 0:
                [self getOrderWithOrderStatus:@"waitActivite" mobile:self.selectPhone];
                break;
            case 1:
                [self getOrderWithOrderStatus:@"waitPay" mobile:self.selectPhone];
                break;
            case 2:
                [self getOrderWithOrderStatus:@"finished" mobile:self.selectPhone];
                break;
            case 3:
                [self getOrderWithOrderStatus:@"canceled" mobile:self.selectPhone];
                break;
            default:
                break;
        }
    }];
    
    [self getAllData];
}

#pragma mark - 内部点击事件
- (IBAction)searchAction:(UIButton *)sender {
    [self.phoneTF endEditing:YES];
    NSLog(@"搜索手机号");
    self.selectPhone = self.phoneTF.text;
    [self getAllData];
}

- (void)switchAction:(UIButton *)sender {
    [self.phoneTF endEditing:YES];
    self.selectIndex = sender.tag - 10;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self.switchView viewWithTag:10 + i];
        UIView *lineView = [self.switchView viewWithTag:100 + i];
        if (self.selectIndex == i) {
            [btn setTitleColor:hexStringToColor(@"0084CF") forState:UIControlStateNormal];
            lineView.hidden = NO;
        } else {
            [btn setTitleColor:hexStringToColor(@"666666") forState:UIControlStateNormal];
            lineView.hidden = YES;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectIndex) {
        case 0:
            return self.activeArray.count;
            break;
        case 1:
            return self.payArray.count;
            break;
        case 2:
            return self.finishArray.count;
            break;
        case 3:
            return self.cancelArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 225;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifyString = NSStringFromClass([AccountOrderCenterCell class]);
    AccountOrderCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
    }
    NSArray *dataArray;
    switch (self.selectIndex) {
        case 0:
            dataArray = self.activeArray;
            break;
        case 1:
            dataArray = self.payArray;
            break;
        case 2:
            dataArray = self.finishArray;
            break;
        case 3:
            dataArray = self.cancelArray;
            break;
        default:
            break;
    }
    cell.type = self.selectIndex;
    OrderCenterModel *model = (OrderCenterModel *)dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ClickBlock = ^(NSInteger status) {
        if (status == -1) {
            // 跳转详情
            AccountOrderCenterDetailVC *detailVC = [[AccountOrderCenterDetailVC alloc] init];
            detailVC.type = self.selectIndex;
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (status == 0) {
            // 激活
            
        } else if (status == 1) {
            // 支付
            
        }
    };
    return cell;
}

#pragma mark - 网络请求
- (void)getAllData {
    // 请求一遍数据
    [self getOrderWithOrderStatus:@"waitActivite" mobile:self.selectPhone];
    [self getOrderWithOrderStatus:@"waitPay" mobile:self.selectPhone];
    [self getOrderWithOrderStatus:@"finished" mobile:self.selectPhone];
    [self getOrderWithOrderStatus:@"canceled" mobile:self.selectPhone];
}

- (void)getOrderWithOrderStatus:(NSString *)orderStatus mobile:(NSString *)mobile {
    
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:orderStatus forKey:@"orderStatus"];
    if (mobile && mobile.length > 0) {
        [queryDic setObject:mobile forKey:@"queryStr"];
    }
    NSDictionary *para = @{@"containsTotalCount": @1,
                           @"pageIndex": @1,
                           @"pageSize": @20,
                           @"query": queryDic,
                           };
    [VPAPI2 queryOrderCenterWithDic:para block:^(NSArray *objects, HeadModel *error) {
        [self.tableView.mj_header endRefreshing];
        if (objects) {
            if ([orderStatus isEqualToString:@"waitActivite"]) {
                [self.activeArray removeAllObjects];
                [self.activeArray addObjectsFromArray:objects];
            } else if ([orderStatus isEqualToString:@"waitPay"]) {
                [self.payArray removeAllObjects];
                [self.payArray addObjectsFromArray:objects];
            } else if ([orderStatus isEqualToString:@"finished"]) {
                [self.finishArray removeAllObjects];
                [self.finishArray addObjectsFromArray:objects];
            } else if ([orderStatus isEqualToString:@"canceled"]) {
                [self.cancelArray removeAllObjects];
                [self.cancelArray addObjectsFromArray:objects];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UI
- (void)addSwitchBtn {
    self.switchView.backgroundColor = UIColor.whiteColor;
    NSArray *titleArray = @[@"待激活", @"待支付", @"已完成", @"已取消"];
    CGFloat width = SCREEN_WIDTH / 4;
    CGFloat height = 50;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 + i;
        [self.switchView addSubview:btn];
        // 线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width * i, height - 2, width, 2)];
        lineView.backgroundColor = hexStringToColor(@"0084CF");
        lineView.tag = 100 + i;
        [self.switchView addSubview:lineView];
        
        if (self.selectIndex == i) {
            [btn setTitleColor:hexStringToColor(@"0084CF") forState:UIControlStateNormal];
            lineView.hidden = NO;
        } else {
            [btn setTitleColor:hexStringToColor(@"666666") forState:UIControlStateNormal];
            lineView.hidden = YES;
        }
    }
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = hexStringToColor(@"EEEEEE");
    [self.switchView addSubview:bottomLineView];
}

#pragma mark - 懒加载
- (NSMutableArray *)activeArray {
    if (!_activeArray) {
        _activeArray = [NSMutableArray array];
    }
    return _activeArray;
}

- (NSMutableArray *)payArray {
    if (!_payArray) {
        _payArray = [NSMutableArray array];
    }
    return _payArray;
}

- (NSMutableArray *)finishArray {
    if (!_finishArray) {
        _finishArray = [NSMutableArray array];
    }
    return _finishArray;
}

- (NSMutableArray *)cancelArray {
    if (!_cancelArray) {
        _cancelArray = [NSMutableArray array];
    }
    return _cancelArray;
}
@end
