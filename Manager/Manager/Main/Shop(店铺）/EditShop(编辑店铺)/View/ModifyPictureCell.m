//
//  ModifyPictureCell.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ModifyPictureCell.h"

@interface ModifyPictureCell()

@property (weak, nonatomic) IBOutlet UIScrollView *picScrollView;
@property (nonatomic, strong) UIButton *addBtn;

@end
@implementation ModifyPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat space = 20;
    CGFloat width = 100;
    CGFloat height = 75;
    // 最多3张，简单处理
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (width+ space) * i, 5, width, height)];
        imgView.tag = 100 + i;
        [self.picScrollView addSubview:imgView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetMaxX(imgView.frame) - 20, imgView.y, 20, 20);
        [btn setImage:[UIImage imageNamed:@"WorkTable_close"] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(delePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self.picScrollView addSubview:btn];
    }
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"myShop_addPhoto"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.hidden = YES;
    [self.picScrollView addSubview:self.addBtn];
    
    self.picScrollView.contentSize = CGSizeMake(15 + (width + space) * 3, 100);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)delePicture:(UIButton *)sender {
    NSLog(@"删除图片");
    self.ModifyDelePicBlock ? self.ModifyDelePicBlock(sender.tag - 1000) : nil;
}

- (void)addPicture:(UIButton *)sender {
    NSLog(@"添加图片");
    self.ModifyAddPicBlock ? self.ModifyAddPicBlock() : nil;
}

- (void)setPicArray:(NSMutableArray *)picArray {
    _picArray = picArray;
    self.addBtn.hidden = YES;
    // 先隐藏全部
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [self.picScrollView viewWithTag:100+i];
        imgView.hidden = YES;
        UIButton *btn = [self.picScrollView viewWithTag:1000+i];
        btn.hidden = YES;
    }
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [self.picScrollView viewWithTag:100+i];
        UIButton *btn = [self.picScrollView viewWithTag:1000+i];
        if (picArray.count > i) {
            // 数组有的显示
            imgView.hidden = NO;
            btn.hidden = NO;
            NSString *imgUrlString = [NSString getFullImageUrlString:picArray[i] server:CurrentUser.imgServerPrefix];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlString]];
        } else {
            // 最后一个显示添加按钮
            self.addBtn.hidden = NO;
            self.addBtn.frame = CGRectMake(imgView.x, imgView.y, imgView.viewWidth, imgView.viewHeight);
            break;
        }
    }
}
@end
