//
//  ChangeUserView.m
//  Manager
//
//  Created by vpclub on 2018/12/4.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ChangeUserView.h"
#import "ChangeUserColl.h"
#import "ChangeUserIdentifyReusableHeader.h"

#define ChangeUserCollIdentifier @"ChangeUserCollIdentifier" //collIdentifier
#define ChangeUserIdentifyReusableHeaderIdentifier @"ChangeUserIdentifyReusableHeaderIdentifier"

@interface ChangeUserView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView;//黑色底
@property (nonatomic, strong) UIView *whiteView;//白色底
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end

@implementation ChangeUserView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectIndex = 0;
        [self addSubview:self.bgView];
        [self addSubview:self.whiteView];
        [self.whiteView addSubview:self.titleLabel];
        [self.whiteView addSubview:self.closeBtn];
        [self.whiteView addSubview:self.mainCollectionView];
    }
    return self;
}

- (void)update {
    [self.mainCollectionView reloadData];
}

#pragma mark - 事件绑定
-(void)closeAction {
    [self removeFromSuperview];
    [self.mainCollectionView reloadData];
}

-(void)clickSectionHeader:(UIButton*)btn{
    // 只切换UI
//    NSInteger sectionInt = btn.tag;
//    self.selectIndex = sectionInt;
//    [self.mainCollectionView reloadData];
    // 切换到工号内的默认工作台
    // 工号
    EmployeeModel *employeeModel = self.dataArray[btn.tag];
    // 具体身份
    for (int i = 0; i < employeeModel.listWorkbench.count; i++) {
        WorkbenchModel *model = employeeModel.listWorkbench[i];
        if ([model.isDefault isEqualToString:@"true"]) {
            NSDictionary *para = @{@"employeeNumber": employeeModel.employeeNumber,
                                   @"workbenchCode": model.code,
                                   };
            if (self.changeUserBlock) {
                self.changeUserBlock(para);
            }
            break;
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.selectIndex == section) {
        EmployeeModel *model = self.dataArray[section];
        NSInteger count = model.listWorkbench.count;
        return count;
//    } else {
//        return 0;
//    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChangeUserColl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChangeUserCollIdentifier forIndexPath:indexPath];
    // 工号
    EmployeeModel *employeeModel = self.dataArray[indexPath.section];
    // 具体身份
    WorkbenchModel *model = employeeModel.listWorkbench[indexPath.item];
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"设置默认");
    // 工号
    EmployeeModel *employeeModel = self.dataArray[indexPath.section];
    // 具体身份
    WorkbenchModel *model = employeeModel.listWorkbench[indexPath.item];
    NSDictionary *para = @{@"employeeNumber": employeeModel.employeeNumber,
                           @"workbenchCode": model.code,
                           };
    if (self.changeUserBlock) {
        self.changeUserBlock(para);
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ChangeUserIdentifyReusableHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChangeUserIdentifyReusableHeaderIdentifier forIndexPath:indexPath];
    EmployeeModel *model = self.dataArray[indexPath.section];
    
    if (self.selectIndex == indexPath.section) {
        header.titleLabel.text = [NSString stringWithFormat:@"当前工号: %@", model.employeeNumber];
        header.titleLabel.font = [UIFont systemFontOfSize:13];
        header.titleLabel.textColor = hexStringToColor(@"0F8EEB");
    } else {
        header.titleLabel.text = [NSString stringWithFormat:@"工号: %@", model.employeeNumber];
        header.titleLabel.font = [UIFont systemFontOfSize:12];
        header.titleLabel.textColor = hexStringToColor(@"AAAAAA");
    }
    // 隐藏切换按钮
    header.changeBtn.hidden = YES;
//    if (indexPath.section == self.selectIndex) {
//        header.changeBtn.hidden = YES;
//    }else{
//        //其他行显示切换按钮
//        header.changeBtn.hidden = NO;
//    }
//
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(header.frame), 40)];
//    btn.tag = (NSInteger)indexPath.section;
//    [btn addTarget:self action:@selector(clickSectionHeader:) forControlEvents:UIControlEventTouchUpInside];
//    [header addSubview:btn];
    return header;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.7;
    }
    return _bgView;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH-100, 400)];
        _whiteView.center = self.center;
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 7.5;
    }
    return _whiteView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 35)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"请选择您要切换的身份";
        _titleLabel.textColor = hexStringToColor(@"999999");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 100 - 60 , 0 , 60 , 35 )];
        [_closeBtn setImage:[UIImage imageNamed:@"WorkTable_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        NSInteger itemWidth = (SCREEN_WIDTH - 100) / 3 - 3;
//        NSInteger itemHeight = 100;
        NSInteger itemHeight = 80; // 没有默认按钮
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH - 90, 36);
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumInteritemSpacing = 0;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH - 100, self.whiteView.bounds.size.height - 45) collectionViewLayout:flowLayout];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        [_mainCollectionView registerClass:[ChangeUserColl class] forCellWithReuseIdentifier:ChangeUserCollIdentifier];
        [_mainCollectionView registerClass:[ChangeUserIdentifyReusableHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChangeUserIdentifyReusableHeaderIdentifier];
    }
    return _mainCollectionView;
}

@end
