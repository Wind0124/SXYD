//
//  StepTwo_DownloadTipView.m
//  Manager
//
//  Created by vpclub on 2018/12/29.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepTwo_DownloadTipView.h"

@interface StepTwo_DownloadTipView()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation StepTwo_DownloadTipView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } else {
        self = [super init];
    }
    return self;
}

- (IBAction)confirmAction:(UIButton *)sender {
    self.downloadConfirmBlock ? self.downloadConfirmBlock() : nil;
    [self removeFromSuperview];
}

@end
