//
//  InputBoxView.m
//  直销通2.8.0
//
//  Created by blues on 16/3/16.
//  Copyright © 2016年 jun. All rights reserved.
//

#import "InputBoxView.h"
#import "Masonry.h"

@interface InputBoxView()


@property (nonatomic, strong) UIView *lineView;//横线


@end

@implementation InputBoxView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.titleLabel];
//        [self addSubview:self.iconImgV];
    [self addSubview:self.inputTF];
    [self addSubview:self.lineView];
    self.lineView.hidden = NO;
    
    [self addConstraint];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.titleLabel];
//        [self addSubview:self.iconImgV];
        [self addSubview:self.inputTF];
        [self addSubview:self.lineView];
        self.lineView.hidden = NO;
        
        [self addConstraint];
    }
    return self;
}

#pragma mark 初始化UI
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = hexStringToColor(@"6F6F6F");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"账号";
    }
    return _titleLabel;
}

//-(UIImageView*)iconImgV {
//    if (!_iconImgV) {
//        _iconImgV = [UIImageView new];
//        _iconImgV.backgroundColor = [UIColor clearColor];
//    }sdfasdf
//    return _iconImgV;
//}

-(UITextField*)inputTF {
    if (!_inputTF) {
        _inputTF = [UITextField new];
        _inputTF.backgroundColor=[UIColor whiteColor];
        _inputTF.textColor = hexStringToColor(@"312E3F");
        _inputTF.borderStyle = UITextBorderStyleNone;
        _inputTF.font=[UIFont systemFontOfSize:15];
        _inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _inputTF;
}

-(UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = hexStringToColor(@"E0DFDF");
    }
    return _lineView;
}

#pragma mark 加约束
-(void)addConstraint {
    [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(30);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(8);
        make.right.equalTo(self).offset(-50);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-51);
        make.height.mas_equalTo(0.5);
    }];
}


@end
