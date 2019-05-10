//
//  SelectCityView.m
//  Manager
//
//  Created by vpclub on 2018/12/21.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "SelectCityView.h"

@interface SelectCityView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation SelectCityView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.cityPickerView.delegate = self;
        self.cityPickerView.dataSource = self;
        self.selectedIndex = 0;
    } else {
        self = [super init];
    }
    return self;
}

#pragma mark - 按钮点击
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmAction:(UIButton *)sender {
    if (self.cityArray.count != 0) {
        self.selectCityBlock ? self.selectCityBlock(self.selectedIndex) : nil;
    }
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.cityArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ChannelModel *model = self.cityArray[row];
    if (self.isForSupplierSelected) {
        return model.supplierName;
    } else {
        return model.cityName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedIndex = row;
}

@end
