//
//  BottomBtnView.m
//  TopBroker3
//
//  Created by Mr on 2017/11/3.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "BottomBtnView.h"

@interface BottomBtnView()

@property (nonatomic, copy)BottomClickHandle handle;
@property (nonatomic, strong)UIView *topLineView;

@end

@implementation BottomBtnView

- (instancetype)initWithBottomBtnClick:(BottomClickHandle)handle {
    self = [super init];
    if (self) {
        [self initUI];
        self.handle = [handle copy];
    }
    return self;
}

- (void)clcikBtn {
    if (self.handle) {
        self.handle(_clickBtn.currentTitle);
    }
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.clickBtn];
    if (iPhoneX) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
        [self addSubview:self.topLineView];
        self.clickBtn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 45);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.08;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.clickBtn.layer.cornerRadius = 3.0;
        self.clickBtn.clipsToBounds = YES;
    } else {
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        self.clickBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    }
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _clickBtn.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
        [_clickBtn addTarget:self action:@selector(clcikBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _topLineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
