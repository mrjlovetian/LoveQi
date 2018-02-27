//
//  HeardView.h
//  LoveQi
//
//  Created by Mr on 2017/10/9.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeardViewHandle)();

@interface HeardView : UIView

@property (nonatomic, copy)HeardViewHandle handleBlock;

@property (nonatomic, copy)NSString *titleStr;

@property (nonatomic, assign)BOOL hideBackBtn;

@end
