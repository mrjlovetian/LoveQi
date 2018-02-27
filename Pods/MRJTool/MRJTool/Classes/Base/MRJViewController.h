//
//  MRJViewController.h
//  LoveQi
//
//  Created by Mr on 2017/10/9.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeardView.h"

@interface MRJViewController : UIViewController

@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, strong)HeardView *headView;

- (void)setHideBackView:(BOOL)isHide;

@end
