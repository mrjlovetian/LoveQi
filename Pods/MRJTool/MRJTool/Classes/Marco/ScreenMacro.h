//
//  ScreenMacro.h
//  LoveQi
//
//  Created by tops on 2018/1/25.
//  Copyright © 2018年 李琦. All rights reserved.
//

#ifndef ScreenMacro_h
#define ScreenMacro_h

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH (SCREEN_SIZE.width)
#define SCREEN_Bottom_height (iPhoneX ? 34 : 0)
#define SCREEN_HEIGHT (iPhoneX?(SCREEN_SIZE.height):SCREEN_SIZE.height)
#define NavBAR_HEIGHT (iPhoneX ? 88 : 64)//bar的高度
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define V_ScaleRate (iPhone6Plus ? 1 : 2.0/3.0)
#define V_ScaleRate_W SCREEN_WIDTH / 320.0 //算宽度比率
#define V_ScaleRate_New_W SCREEN_WIDTH / 375.0
#define V_ScaleRate_H SCREEN_HEIGHT / 736.0 //算高度比率
#define V_ScaleRate_New_H SCREEN_HEIGHT / 667 //算高度比率
#define V_GetX(x) x*V_ScaleRate_W;
#define Edge 15 //边距15
#define RowH 50 //行高，1行选择的高度
#define Cell_H 55 //输入内容的行高
#define TabBAR_HEIGHT (50 + SCREEN_Bottom_height) //主页tab的高度
#define Button_HEIGHT  48 //按钮高度

#endif /* ScreenMacro_h */
