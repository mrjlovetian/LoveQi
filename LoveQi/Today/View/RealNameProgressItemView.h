//
//  RealNameProgressItemView.h
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RealNameProgressBefore = 0,//认证前
    RealNameProgressBegin,///开始认证
    RealNameProgressEnd,//完成认证
    
} RealNameProgress;

@interface RealNameProgressItemView : UIView

@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *progressStr;
@property (nonatomic, assign)RealNameProgress realNameProgress;
@end
