//
//  RealNameProgressView.h
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RealNamePositionMain = 0,//正面
    RealNamePositionBack,//反面
    RealNamePositionHandle,//手持
    RealNamePositionDone,
} RealNamePosition;

@interface RealNameProgressView : UIView

@property (nonatomic, assign)RealNamePosition realNamePosition;
@end
