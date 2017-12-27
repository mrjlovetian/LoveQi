//
//  MRJFooter.m
//  LoveQi
//
//  Created by Mr on 2017/12/26.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "MRJFooter.h"

@implementation MRJFooter

- (void)prepare {
    [super prepare];
    [self setTitle:@"木有更多数据啦" forState:MJRefreshStateNoMoreData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
