//
//  ShopActivityCell.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ShopActivityCell.h"

@interface ShopActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImgView;

@end

@implementation ShopActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PrefectureModel *)model {
    _model = model;
    
    NSURL *imgURL = [NSURL URLWithString:[NSString getFullImageUrlString:model.prefectureIcon server:CurrentUser.imgServerPrefix]];
    [self.iconImgView sd_setImageWithURL:imgURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.iconImgViewWidthConstraint.constant = 25;
        } else {
            self.iconImgViewWidthConstraint.constant = 0;
        }
    }];
    
    self.nameLabel.text = model.prefectureName;
    if (model.prefectureNameColor.length > 0) {
        self.nameLabel.textColor = hexStringToColor(model.prefectureNameColor);
    }
    
    [self.picImgView sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.prefectureImgUrl server:CurrentUser.imgServerPrefix]]];

}

@end
