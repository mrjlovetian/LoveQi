//
//  Header.h
//  LoveQi
//
//  Created by tops on 2018/1/25.
//  Copyright © 2018年 李琦. All rights reserved.
//


#import "ClassMacro.h"
#import "StringMacro.h"
#import "ScreenMacro.h"
#import "IosVerionMacro.h"
#import "ColorMacro.h"
#import "PropetyMarco.h"

#ifdef RELEASE
#define MRJLog(...)
#else
#define MRJLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#endif
