//
//  ChangeUserColl.m
//  智汇随身厅
//
//  Created by liuyujia_haha on 2018/3/23.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "ChangeUserColl.h"

@interface ChangeUserColl()
@property (nonatomic, strong)UIImageView *iconImg;//头像
@property (nonatomic, strong)UILabel *nameLbl;//名称
@property (nonatomic, strong)UIButton *selectBtn;//设置默认按钮
@end

@implementation ChangeUserColl
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImg];
        [self addSubview:self.nameLbl];
//        [self addSubview:self.selectBtn];
    }
    return self;
}

#pragma mark - setter & getter
- (void)setModel:(WorkbenchModel *)model {
    _model = model;
    self.nameLbl.text = model.name;
    if ([model.isCurrent isEqualToString:@"true"]) {
        [_selectBtn setTitle:@"默认" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:hexStringToColor(@"FFFFFF") forState:UIControlStateNormal];
        _selectBtn.backgroundColor = hexStringToColor(@"0F8EEB");
        if ([model.code isEqualToString:@"workTypeClerk"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeClerk_selected"];
        } else if ([model.code isEqualToString:@"workTypeManager"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeManager_selected"];
        } else if ([model.code isEqualToString:@"workTypeAgent"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeAgent_selected"];
        }
    } else {
        [_selectBtn setTitle:@"设置默认" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:hexStringToColor(@"0F8EEB") forState:UIControlStateNormal];
        _selectBtn.backgroundColor = hexStringToColor(@"FFFFFF");
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = hexStringToColor(@"0F8EEB").CGColor;
        if ([model.code isEqualToString:@"workTypeClerk"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeClerk"];
        } else if ([model.code isEqualToString:@"workTypeManager"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeManager"];
        } else if ([model.code isEqualToString:@"workTypeAgent"]) {
            self.iconImg.image = [UIImage imageNamed:@"workTypeAgent"];
        }
    }
}

//-(void)setModel:(NSDictionary *)model{
//    _model = model;
//    
//    self.nameLbl.text = validateString(model[@"userTypeRole"]);
//    
//    NSInteger userTypeRoleUrl = [validateString(model[@"userTypeRoleUrl"]) integerValue];
//   
//    if ([validateString(model[@"isTypeRoleUrl"]) intValue] == 1) {//  1 是默认 2不是默认
//
////        营业员 1   代理商 2 客户经理 3  社区经理 4  渠道经理 5
//        switch (userTypeRoleUrl) {
//            case 1:
//                    self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_1"];
//                break;
//            case 2:
//                    self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_3"];
//                break;
//            case 3:
//                    self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_5"];
//                break;
//            case 4:
//                    self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_7"];
//                break;
//            case 5:
//                    self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_9"];
//                break;
//            default:
//                break;
//        }
//     
//        
//    }else{
//
//        //        营业员 1   代理商 2 客户经理 3  社区经理 4  渠道经理 5
//        switch (userTypeRoleUrl) {
//            case 1:
//                self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_2"];
//                break;
//            case 2:
//                self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_4"];
//                break;
//            case 3:
//                self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_6"];
//                break;
//            case 4:
//                self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_8"];
//                break;
//            case 5:
//                self.iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_10"];
//                break;
//            default:
//                break;
//        }
//    }
//
//}


#pragma mark - 初始化
-(UIImageView *)iconImg{
    if (!_iconImg) {
        double x = (self.frame.size.width-40)/2;
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(x, 15, 40, 40)];
        _iconImg.image = [UIImage imageNamed:@"Workbench_icon_img_59"];
    }
    return _iconImg;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImg.frame)+4, self.frame.size.width, 18.5)];
        _nameLbl.text = @"*客户经理";
        _nameLbl.textColor = hexStringToColor(@"0084CF");
        _nameLbl.font = [UIFont systemFontOfSize:13];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLbl;
}

-(UIButton *)selectBtn{
    if (!_selectBtn) {
        float x = (self.frame.size.width-63)/2;
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(_nameLbl.frame)+4, 63, 18)];
        [_selectBtn setTitle:@"设置默认" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:hexStringToColor(@"FFFFFF") forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _selectBtn.backgroundColor = hexStringToColor(@"0F8EEB");
        _selectBtn.layer.cornerRadius = 1;
        _selectBtn.userInteractionEnabled = NO;
    }
    return _selectBtn;
}

@end
