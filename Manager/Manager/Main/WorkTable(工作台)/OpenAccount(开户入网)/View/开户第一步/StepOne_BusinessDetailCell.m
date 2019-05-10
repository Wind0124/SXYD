//
//  StepOne_BusinessDetailCell.m
//  Manager
//
//  Created by vpclub on 2018/12/28.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "StepOne_BusinessDetailCell.h"
@interface StepOne_BusinessDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation StepOne_BusinessDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.scrollView.bounces = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDescString:(NSString *)descString {
    _descString = descString;
//    self.descLabel.text = descString;
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:descString];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    NSURL *baseUrl = [NSURL URLWithString:@"file:///assets/"];
    [self.webView loadHTMLString:htmlString baseURL:baseUrl];

}

@end
