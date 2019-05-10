//
//  GoodsView2.m
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "GoodsView2.h"

@implementation GoodsView2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    
    [self addConstraint];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        
        [self addConstraint];
    }
    return self;
}

- (void)addConstraint {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(self.imgView.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
//        make.height.mas_equalTo(40);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

- (void)setModel:(ActivityBusinessModel *)model {
    _model = model;
    NSString *urlString = [NSString getFullImageUrlString:model.url server:CurrentUser.imgServerPrefix];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.sellPrice floatValue] / 10000.0];
}

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = @"无商品";
//        _nameLabel.backgroundColor = [UIColor redColor];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = hexStringToColor(COLOR_Price);
        _priceLabel.text = @"￥0.0";
//        _priceLabel.backgroundColor = [UIColor greenColor];
    }
    return _priceLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
