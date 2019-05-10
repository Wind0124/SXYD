//
//  ChangeUserIdentifyReusableHeader.m
//  智汇随身厅
//
//  Created by liuyujia_haha on 2018/3/23.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "ChangeUserIdentifyReusableHeader.h"

@interface ChangeUserIdentifyReusableHeader()
@property (nonatomic, strong)UIView *lineView;
@end

@implementation ChangeUserIdentifyReusableHeader
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.changeBtn];
        [self addSubview:self.lineView];
    }
    return self;
}

#pragma mark - 事件绑定
-(void)changeAction{
    
}

#pragma mark - 初始化
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 36)];
        _titleLabel.text = @"*工号：A100001920391";
        _titleLabel.textColor = hexStringToColor(@"6F6F6F");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}
-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-19-40, 9, 40, 18)];
        [_changeBtn setTitle:@"切换" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:hexStringToColor(@"0F8EEB") forState:UIControlStateNormal];
        _changeBtn.layer.cornerRadius = 1;
        _changeBtn.layer.borderWidth = 1;
        _changeBtn.layer.borderColor = hexStringToColor(@"0F8EEB").CGColor;
        [_changeBtn addTarget:self action:@selector(changeAction)
             forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _changeBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)-0.5, CGRectGetWidth(self.frame), 0.5)];
        _lineView.backgroundColor = hexStringToColor(@"AAAAAA");
    }
    return _lineView;
}
@end
