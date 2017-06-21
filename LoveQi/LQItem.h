//
//  LQItem.h
//  LoveQi
//
//  Created by Mr on 2017/6/19.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LQItemBlock)(NSString *str);

@interface LQItem : UIView
@property (nonatomic, copy)NSString *itemStr;
@property (nonatomic, strong)UIImage *itemIm;

@property (nonatomic, copy)LQItemBlock lqitemBlock;
@end
