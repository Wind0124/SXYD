//
//  ChangeChannelView.m
//  Manager
//
//  Created by vpclub on 2018/12/31.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ChangeChannelView.h"
#import "ChangeChannelCell.h"

@interface ChangeChannelView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ChangeChannelView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.whiteView];
        [self.whiteView addSubview:self.titleLabel];
        [self.whiteView addSubview:self.lineView];
        [self.whiteView addSubview:self.tableView];
        [self.whiteView addSubview:self.cancelBtn];
        [self.whiteView addSubview:self.confirmBtn];
        self.dataArray = [NSMutableArray arrayWithArray:CurrentUser.channelList];
        self.selectIndex = -1;
        if (CurrentUser.defaultChannelId) {
            for (int i = 0; i < self.dataArray.count; i++) {
                ChannelModel *model = self.dataArray[i];
                if ([CurrentUser.defaultChannelId isEqualToString:model.channelId]) {
                    self.selectIndex = i;
                    break;
                }
            }
        }
    }
    return self;
}

#pragma mark - 按钮点击
- (void)dismiss {
    [self removeFromSuperview];
}

- (void)confirmAction {
    // 切换渠道
    if (self.selectIndex >= 0) {
        ChannelModel *model = self.dataArray[self.selectIndex];
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
                [self removeFromSuperview];
            } else {
                NSLog(@"调设置默认渠道接口失败");
            }
        }];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifyString = NSStringFromClass([ChangeChannelCell class]);
    ChangeChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifyString owner:nil options:nil].firstObject;
    }
    if (indexPath.row == self.selectIndex) {
        [cell.selectImgView setImage:[UIImage imageNamed:@"4A_check"]];
    } else {
        [cell.selectImgView setImage:[UIImage imageNamed:@"4A_unCheck"]];
    }
    ChannelModel *model = (ChannelModel *)self.dataArray[indexPath.row];
    cell.channelLabel.text = [NSString stringWithFormat:@"【%@】【%@】%@", model.channelCode, model.channelId, model.channelName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH - 100, 270)];
        _whiteView.center = self.center;
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 5;
        _whiteView.layer.masksToBounds = YES;
    }
    return _whiteView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.whiteView.viewWidth, 50)];
        _titleLabel.text = @"切换渠道";
        _titleLabel.textColor = hexStringToColor(@"666666");
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.maxY-1, self.whiteView.viewWidth, 1)];
        _lineView.backgroundColor = hexStringToColor(COLOR_Line);
    }
    return _lineView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.maxY, self.whiteView.viewWidth, 150) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.whiteView.viewHeight - 50, (self.whiteView.viewWidth - 90)/2, 30)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cancelBtn.maxX + 30, self.whiteView.viewHeight - 50, (self.whiteView.viewWidth - 90)/2, 30)];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = hexStringToColor(COLOR_Btn);
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
