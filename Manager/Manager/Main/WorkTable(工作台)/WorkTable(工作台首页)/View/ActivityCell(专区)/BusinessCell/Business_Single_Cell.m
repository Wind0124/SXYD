//
//  Business_Single_Cell.m
//  Manager
//
//  Created by vpclub on 2018/12/3.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "Business_Single_Cell.h"

@interface Business_Single_Cell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation Business_Single_Cell
@synthesize businessArray = _businessArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLabel.textColor = hexStringToColor(COLOR_Price);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToBusiness)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setBusinessArray:(NSArray *)businessArray {
    [super setBusinessArray:businessArray];
    _businessArray = businessArray;
    self.hidden = YES;
    for (int i = 0; i < businessArray.count; i++) {
        if (i == 0) {
            self.hidden = NO;
            ActivityBusinessModel *model = businessArray[0];
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.url server:CurrentUser.imgServerPrefix]]];
            self.nameLabel.text = model.name;
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.sellPrice floatValue] / 10000.0];
        }
    }
}

- (void)jumpToBusiness {
    ActivityBusinessModel *model = self.businessArray[0];
    if (self.actionBlock) {
        self.actionBlock(model);
    }
}
@end
