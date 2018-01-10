//
//  Header.h
//  LoveQi
//
//  Created by MRJ on 2017/1/28.
//  Copyright © 2017年 李琦. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Navight 64
#define NavBAR_HEIGHT (iPhoneX ? 88 : 64)//bar的高度

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define V_ScaleRate_New_W SCREEN_WIDTH / 375.0

#define MF_Image(imagename) [UIImage getImageByName:imagename]

#ifdef RELEASE
#define MRJLog(...)
#else
#define MRJLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#endif

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;


#import <YYKit.h>
#import <MBProgressHUD.H>
#import <FSCalendar.h>
#import "UIImage+KaKao.h"
