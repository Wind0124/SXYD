//
//  ChannelCell.m
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ChannelCell.h"

@interface ChannelCell()

@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.btn addTarget:self action:@selector(bindOrUnbindAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ChannelModel *)model {
    _model = model;
    if (self.type == ChannelCellTypeUnbind) {
        self.btn.enabled = YES;
        self.btn.layer.borderWidth = 1;
        self.btn.layer.borderColor = hexStringToColor(COLOR_Btn).CGColor;
        self.btn.backgroundColor = UIColor.whiteColor;
        [self.btn setTitleColor:hexStringToColor(COLOR_Btn) forState:UIControlStateNormal];
        [self.btn setTitle:@"解绑" forState:UIControlStateNormal];
    } else if (self.type == ChannelCellTypeAdd) {
        self.btn.enabled = YES;
        self.btn.layer.borderWidth = 0;
        self.btn.backgroundColor = hexStringToColor(COLOR_Btn);
        [self.btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.btn setTitle:@"添加" forState:UIControlStateNormal];
    } else if (self.type == ChannelCellTypeHasBind) {
        self.btn.enabled = NO;
        self.btn.layer.borderWidth = 0;
        self.btn.backgroundColor = hexStringToColor(@"F6F6F6");
        [self.btn setTitleColor:hexStringToColor(@"666666") forState:UIControlStateNormal];
        [self.btn setTitle:@"已添加" forState:UIControlStateNormal];
    }
    self.btn.layer.cornerRadius = 2;
    self.btn.layer.masksToBounds = YES;
    
    NSString *channelString = [NSString stringWithFormat:@"【%@】【%@】%@", model.channelCode, model.channelId, model.channelName];
    if (self.isDefaultChannel) {
        NSString *fullString = [NSString stringWithFormat:@"  默认  %@", channelString];
        
        NSMutableAttributedString *defaultString = [[NSMutableAttributedString alloc] initWithString:fullString];
        NSRange range = NSMakeRange(0, 6);
        [defaultString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:range];
        [defaultString addAttribute:NSForegroundColorAttributeName value:hexStringToColor(@"D0021B") range:range];
        [defaultString addAttribute:NSBackgroundColorAttributeName value:hexStringToColor(@"FFF1F3") range:range];
        self.channelLabel.attributedText = defaultString;
    } else {
        self.channelLabel.text = channelString;
    }
}

- (void)bindOrUnbindAction {
    if (self.type == ChannelCellTypeUnbind) {
        NSLog(@"解绑");
        self.unBindBlock ? self.unBindBlock(self.model) : nil;
    } else {
        NSLog(@"添加绑定");
        self.bindBlock ? self.bindBlock(self.model) : nil;
    }
}

@end
