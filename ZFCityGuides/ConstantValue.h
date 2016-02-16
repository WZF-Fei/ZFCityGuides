//
//  ConstantValue.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/11.
//  Copyright © 2016年 WZF. All rights reserved.
//

#ifndef ConstantValue_h
#define ConstantValue_h


#endif /* ConstantValue_h */

#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEGREES_TO_RADIANS(x) ((x) / 180.0 * M_PI)

#define IOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
//视图frame改变通知
#define kChangedFrame @"kChangedViewFrame"

//控件背景颜色 button label cell 等
#define kControlBgColor kUIColorFromRGB(0xedeef0)
//按钮文字颜色 有所区分
#define kButtonTextTintColor kUIColorFromRGB(0x3f484a)
//文字颜色
#define kTextlightBlueColor kUIColorFromRGB(0x272d2d)
//navigation 背景颜色
#define kNavBgColor kUIColorFromRGB(0x1f2324)
//视图背景颜色 UIView
#define kViewBgColor kUIColorFromRGB(0x292d2e)
//tabItem 背景正常颜色
#define kTabItemBgNormal kUIColorFromRGB(0x1e2225)
//tabItem 背景选中颜色
#define kTabItemBgSelected kUIColorFromRGB(0x1a9fd0)
//tabItem 字体颜色
#define kTabItemTextNormal kUIColorFromRGB(0xa3bac5)
//contenView 背景颜色
#define kContentViewBgColor kUIColorFromRGB(0x272c2f)

#define kSegmentBorderColor kUIColorFromRGB(0x202528)
//小视图cell的背景颜色
#define kSmallViewBgColor kUIColorFromRGB(0x252b2b)
//
#define kTableViewCellBgColor kUIColorFromRGB(0xf7f7f7)
//子视图上的字体颜色 灰色
#define kTextlightGrayColor kUIColorFromRGB(0xb1bcc0)

#define TitleBoldFontName @"TrumpGothicEast-Bold"

#define TitleFontName @"FilmotypeGiant"

#define BodyFontName @"HelveticaNeue-Bold"


