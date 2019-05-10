//
//  WorkBussinessBtn.m
//  智汇随身厅
//
//  Created by panda on 2018/1/15.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "WorkBussinessBtn.h"

@interface WorkBussinessBtn()

@end

@implementation WorkBussinessBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.numLbl];
        [self addSubview:self.titleLbl];
    }
    return self;
}

-(UILabel *)numLbl{
    if (!_numLbl) {
        _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, 20*layoutBy6())];
        _numLbl.text = @"0";
        _numLbl.font = [UIFont systemFontOfSize:14*layoutBy6()];
        _numLbl.textColor = [UIColor whiteColor];
        _numLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _numLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_numLbl.frame), CGRectGetMaxY(_numLbl.frame)+2*layoutBy6(), CGRectGetWidth(_numLbl.frame), 20*layoutBy6())];
        _titleLbl.text = @"";
        _titleLbl.font = [UIFont systemFontOfSize:14*layoutBy6()];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}


@end
