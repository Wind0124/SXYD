//
//  ModifyShopIntroAndCoverView.m
//  Manager
//
//  Created by vpclub on 2018/12/12.
//  Copyright © 2018年 临时工作. All rights reserved.
//

#import "ModifyShopIntroAndCoverView.h"

@interface  ModifyShopIntroAndCoverView()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UITextField *introTF;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *coverUrlString;
@end

@implementation ModifyShopIntroAndCoverView

- (id)initWithNib {
    NSString *className = NSStringFromClass([self class]);
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.whiteView.layer.cornerRadius = 6;
        self.whiteView.layer.masksToBounds = YES;
        self.saveBtn.layer.cornerRadius = 17;
        self.saveBtn.layer.masksToBounds = YES;
        self.introTF.delegate = self;
    } else {
        self = [super init];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setModel:(ShopInfoModel *)model {
    _model = model;
    self.introTF.placeholder = model.name;
    [self.addBtn sd_setImageWithURL:[NSURL URLWithString:[NSString getFullImageUrlString:model.coverUrl server:CurrentUser.imgServerPrefix]] forState:UIControlStateNormal];
}

// 关闭
- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)saveAction:(UIButton *)sender {
    if (!(self.introTF.text.length > 0 || self.coverUrlString.length > 0)) {
        [self showWithMessage:@"没有需要修改的数据"];
        return;
    }
    NSMutableDictionary *para  = [NSMutableDictionary dictionary];
    if (self.introTF.text.length > 0) {
        [para setValue:self.introTF.text forKey:@"name"];
    }
    if (self.coverUrlString.length > 0) {
        [para setValue:self.coverUrlString forKey:@"coverUrl"];
    }
    [para setValue:self.model.info_id forKey:@"id"];
    // 更新店铺信息
    [self updateShop:para];
}

- (void)updateShop:(NSDictionary *)parameters {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI modifyShopWithDic:parameters block:^(BOOL successed, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (successed) {
            NSLog(@"更新成功");
            [self removeFromSuperview];
            [self.fatherVC getShopInfo];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self showWithMessage:message];
        }
    }];
}

- (IBAction)addImage:(UIButton *)sender {
    self.hidden = YES;
    [self addLocalPic];
}

- (void)addLocalPic {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(![UIImagePickerController isSourceTypeAvailable:sourceType]){
//        [self.fatherVC alertWithMessage:@"不支持本地相册"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.fatherVC presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = image.size;
    CGFloat scale = 1;
    if (imageSize.width > 300) {
        scale = 300 / imageSize.width;
    }
    imageSize.height = imageSize.height*scale;
    imageSize.width = imageSize.width*scale;
    image = [self imageWithImage:image scaledToSize:imageSize];
    self.coverImage = image;
    
    // 上传图片
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_HUD object:nil];
    [VPAPI uploadImage:image block:^(NSString *string, HeadModel *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
        if (string) {
            self.coverUrlString = string;
            [self.addBtn setImage:self.coverImage forState:UIControlStateNormal];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_HUD object:nil];
            NSString *message = [NSString stringWithFormat:@"%@%@", error.code, error.msg];
            [self showWithMessage:message];
        }
    }];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

// 不超出字数的限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxLength = 0;
    if (textField == self.introTF) {
        maxLength = 20;
    } else {
        return YES;
    }
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 更新界面数字
    NSInteger caninputlen = maxLength - comcatstr.length;
    if (caninputlen >= 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%zd/20", comcatstr.length];
        return YES;
    } else {
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)showWithMessage:(NSString *)message {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    hud.detailsLabel.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0f];
}

@end
