//
//  WorkTabHeaderView.m
//  智汇随身厅
//
//  Created by panda on 2018/1/15.
//  Copyright © 2018年 vivian. All rights reserved.
//

#import "WorkTabHeaderView.h"
//显示数字按钮
#import "WorkTabHeaderBtn.h"
//业务查询的多个按钮
#import "WorkBussinessBtn.h"

@interface WorkTabHeaderView()
//@property (nonatomic, strong) WorkTabHeaderBtn *LeftHeaderBtn;//左边 预估酬金
@property (nonatomic, strong) WorkTabHeaderBtn *rightHeaderBtn;//右边 业务量(笔)
//@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *switchBtn;//本日/本月切换按钮
@property (nonatomic, strong) UIImageView *bgView;//背景图片

@property (nonatomic, assign) BOOL isToday;//是否为本日   yes:本日   no:本月
//@property (nonatomic, assign) BOOL today;//用户传给工作台用户 用于跳转 yes or no

@property (nonatomic, strong) NSMutableArray *btnArr;//流量包/套餐变更/宽带/充值/开户等 按钮数组

@end


@implementation WorkTabHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.isToday = YES;
        [self addSubview:self.bgView];
//        [self addSubview:self.LeftHeaderBtn];
        [self addSubview:self.rightHeaderBtn];
//        [self addSubview:self.lineView];
        [self addSubview:self.switchBtn];
        
        // 写死五个业务
//        NSArray *titleArr = @[@"流量包",@"套餐变更",@"宽带",@"充值",@"开户"];
//        for (int i = 0; i < titleArr.count; i++) {
//            WorkBussinessBtn *btn = [[WorkBussinessBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*i, CGRectGetMaxY(_rightHeaderBtn.frame)+12, SCREEN_WIDTH/5, 42)];
//            btn.tag = 100 + i;
//            [btn addTarget:self action:@selector(enterBussinessSearchVC:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
//            btn.titleLbl.text = titleArr[i];
//            //添加入数组
//            [self.btnArr addObject:btn];
//        }
    }
    return self;
}

