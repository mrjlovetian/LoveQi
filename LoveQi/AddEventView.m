//
//  AddEventView.m
//  LoveQi
//
//  Created by MRJ on 2017/1/29.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AddEventView.h"

#define btnWidth 44

@interface AddEventView()

@end

@implementation AddEventView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self addSubview:self.addEventBtn];
}

- (UIButton *)addEventBtn
{
    if (!_addEventBtn) {
        _addEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addEventBtn.frame = CGRectMake((SCREEN_WIDTH - btnWidth)/2.0, 0, btnWidth, btnWidth);
        [_addEventBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addEventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _addEventBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
