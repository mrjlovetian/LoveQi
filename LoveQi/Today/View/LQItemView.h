//
//  LQItemView.h
//  LoveQi
//
//  Created by Mr on 2017/6/19.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LQItemViewBlcok)(NSString *str);

@interface LQItemView : UIScrollView<UIScrollViewDelegate>


- (id)init;

- (void)createItemsWithImageArray:(NSArray *)itemImageArray itemTitleArray:(NSArray *)itemTitleArray clcikBlock:(LQItemViewBlcok )lqitemBlock;


@end
