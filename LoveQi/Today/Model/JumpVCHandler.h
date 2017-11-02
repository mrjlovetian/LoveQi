//
//  JumpVCHandler.h
//  LoveQi
//
//  Created by Mr on 2017/11/2.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JumpVCHandler : NSObject

+ (void)PushRootVC:(UIViewController *)rootVC jumpVC:(UIViewController *)jumpVC;

+ (void)presentRootVC:(UIViewController *)rootVC jumpVC:(UIViewController *)jumpVC;

+ (void)jumpRootVC:(UIViewController *)rootVC toIndex:(NSInteger)index;

@end
