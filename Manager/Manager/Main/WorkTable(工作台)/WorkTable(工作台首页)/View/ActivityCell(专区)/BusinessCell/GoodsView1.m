//
//  GoodsView1.m
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "GoodsView1.h"

@implementation GoodsView1
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.imgView];

    [self addConstraint];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.imgView];
        
        [self addConstraint];
    }
    return self;
}

- (void)addConstraint {
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
//        make.height.mas_equalTo(40);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.imgView.mas_bottom);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(self.imgView.mas_height);
    }];
}

- (void)setModel:(ActivityBusinessModel *)model {
    _model = model;
    NSString *urlString = [NSString getFullImageUrlString:model.url server:CurrentUser.imgServerPrefix];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.sellPrice floatValue]/ 10000.0];
}

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = @"无商品";
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = hexStringToColor(COLOR_Price);
        _priceLabel.text = @"￥0.0";
    }
    return _priceLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setImage:[UIImage imageNamed:@"placeHolder"]];
    }
    return _imgView;
}
@end
