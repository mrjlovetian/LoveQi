//
//  HeardView.m
//  LoveQi
//
//  Created by Mr on 2017/10/9.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "HeardView.h"
#import "Macro.h"
#import "UIColor+HEX.h"
#import "UIView+Frame.h"

@interface HeardView()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) CALayer *bottomLine;

@end

@implementation HeardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLab];
    [self.layer addSublayer:self.bottomLine];
}

- (void)goBack {
    if (self.handleBlock) {
        self.handleBlock();
    }
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, StatusBarHeight, 50, 44);
        [_backBtn setImage:[UIImage imageNamed:@"ico/bar_back_blue"] forState:UIControlStateNormal];
        _backBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(44, StatusBarHeight, SCREEN_WIDTH - 88, 44)];
        _titleLab.font = [UIFont systemFontOfSize:18.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    }
    return _bottomLine;
}

#pragma mark SET

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

- (void)setHideBackBtn:(BOOL)hideBackBtn {
    _hideBackBtn = hideBackBtn;
    _backBtn.hidden = hideBackBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
