//
//  BusinessCCell.m
//  Manager
//
//  Created by vpclub on 2018/11/30.
//  Copyright © 2018年 vpclub. All rights reserved.
//

#import "BusinessCCell.h"

@implementation BusinessCCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.nameLabel];
//        self.backgroundColor = UIColor.blueColor;
    }
    return self;
}

- (UIImageView*)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _imgView.center = CGPointMake(self.frame.size.width / 2, 10 + _imgView.frame.size.height / 2);
//        _imgView.backgroundColor = [UIColor redColor];
    }
    return _imgView;
}

- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame) + 6, self.frame.size.width, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 0;
//        _nameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _nameLabel;
}

@end
