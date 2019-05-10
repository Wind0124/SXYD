//
//  DefaultChannelCell.m
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "DefaultChannelCell.h"

@interface DefaultChannelCell()

@property (nonatomic, strong) UILabel *channelLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DefaultChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.channelLabel];
        [self addSubview:self.lineView];
    }
    return self;
}


- (void)setName:(NSString *)name {
    _name = [NSString stringWithFormat:@"  默认  %@", name];
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:_name];
    NSRange range = NSMakeRange(0, 6);
    [nameString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:range];
    [nameString addAttribute:NSForegroundColorAttributeName value:hexStringToColor(@"D0021B") range:range];
    [nameString addAttribute:NSBackgroundColorAttributeName value:hexStringToColor(@"FFF1F3") range:range];
    self.channelLabel.attributedText = nameString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (UILabel *)channelLabel {
    if (!_channelLabel) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 64)];
        _channelLabel.textColor = hexStringToColor(@"333333");
        _channelLabel.font = [UIFont systemFontOfSize:14];
        _channelLabel.numberOfLines = 2;
    }
    return _channelLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 64, SCREEN_WIDTH - 30, 1)];
        _lineView.backgroundColor = hexStringToColor(COLOR_Line);
    }
    return _lineView;
}
@end
