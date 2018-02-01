//
//  MenuItemView.m
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "MenuItemView.h"

@interface MenuItemView()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) CALayer *rightLayer;
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation MenuItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
    [self addSubview:self.subTitleLab];
    [self.layer addSublayer:self.rightLayer];
    [self.layer addSublayer:self.bottomLayer];
}

#pragma mark UI

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 15)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab {
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(_titleLab.left, _titleLab.bottom + 5, self.width, 13)];
        _subTitleLab.font = [UIFont systemFontOfSize:12];
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLab;
}

- (CALayer *)rightLayer {
    if (!_rightLayer) {
        _rightLayer = [CALayer layer];
        _rightLayer.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
        _rightLayer.backgroundColor = [UIColor grayColor].CGColor;
    }
    return _rightLayer;
}

- (CALayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CALayer layer];
        _bottomLayer.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
        _bottomLayer.backgroundColor = [UIColor grayColor].CGColor;
    }
    return _bottomLayer;
}

#pragma mark SET

- (void)setMenuModel:(MenuModel *)menuModel {
    _menuModel = menuModel;
    _titleLab.text = menuModel.titleStr;
    _subTitleLab.text = menuModel.subTitleStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
