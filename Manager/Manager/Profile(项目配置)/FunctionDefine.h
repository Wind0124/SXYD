//
//  FunctionDefine.h
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#ifndef FunctionDefine_h
#define FunctionDefine_h

//16进制颜色(html颜色值)字符串转为UIColor
CG_INLINE UIColor * hexStringToColor(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//通过6适配函数5,6p
CG_INLINE double layoutBy6() {
    
    BOOL is_iphone_6p=  (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )736 )== 0);
    
    BOOL is_iphone_5low=  (fabs((double)[[ UIScreen mainScreen ] bounds ].size.width - ( double )320 )== 0);
    
    
    double dlayout=1.0;
    
    if (is_iphone_5low) {
        dlayout = (double)320/375;
    } else if (is_iphone_6p) {
        dlayout=(double)414/375;
    } else {
        
    }
    return dlayout;
}


#endif /* FunctionDefine_h */
