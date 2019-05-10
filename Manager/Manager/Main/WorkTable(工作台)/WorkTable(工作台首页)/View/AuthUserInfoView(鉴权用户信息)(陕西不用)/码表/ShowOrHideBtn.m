//
//  ShowOrHideBtn.m
//  智汇随身厅
//
//  Created by panda on 2018/1/17.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "ShowOrHideBtn.h"
@interface ShowOrHideBtn()

@end
@implementation ShowOrHideBtn


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconBtn];
        [self addSubview:self.titleBtn];
    }
    return self;
}


#pragma mark - 初始化
-(UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*layoutBy6(), 0, 11*layoutBy6(), 10*layoutBy6())];
        [_iconBtn setImage:[UIImage imageNamed:@"Workbench_icon_img_32"] forState:UIControlStateNormal];
        _iconBtn.enabled = NO;
    }
    return _iconBtn;
}

-(UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconBtn.frame), 51*layoutBy6(), 14*layoutBy6())];
        [_titleBtn setTitle:@"隐藏码表" forState:UIControlStateNormal];
        [_titleBtn setTitleColor:hexStringToColor(@"999999") forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:10*layoutBy6()];
//        [_titleBtn addTarget:self action:@selector(checkUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
        _titleBtn.enabled = NO;
    }
    return _titleBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
