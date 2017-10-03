//
//  LQItemView.m
//  LoveQi
//
//  Created by Mr on 2017/6/19.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "LQItemView.h"
#import "LQItem.h"

BOOL isNextPage;

@implementation LQItemView

- (id)init {
    self = [super init];
    if (self) {
        self = [[LQItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self hiddleItemView];
        }]];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        isNextPage = NO;
    }
    return self;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= SCREEN_WIDTH) {
        isNextPage = YES;
    } else {
        isNextPage = NO;
    }
}

#pragma mark Method

- (void)showItem {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)createItemsWithImageArray:(NSArray *)itemImageArray itemTitleArray:(NSArray *)itemTitleArray clcikBlock:(LQItemViewBlcok)lqitemBlock {
    [self showItem];
    CGFloat itemWidth = SCREEN_WIDTH/3.0, itemHeight = SCREEN_WIDTH/3.0;
    for (int i = 0; i < itemImageArray.count; i++) {
        LQItem *item = [[LQItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - itemWidth/2.0 , SCREENH_HEIGHT, itemWidth, itemHeight)];
//        item.itemIm = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@/%@", @"biaoqing", itemImageArray[i]] ofType:@"png"]];
        item.itemIm = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", @"biaoqing", itemImageArray[i]]];
        item.itemStr = itemTitleArray[i];
        [self addSubview:item];
        [UIView animateWithDuration:0.3 animations:^{
            item.frame = CGRectMake(0 + itemWidth*(i%3), SCREENH_HEIGHT/2.0 + Navight + itemHeight*(i/3), itemWidth, itemHeight);
            if (i >= 6) {
                self.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREENH_HEIGHT);
                item.frame = CGRectMake(SCREEN_WIDTH + itemWidth*(i%3), SCREENH_HEIGHT/2.0 + Navight + itemHeight*((i-6)/3), itemWidth, itemHeight);
                self.pagingEnabled = YES;
            }
        }];
        item.lqitemBlock = ^(NSString *str) {
            lqitemBlock(str);
            [self hiddleItemView];
        };
    }
}

- (void)hiddleItemView {
        for (UIView *view in self.subviews) {
            [UIView animateWithDuration:0.2 animations:^{
                if (isNextPage) {
                    view.frame = CGRectMake(SCREEN_WIDTH + SCREEN_WIDTH/3.0, SCREENH_HEIGHT, 0, 0);
                } else {
                    view.frame = CGRectMake(SCREEN_WIDTH/3.0, SCREENH_HEIGHT, 0, 0);
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
