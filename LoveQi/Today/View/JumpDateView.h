//
//  JumpDateView.h
//  LoveQi
//
//  Created by Mr on 2017/2/23.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JumpDateViewDelegate <NSObject>

@optional
- (void)JumpDateViewSelectDate:(NSDate *)date;

@end
@interface JumpDateView : UIView
- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate;

@property (nonatomic, weak)id<JumpDateViewDelegate> delegate;
@end
