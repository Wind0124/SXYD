//
//  HUDImageView.m
//  Manager
//
//  Created by vpclub on 2019/1/15.
//  Copyright © 2019年 临时工作. All rights reserved.
//

#import "HUDImageView.h"

@implementation HUDImageView

- (CGSize)intrinsicContentSize {
    
//    CGSize s = [super intrinsicContentSize];
//    s.height = self.frame.size.width / self.image.size.width  * self.image.size.height;
//    return s;
    return self.frame.size;
    
}
@end
