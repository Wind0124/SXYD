//
//  StepThree_UserInfoView.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepThree_UserInfoView.h"

@interface StepThree_UserInfoView()

@property (weak, nonatomic) IBOutlet UILabel *comboLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *SIMLabel;

@end

@implementation StepThree_UserInfoView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    } else {
        self = [super init];
    }
    return self;
}

- (void)updateInfoWithCombo:(NSString *)combo city:(NSString *)cityName phone:(NSString *)phoneNum {
    self.comboLabel.text = combo;
    self.cityLabel.text = cityName;
    self.phoneLabel.text = phoneNum;
    self.SIMLabel.text = @"";
}

- (void)updateSIMNumber:(NSString *)SIMNum {
    self.SIMLabel.text = SIMNum;
}
@end
