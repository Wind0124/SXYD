//
//  StepTwo_UserInfo.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepTwo_UserInfoView.h"

@interface StepTwo_UserInfoView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation StepTwo_UserInfoView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        
    } else {
        self = [super init];
    }
    return self;
}

- (void)updateInfoWithName:(NSString *)name gender:(NSString *)gender idNum:(NSString *)idNum address:(NSString *)address {
    self.nameLabel.text = name;
    self.genderLabel.text = ([gender integerValue] == 0) ? @"女" : @"男";
    self.idLabel.text = idNum;
    self.addressLabel.text = address;
}

@end
