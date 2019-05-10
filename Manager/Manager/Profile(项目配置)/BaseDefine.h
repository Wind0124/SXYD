//
//  BaseDefine.h
//  Manager
//
//  Created by vpclub on 2018/11/26.
//  Copyright © 2018 vpclub. All rights reserved.
//

#ifndef BaseDefine_h
#define BaseDefine_h

// 通知
#define LoginOrGesture  @"LoginOrGesture"
#define Logout  @"Logout"
#define GetHomePageBanner @"GetHomePageBanner"
#define UpdateUserInfo  @"UpdateUserInfo"
#define SHOW_HUD    @"showHudNotification"
#define HIDE_HUD    @"hideHudNotificaion"
#define ShowTabbarController    @"ShowTabbarController"
#define ChangeDefaultChannel @"ChangeDefaultChannel"
#define SMRZResult @"SMRZResult"

//获取屏幕宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//获取屏幕高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 默认颜色
#define COLOR_Background    @"F4F4F4"
#define COLOR_Line  @"D4D4D4"
#define COLOR_Price @"FF007D"
#define COLOR_Btn    @"0084CF"

// 数据存储
#define TABBARDATA  @"TABBARDATA"   // 底部tabbar
#define ShowAuthTipView @"ShowAuthTipView" // 是否显示4A和渠道管理提醒页面 @"YES" @"NO"

//适配手机型号
#define IS_IPHONE_4 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )480 )== 0)
#define IS_IPHONE_5 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )568 )== 0)
#define IS_IPHONE_6 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )667 )== 0)
#define IS_IPHONE_6P (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )736 )== 0)
#define IS_IPHONE_X (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )812 )== 0)
#define IS_IPHONE_XR (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )896 )== 0)
//iPhone X||XR状态栏增加尺寸
#define IPHONEX_TOP_SPACE ((IS_IPHONE_X || IS_IPHONE_XR)?24:0)
#define IPHONEX_BOTTOM_SPACE ((IS_IPHONE_X || IS_IPHONE_XR)?34:0)
#define Status_Height (20 + IPHONEX_TOP_SPACE)
#define Nav_Height (64+IPHONEX_TOP_SPACE)
#define TabBar_Height (49+IPHONEX_BOTTOM_SPACE)


#endif /* BaseDefine_h */
