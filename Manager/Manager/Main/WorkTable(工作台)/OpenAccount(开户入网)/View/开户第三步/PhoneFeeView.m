//
//  PhoneFeeView.m
//  Manager
//
//  Created by vpclub on 2019/1/7.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "PhoneFeeView.h"

@interface PhoneFeeView()

@property (weak, nonatomic) IBOutlet UIView *feeView;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation PhoneFeeView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.feeView.layer.borderWidth = 1;
        self.feeView.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.feeView.layer.cornerRadius = 4;
        self.feeView.layer.masksToBounds = YES;
    } else {
        self = [super init];
    }
    return self;
}

- (void)setFeeNumber:(NSString *)fee {
    self.feeLabel.text = [NSString stringWithFormat:@"%@元",fee];
}

@end
