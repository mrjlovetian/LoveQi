//
//  MenuView.h
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuBlock)(NSInteger index, NSString *menuTitleStr, NSString *functionName);

@interface MenuViewManger : NSObject

+ (UIView *)getMenuViewWith:(NSArray *)dataSource menuBlock:(MenuBlock)menuBlock;

@end
