//
//  MenuView.m
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "MenuViewManger.h"
#import "MenuModel.h"
#import "MenuItemView.h"

@implementation MenuViewManger

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UIView *)getMenuViewWith:(NSArray *)dataSource menuBlock:(MenuBlock)menuBlock {
    int i = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    CGFloat width = (SCREEN_WIDTH/3.0);
    CGFloat height = width;
    for (MenuModel *model in dataSource) {
        MenuItemView *itemView = [[MenuItemView alloc] initWithFrame:CGRectMake(i%3*width, i/3*height, width, height)];
        itemView.menuModel = model;
        i++;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            menuBlock(i, model.titleStr , model.functionName);
        }]];
        [view addSubview:itemView];
    }
    view.height = i * height;
    return view;
}

@end
