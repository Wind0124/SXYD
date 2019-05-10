//
//  WorkTabHeaderBtn.m
//  智汇随身厅
//
//  Created by panda on 2018/1/15.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "WorkTabHeaderBtn.h"

@interface WorkTabHeaderBtn()

@end

@implementation WorkTabHeaderBtn

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
        [self addSubview:self.priceLbl];
        [self addSubview:self.nameLbl];
        [self addSubview:self.littleNameLbl];
    }
    return self;
}


-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*layoutBy6(), 42*layoutBy6())];
        _priceLbl.text = @"";
        _priceLbl.font = [UIFont systemFontOfSize:30*layoutBy6()];
        _priceLbl.textColor = [UIColor whiteColor];
        _priceLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLbl;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_priceLbl.frame), CGRectGetWidth(_priceLbl.frame)-30*layoutBy6(), 20*layoutBy6())];
        _nameLbl.text = @"本日预估酬金";
        _nameLbl.font = [UIFont systemFontOfSize:14*layoutBy6()];
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLbl;
}


-(UILabel *)littleNameLbl{
    if (!_littleNameLbl) {
        _littleNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLbl.frame), CGRectGetMinY(_nameLbl.frame), 30*layoutBy6(), CGRectGetHeight(_nameLbl.frame))];
        _littleNameLbl.text = @"(笔)";
        _littleNameLbl.textColor = [UIColor whiteColor];
        _littleNameLbl.font = [UIFont systemFontOfSize:14*layoutBy6()];
        _littleNameLbl.hidden = YES;
    }
    return _littleNameLbl;
}



@end
