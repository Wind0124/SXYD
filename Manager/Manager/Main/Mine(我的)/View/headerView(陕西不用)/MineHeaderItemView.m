//
//  MineHeaderItemView.m
//  智汇随身厅
//
//  Created by BiuBiu on 2018/1/17.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "MineHeaderItemView.h"
#import "Masonry.h"

@interface MineHeaderItemView ()

@end

@implementation MineHeaderItemView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = hexStringToColor(@"FFFFFF");
        [self addSubview:self.titleLbl];
        [self addSubview:self.countLbl];
        [self addConstraint];
    }
    return self;
}

#pragma mark - add constraint
- (void)addConstraint {
    [_countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(19);
        make.left.mas_equalTo(self).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-5);
        make.height.mas_equalTo(18);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(47);
        make.left.mas_equalTo(self).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-5);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - lazy load
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = ({
            UILabel *lbl = [UILabel new];
            lbl.text = @"";
            lbl.textColor = hexStringToColor(@"414141");
            lbl.textAlignment = 1;
            lbl.font = [UIFont systemFontOfSize:12];
            lbl;
        });
    }
    return _titleLbl;
}

- (UILabel *)countLbl {
    if (!_countLbl) {
        _countLbl = ({
            UILabel *lbl = [UILabel new];
            lbl.text = @"";
            lbl.textColor = hexStringToColor(@"0F8EEB");
            lbl.textAlignment = 1;
            lbl.font = [UIFont systemFontOfSize:18];
            lbl;
        });
    }
    return _countLbl;
}

@end
