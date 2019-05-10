//
//  ManagerChannelVC.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ManagerChannelVC.h"
#import "DefaultChannelCell.h"
#import "ChannelCell.h"
#import "AddChannelView.h"
#import "SelectCityView.h"

@interface ManagerChannelVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *channelTableView;
@property (nonatomic, strong) AddChannelView *addChannelView;// section1 搜索头
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *bindedChannelArray;
@property (nonatomic, strong) NSMutableArray *addChannelArray;

@property (nonatomic, strong) NSMutableArray *cityArray;

@end

@implementation ManagerChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"渠道管理";
    self.view.backgroundColor = hexStringToColor(COLOR_Background);
    [self.view addSubview:self.channelTableView];
    [self.view addSubview:self.tipLabel];
//    self.bindedChannelArray = [NSMutableArray arrayWithArray:@[@"0 0", @"0 1", @"0 2"]];
//    self.addChannelArray = [NSMutableArray arrayWithArray:@[@"1 0", @"1 1", @"1 2"]];
    [self.channelTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [self getBindedList];
    [self getCityList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 网络请求
// 获取绑定列表
- (void)getBindedList {
    [VPAPI2 getBindChannelListWithBlock:^(NSArray *objects, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (objects) {
            NSLog(@"当前有%ld个渠道",objects.count);
            [self.bindedChannelArray removeAllObjects];
            [self.bindedChannelArray addObjectsFromArray:objects];
            // 更新用户信息中的渠道列表和渠道状态
            CurrentUser.channelList = [self.bindedChannelArray copy];
            if (self.bindedChannelArray.count == 0) {
                self.tipLabel.text = @"-只有绑定千店万员渠道才能设置店铺-";
                CurrentUser.channelStatus = @(-1);
            } else {
//                self.tipLabel.text = @"-只能添加3个渠道，可删除已有渠道再添加-";
                self.tipLabel.text = @"";
                CurrentUser.channelStatus = @(1);
                [self sortBindChannel];
            }
            [self.channelTableView reloadData];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 设置默认渠道
- (void)settingDefaultChannel:(ChannelModel *)model {
    NSDictionary *para = @{@"str": model.channelId};
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI setDefaultChannelWithDic:para block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            CurrentUser.defaultChannelCode = model.channelCode;
            CurrentUser.defaultChannelId = model.channelId;
            CurrentUser.defaultSupplierId = model.supplierId;
            CurrentUser.defaultSupplierName = model.supplierName;
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDefaultChannel object:nil];
            [CurrentUser archive];
            [self sortBindChannel];
            [self.channelTableView reloadData];
        } else {
            NSLog(@"调设置默认渠道接口失败");
            [self alertWithMessage:error.msg];
        }
    }];
}

// 绑定渠道排序，默认渠道排第一
- (void)sortBindChannel {
    NSString *defaultChannelId = CurrentUser.defaultChannelId;
    if (defaultChannelId) {
        for (int i = 0; i < self.bindedChannelArray.count; i++) {
            ChannelModel *model = self.bindedChannelArray[i];
            if ([model.channelId isEqualToString:defaultChannelId]) {
                [self.bindedChannelArray removeObject:model];
                [self.bindedChannelArray insertObject:model atIndex:0];
                break;
            }
        }
    }
}

// 获取城市列表
- (void)getCityList {
    [VPAPI2 getShanXiCityWithBlcok:^(NSArray *objects, HeadModel *error) {
        if (objects) {
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:objects];
            [self.channelTableView reloadData];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 绑定渠道
- (void)bindchannel:(ChannelModel *)model {
//    if (self.bindedChannelArray.count == 3) {
//        [self alertWithMessage:@"绑定渠道最多不能超过3个"];
//        return;
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    ChannelModel *cityModel = self.cityArray[self.addChannelView.citySelectIndex];
    NSDictionary *para = @{@"channelCode": model.channelCode,
                           @"channelId": model.channelId,
                           @"cityCode": cityModel.cityCode,
                           };
    [VPAPI2 bindChannelWithDic:para block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            [self alertWithMessage:@"绑定渠道成功"];
            [self getBindedList];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 解绑渠道
- (void)unbindChannel:(ChannelModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSDictionary *para = @{@"channelCode": model.channelCode,
                           @"channelId": model.channelId,
                           @"cityCode": model.cityCode,
                           };
    [VPAPI2 unbindChannelWithDic:para block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            [self alertWithMessage:@"解绑渠道成功"];
            // 是否为默认渠道
            if ([CurrentUser.defaultChannelId isEqualToString:model.channelId]) {
                CurrentUser.defaultChannelCode = nil;
                CurrentUser.defaultChannelId = nil;
                CurrentUser.defaultSupplierId = nil;
                CurrentUser.defaultSupplierName = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeDefaultChannel object:nil];
            }
            [self getBindedList];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 获取渠道列表
- (void)searchChannelWithChannelCode:(NSString *)channelCode {
    if (self.addChannelView.citySelectIndex < 0) {
        [self alertWithMessage:@"请选择城市"];
        return;
    }
    if (channelCode.length == 0) {
        [self alertWithMessage:@"请输入渠道编码"];
        return;
    }
    ChannelModel *cityModel = self.cityArray[self.addChannelView.citySelectIndex];
    NSDictionary *para = @{@"channelCode" : channelCode,
                           @"cityCode" : cityModel.cityCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 getChannelListWithDic:para block:^(NSArray *objects, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (objects) {
            [self.addChannelArray removeAllObjects];
            [self.addChannelArray addObjectsFromArray:objects];
            [self.channelTableView reloadData];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.bindedChannelArray.count;
    } else {
        return self.addChannelArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 80;
    } else {
        return 0.01;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (!self.addChannelView) {
            self.addChannelView = [[AddChannelView alloc] initWithNib];
        }
        __weak typeof(self) weakSelf = self;
        self.addChannelView.selectCityBlock = ^{
            SelectCityView *cityView = [[SelectCityView alloc] initWithNib];
            cityView.cityArray = weakSelf.cityArray;
            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
            cityView.selectCityBlock = ^(NSInteger index) {
                NSLog(@"选中了第%zd个城市", index);
                weakSelf.addChannelView.citySelectIndex = index;
                ChannelModel *model = weakSelf.cityArray[index];
                weakSelf.addChannelView.selectCityName = model.cityName;
            };
            [dele.window addSubview:cityView];
        };
        self.addChannelView.searchBlock = ^(NSString * _Nonnull channelCode) {
            [weakSelf searchChannelWithChannelCode:channelCode];
        };
        return self.addChannelView;
    }
    return [[UIView alloc] init];
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
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ChannelCell" owner:nil options:nil].firstObject;
    }
    if (indexPath.section == 0) {
        cell.type = ChannelCellTypeUnbind;
        ChannelModel *model = self.bindedChannelArray[indexPath.row];
        // 是否默认渠道
        if ([CurrentUser.defaultChannelId isEqualToString:model.channelId]) {
            cell.isDefaultChannel = YES;
        } else {
            cell.isDefaultChannel = NO;
        }
        cell.model = model;
        cell.unBindBlock = ^(ChannelModel * _Nonnull model) {
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:@"确认解绑？" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertCtl addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self unbindChannel:model];
            }]];
            [self presentViewController:alertCtl animated:YES completion:nil];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        ChannelModel *model = self.addChannelArray[indexPath.row];
        // 判断是否绑定过
        BOOL hasBind = NO;
        for (int i = 0; i < self.bindedChannelArray.count; i++) {
            ChannelModel *bindModel = self.bindedChannelArray[i];
            if ([bindModel.channelCode isEqualToString:model.channelCode]) {
                hasBind = YES;
                break;
            }
        }
        if (hasBind) {
            cell.type = ChannelCellTypeHasBind;
        } else {
            cell.type = ChannelCellTypeAdd;
            cell.bindBlock = ^(ChannelModel * _Nonnull model) {
                NSLog(@"要绑定的渠道：%@",model);
                [self bindchannel:model];
            };
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // indexPath.row
    if (indexPath.section == 0) {
        NSLog(@"选择为默认");
        ChannelModel *model = self.bindedChannelArray[indexPath.row];
        [self settingDefaultChannel:model];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%.f",self.channelTableView.contentOffset.y);
}

#pragma mark - 监听键盘
- (void)keyboardShow:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"键盘高度：%.2f", frame.size.height);
    [self.channelTableView setContentOffset:CGPointMake(0, self.bindedChannelArray.count * 65.0 -Nav_Height) animated:YES];
}

- (void)keyboardHide:(NSNotification *)notification {
    //    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect viewFrame = self.view.frame;
//    self.view.frame = CGRectMake(viewFrame.origin.x, 0, viewFrame.size.width, viewFrame.size.height);
//    [self.channelTableView setContentOffset:CGPointZero animated:YES];
    [self.channelTableView setContentOffset:CGPointMake(0, -Nav_Height)];
}

#pragma mark - 懒加载
- (UITableView *)channelTableView {
    if (!_channelTableView) {
        _channelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _channelTableView.backgroundColor = hexStringToColor(COLOR_Background);
        _channelTableView.delegate = self;
        _channelTableView.dataSource = self;
        _channelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _channelTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _channelTableView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 20)];
        _tipLabel.text = @"-只能添加3个渠道，可删除已有渠道再添加-";
        _tipLabel.textColor = hexStringToColor(@"999999");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:11];
    }
    return _tipLabel;
}

- (NSMutableArray *)bindedChannelArray {
    if (!_bindedChannelArray) {
        _bindedChannelArray = [NSMutableArray array];
    }
    return _bindedChannelArray;
}

- (NSMutableArray *)addChannelArray {
    if (!_addChannelArray) {
        _addChannelArray = [NSMutableArray array];
    }
    return _addChannelArray;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
@end
