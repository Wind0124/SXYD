//
//  OpenAccountChoosePhoneVC.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "OpenAccountChoosePhoneVC.h"
#import "StepOne_PhoneCell.h"

@interface OpenAccountChoosePhoneVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation OpenAccountChoosePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"号码选择";
    self.cityNameLabel.text = CurrentUser.crmCityName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.selectIndex = -1;
    
    [self searchAction:nil];
}

#pragma mark - 按钮点击
// 分页查询开户手机号
- (IBAction)searchAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSLog(@"搜索手机号");
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    if (self.phoneTF.text.length > 0) {
        [queryDic setValue:self.phoneTF.text forKey:@"mobilePrefix"];
    }
    [queryDic setValue:self.businessId forKey:@"businessId"];
    [queryDic setValue:CurrentUser.crmCityCode forKey:@"cityCode"];
    NSDictionary *para = @{@"containsTotalCount": @"true",
                           @"pageIndex" : @"1",
                           @"pageSize": @"20",
                           @"query" : queryDic,};
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI2 getOpenAccountMobiles:para block:^(BaseModel *object, NSArray *array, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (array) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

// 选占号码
- (void)occupyPhoneNum:(OpenAccountMobileModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    NSDictionary *para = @{@"mobile": model.mobile,
                           @"addressCode": CurrentUser.crmCityCode,
                           };
    [VPAPI2 openAccountOccupyPhoneNum:para block:^(NSString *string, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (string) {// 选占随机号
            model.randomNo = string;
            self.choosePhoneBlock ? self.choosePhoneBlock(model) : nil;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self alertWithMessage:[NSString stringWithFormat:@"%@%@", error.code, error.msg]];
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 20)];
    numLabel.text = @"号码";
    numLabel.textColor = hexStringToColor(@"333333");
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:numLabel];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-100, 0, 100, 20)];
    priceLabel.text = @"预存金额";
    priceLabel.textColor = hexStringToColor(@"333333");
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:priceLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifyString = NSStringFromClass([StepOne_PhoneCell class]);
    StepOne_PhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
    }
    OpenAccountMobileModel *model = self.dataArray[indexPath.row];
    cell.isSelected = (self.selectIndex == indexPath.row);
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    NSLog(@"选择第%ld个号码", indexPath.row);
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"确认选择该手机号？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        OpenAccountMobileModel *model = self.dataArray[indexPath.row];
        self.selectIndex = indexPath.row;
        [self.tableView reloadData];
        [self occupyPhoneNum:model];
    }]];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
