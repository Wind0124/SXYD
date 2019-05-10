//
//  ShopCoverView.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopCoverView.h"

@interface ShopCoverView()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@end

@implementation ShopCoverView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    } else {
        self = [super init];
    }
    return self;
}

- (void)setModel:(ShopInfoModel *)model {
    _model = model;
    NSString *coverImgString = [NSString getFullImageUrlString:model.coverUrl server:CurrentUser.imgServerPrefix];
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:coverImgString]];
    self.shopNameLabel.text = model.name;
}

- (IBAction)editAction:(UIButton *)sender {
    self.ShopCoverViewEditBlock ? self.ShopCoverViewEditBlock() : nil;
}

@end
