//
//  UpdateView.m
//  Manager
//
//  Created by vpclub on 2018/12/15.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "UpdateView.h"

@interface UpdateView()

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ignoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation UpdateView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + IPHONEX_BOTTOM_SPACE);
        self.whiteView.layer.cornerRadius = 10;
        self.whiteView.layer.masksToBounds = YES;
        self.ignoreBtn.layer.borderWidth = 1;
        self.ignoreBtn.layer.borderColor = hexStringToColor(@"666666").CGColor;
        self.ignoreBtn.layer.cornerRadius = 3;
        self.ignoreBtn.layer.masksToBounds = YES;
        self.updateBtn.layer.borderWidth = 1;
        self.updateBtn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.updateBtn.layer.cornerRadius = 3;
        self.updateBtn.layer.masksToBounds = YES;
    } else {
        self = [super init];
    }
    return self;
}

- (void)setModel:(APPVersionModel *)model {
    _model = model;
    model.updateHints = [model.updateHints stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    model.updateHints = [model.updateHints stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    NSArray *firstArray = [model.updateHints componentsSeparatedByString:@"&"];
    if (firstArray.count >= 2) {
        self.titleLabel.text= firstArray[0];
        NSString *contentString = firstArray[1];
        contentString = [contentString stringByReplacingOccurrencesOfString:@";" withString:@"\n\n"];
        self.contentLabel.text = contentString;
    }
    // 是否强制升级
    if ([model.isUpgrade integerValue] == 2) {
        self.ignoreBtn.hidden = YES;
    }
}

- (IBAction)ignoreAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)updateAction:(UIButton *)sender {
    // 是否强制升级
    if ([self.model.isUpgrade integerValue] == 1) {
        [self removeFromSuperview];
    }
    // 跳转AppStore
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1450343765?mt=8"]];
}


@end
