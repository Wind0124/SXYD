//
//  ShopSelectCityCell.m
//  Manager
//
//  Created by vpclub on 2018/12/22.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopSelectCityCell.h"

@interface ShopSelectCityCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ShopSelectCityCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.cityLabel];
        [self addSubview:self.arrowImgView];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)setCitystring:(NSString *)citystring {
    _citystring = citystring;
    self.cityLabel.text = citystring;
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 50)];
        _titleLabel.text = @"业务区域";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = hexStringToColor(@"999999");
    }
    return _titleLabel;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, 150, 50)];
        _cityLabel.textColor = hexStringToColor(@"333333");
        _cityLabel.text = @"当前城市";
        _cityLabel.textAlignment = NSTextAlignmentLeft;
        _cityLabel.font = [UIFont systemFontOfSize:14];
//        _cityLabel.backgroundColor = UIColor.redColor;
    }
    return _cityLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 10, 15, 20, 20)];
        [_arrowImgView setImage:[UIImage imageNamed:@"arrow_right_gray"]];
    }
    return _arrowImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 50 - 1, SCREEN_WIDTH - 30, 1)];
        _lineView.backgroundColor = hexStringToColor(COLOR_Line);
    }
    return _lineView;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *lineColor = self.lineView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.lineView.backgroundColor = lineColor;
}

@end
