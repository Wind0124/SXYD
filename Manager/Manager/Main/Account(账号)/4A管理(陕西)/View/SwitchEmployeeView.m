//
//  SwitchEmployeeView.m
//  Manager
//
//  Created by vpclub on 2018/12/20.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "SwitchEmployeeView.h"
#import "SwitchEmployeeCell.h"

@interface SwitchEmployeeView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *employeeTableView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation SwitchEmployeeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.whiteView];
        [self.whiteView addSubview:self.switchLabel];
        [self.whiteView addSubview:self.lineView];
        [self.whiteView addSubview:self.employeeTableView];
        [self.whiteView addSubview:self.cancelBtn];
        [self.whiteView addSubview:self.confirmBtn];
        self.whiteView.center = self.center;
        self.whiteView.size = CGSizeMake(self.whiteView.viewWidth, CGRectGetMaxY(self.cancelBtn.frame) + 20);
        self.selectedIndex = -1;
    }
    return self;
}

#pragma mark - 加载数据
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    // 根据工号的个数，拉长tableview高度，调整其他控制位置
    self.employeeTableView.size = CGSizeMake(self.employeeTableView.viewWidth, 40 * dataArray.count);
    self.cancelBtn.frame = CGRectMake(15, self.employeeTableView.maxY + 10, (self.whiteView.viewWidth - 45)/2, 30);
    self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 15, self.employeeTableView.maxY + 10, (self.whiteView.viewWidth - 45)/2, 30);
    self.whiteView.size = CGSizeMake(self.whiteView.viewWidth, CGRectGetMaxY(self.cancelBtn.frame) + 20);
    self.whiteView.center = self.center;
    // 标识已选中的工号
    for (int i = 0; i < dataArray.count; i++) {
        if ([CurrentUser.employeeNumber isEqualToString:dataArray[i]]) {
            self.selectedIndex = i;
        }
    }
    [self.employeeTableView reloadData];
}

#pragma mark - 按钮事件
- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)confirmAction {
    // 工号
    NSString *employeeString = self.dataArray[self.selectedIndex];
    self.switchEmployeeBlock ? self.switchEmployeeBlock(employeeString) : nil;
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchEmployeeCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SwitchEmployeeCell" owner:nil options:nil].firstObject;
    }
    cell.employeeLabel.text = self.dataArray[indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        [cell.checkImgView setImage:[UIImage imageNamed:@"4A_check"]];
    } else {
        [cell.checkImgView setImage:[UIImage imageNamed:@"4A_unCheck"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self.employeeTableView reloadData];
}

#pragma mark - 懒加载
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 200)];
        _whiteView.layer.cornerRadius = 10;
        _whiteView.layer.masksToBounds = YES;
        _whiteView.backgroundColor = UIColor.whiteColor;
    }
    return _whiteView;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.whiteView.viewWidth, 50)];
        _switchLabel.text = @"切换工号";
        _switchLabel.textAlignment = NSTextAlignmentCenter;
        _switchLabel.textColor = hexStringToColor(@"666666");
    }
    return _switchLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.whiteView.viewWidth, 1)];
        _lineView.backgroundColor = hexStringToColor(COLOR_Line);
    }
    return _lineView;
}

- (UITableView *)employeeTableView {
    if (!_employeeTableView) {
        _employeeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.whiteView.viewWidth, 120) style:UITableViewStylePlain];
        _employeeTableView.delegate = self;
        _employeeTableView.dataSource = self;
        _employeeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _employeeTableView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.employeeTableView.maxY + 10, (self.whiteView.viewWidth - 45)/2, 30)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:hexStringToColor(@"666666") forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 3;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = hexStringToColor(@"C2C2C2").CGColor;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 15, self.employeeTableView.maxY + 10, (self.whiteView.viewWidth - 45)/2, 30)];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        _confirmBtn.layer.cornerRadius = 3;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
