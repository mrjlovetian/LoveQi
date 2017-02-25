//
//  BtnColumnView.m
//  LoveQi
//
//  Created by Mr on 2017/2/23.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "BtnColumnView.h"

@interface BtnColumnView()
@property (nonatomic, strong)UIView *lineView;
@end

@implementation BtnColumnView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark UI
- (void)initUI
{
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.lineView];
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(15, 10, 40, 25);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 40, 25);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
