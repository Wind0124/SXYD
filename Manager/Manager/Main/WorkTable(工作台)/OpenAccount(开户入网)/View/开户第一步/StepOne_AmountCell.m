//
//  StepOne_AmountCell.m
//  Manager
//
//  Created by vpclub on 2019/1/19.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "StepOne_AmountCell.h"

@interface StepOne_AmountCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation StepOne_AmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BusinessContractModel *)model {
    _model = model;
    NSArray *feeArray = [model.minimumAmount componentsSeparatedByString:@","];
    if (feeArray.count >= 0) {
        NSMutableArray *feeStringArray = [NSMutableArray array];
        for (int i = 0; i < feeArray.count; i++) {
            NSInteger fee = [feeArray[i] integerValue];
            [feeStringArray addObject:[NSString stringWithFormat:@"%.2f元", fee/10000.0]];
        }
        NSString *feeString = [feeStringArray componentsJoinedByString:@","];
        self.priceLabel.text = [NSString stringWithFormat:@"预存金额：%@", feeString];

//        NSInteger firstFee = [feeArray[0] integerValue];
//        self.priceLabel.text = [NSString stringWithFormat:@"预存金额：%.2f元", firstFee/10000.0];
    }
}
@end
