//
//  ActivityHeadCell.m
//  Manager
//
//  Created by vpclub on 2018/12/1.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ActivityHeadCell.h"


@interface ActivityHeadCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeightConstraint;

@end

@implementation ActivityHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(ActivityHeadModel *)model {
    _model = model;
    // 四种父专区样式通过设置（名字+图片）高度来展示
    if ([self.styleCode isEqualToString:@"nodisplay"]) {
        self.nameViewHeightConstraint.constant = 0;
        self.pictureViewHeightConstraint.constant = 0;
    } else if ([self.styleCode isEqualToString:@"displayName"]) {
        self.nameViewHeightConstraint.constant = 50;
        self.pictureViewHeightConstraint.constant = 0;
    } else if ([self.styleCode isEqualToString:@"displayPicture"]) {
        self.nameViewHeightConstraint.constant = 0;
        self.pictureViewHeightConstraint.constant = 200;
    } else if ([self.styleCode isEqualToString:@"displayNameAndPicture"]) {
        self.nameViewHeightConstraint.constant = 50;
        self.pictureViewHeightConstraint.constant = 200;
    }

    [self setNeedsLayout];
//    [self layoutSubviews];
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.icon server:CurrentUser.imgServerPrefix]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImgViewWidthConstraint.constant = 25;
        } else {
            self.iconImgViewWidthConstraint.constant = 0;
        }
    }];
    
    self.nameLabel.text = model.name;
    if (model.nameColor.length > 0) {
        self.nameLabel.textColor = hexStringToColor(model.nameColor);
    }
    
//    NSLog(@"%@",[NSString getFullImageUrlString:model.cover server:CurrentUser.imgServerPrefix]);
    [self.picBtn sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.cover server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
    
}

- (IBAction)moreAction:(UIButton *)sender {
    if (self.moreActionBlock) {
        self.moreActionBlock(self.model);
    }
}

- (IBAction)pictureAction:(UIButton *)sender {
    if (self.pictureActionBlock) {
        self.pictureActionBlock(self.model);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