#pragma mark - setter && getter
- (void)setMonthModel:(AllStatisticsModel *)monthModel {
    _monthModel = monthModel;
    _rightHeaderBtn.priceLbl.text = monthModel.allBusinessCount;
    if (!self.isToday) {
        [self removeBtn];
        NSArray *dataArray = monthModel.statisticsList;
        NSInteger count =dataArray.count;
        for (int i = 0; i < count; i++) {
            WorkBussinessBtn *btn = [[WorkBussinessBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/count*i, CGRectGetMaxY(_rightHeaderBtn.frame)+12, SCREEN_WIDTH/count, 42)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(enterBussinessSearchVC:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            StatisticsModel *model = (StatisticsModel *)dataArray[i];
            btn.titleLbl.text = model.dictionaryBusinessTypeName;
            btn.numLbl.text = model.businessCount;
            //添加入数组
            [self.btnArr addObject:btn];
        }
        [_switchBtn setTitle:@"本月" forState:UIControlStateNormal];
        _rightHeaderBtn.priceLbl.text = self.monthModel.allBusinessCount;
        _rightHeaderBtn.nameLbl.text = @"本月业务量";
    }
}

- (void)setTodayModel:(AllStatisticsModel *)todayModel {
    _todayModel = todayModel;
    _rightHeaderBtn.priceLbl.text = todayModel.allBusinessCount;
    if (self.isToday) {
        [self removeBtn];
        NSArray *dataArray = todayModel.statisticsList;
        NSInteger count =dataArray.count;
        for (int i = 0; i < count; i++) {
            WorkBussinessBtn *btn = [[WorkBussinessBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/count*i, CGRectGetMaxY(_rightHeaderBtn.frame)+12, SCREEN_WIDTH/count, 42)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(enterBussinessSearchVC:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            StatisticsModel *model = (StatisticsModel *)dataArray[i];
            btn.titleLbl.text = model.dictionaryBusinessTypeName;
            btn.numLbl.text = model.businessCount;
            //添加入数组
            [self.btnArr addObject:btn];
        }
        [_switchBtn setTitle:@"本日" forState:UIControlStateNormal];
        _rightHeaderBtn.priceLbl.text = self.todayModel.allBusinessCount;
        _rightHeaderBtn.nameLbl.text = @"本日业务量";
    }
}

- (void)removeBtn {
    for (int i = 0; i < self.btnArr.count; i++) {
        UIView *view = self.btnArr[i];
        [view removeFromSuperview];
    }
    [self.btnArr removeAllObjects];
}

#pragma mark - 绑定事件
// 切换本月本日动作
- (void)clickChangeAction {
    self.isToday = !self.isToday;
    if (self.isToday) {
        // 切换数据源
        [self setTodayModel:self.todayModel];
    } else {
        // 切换数据源
        [self setMonthModel:self.monthModel];
    }
}

// 进入流量包/套餐变更/宽带/充值/开户 查询界面
-(void)enterBussinessSearchVC:(UIButton*)btn {
    if (self.isToday) {
        StatisticsModel *model = self.todayModel.statisticsList[btn.tag - 100];
        self.HeaderCheckSingleBusinessBlock ? self.HeaderCheckSingleBusinessBlock(YES, model) : nil ;
    } else {
        StatisticsModel *model = self.monthModel.statisticsList[btn.tag - 100];
        self.HeaderCheckSingleBusinessBlock ? self.HeaderCheckSingleBusinessBlock(NO, model) : nil ;
    }
}


// 本日/本月 1预估酬金/2业务量
// tag:     1预估酬金(左)/2业务量(右)
// istoday:  1本日/0本月
-(void)enterIcomeVcWithLeftOrRight:(UIButton*)btn{
    self.HeaderCheckALLBusinessBlock ? self.HeaderCheckALLBusinessBlock(self.isToday) : nil ;
}

#pragma mark - 初始化
-(UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _bgView.image = [UIImage imageNamed:@"WorkTable_bg_head"];
    }
    return _bgView;
}

-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35-15, 15*layoutBy6(), 35, 20)];
        [_switchBtn setTitle:@"本日" forState:UIControlStateNormal];
        _switchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _switchBtn.titleLabel.textColor = [UIColor whiteColor];
        _switchBtn.layer.cornerRadius = 1.5;
        _switchBtn.layer.borderWidth = 1;
        _switchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_switchBtn addTarget:self action:@selector(clickChangeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

//-(WorkTabHeaderBtn *)LeftHeaderBtn{
//    if (!_LeftHeaderBtn) {
//        _LeftHeaderBtn = [[WorkTabHeaderBtn alloc]initWithFrame:CGRectMake(55*layoutBy6(), 15*layoutBy6(), 120*layoutBy6(), 62*layoutBy6())];
//        _LeftHeaderBtn.nameLbl.text = @"本日预估酬金";
//        _LeftHeaderBtn.tag = 1;
//        [_LeftHeaderBtn addTarget:self action:@selector(enterIcomeVcWithLeftOrRight:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _LeftHeaderBtn;
//}

-(WorkTabHeaderBtn *)rightHeaderBtn{
    if (!_rightHeaderBtn) {
        _rightHeaderBtn = [[WorkTabHeaderBtn alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120) / 2, 15, 120, 62)];
        _rightHeaderBtn.nameLbl.text = @"本日业务量";
        _rightHeaderBtn.littleNameLbl.hidden = NO;
        _rightHeaderBtn.tag = 2;
        [_rightHeaderBtn addTarget:self action:@selector(enterIcomeVcWithLeftOrRight:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightHeaderBtn;
}

//-(UIView *)lineView{
//    if (!_lineView) {
//        _lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5*layoutBy6(), 15*layoutBy6(), 1*layoutBy6(), 62*layoutBy6())];
//        _lineView.backgroundColor = [UIColor whiteColor];
//    }
//    return _lineView;
//}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc]init];
    }
    return _btnArr;
}

@end
