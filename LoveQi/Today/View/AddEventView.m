//
//  AddEventView.m
//  LoveQi
//
//  Created by MRJ on 2017/1/29.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AddEventView.h"
#import <UIImageView+YYWebImage.h>

#define btnWidth 49
#define imageViewWidth (SCREEN_WIDTH - btnWidth)/2.0

@interface AddEventView()
@property (nonatomic, strong)YYAnimatedImageView *leftView;
@property (nonatomic, strong)YYAnimatedImageView *rightView;
@end

@implementation AddEventView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark method

- (void)initUI {
    [self addSubview:self.leftView];
    [self addSubview:self.addEventBtn];
    [self addSubview:self.rightView];
}

- (void)tapPhoto:(UITapGestureRecognizer *)tap {
    if (tap.view == self.leftView) {
        if (self.tapPhotoBlcok) {
            self.tapPhotoBlcok(@"mrj");
        }
    } else {
        if (self.tapPhotoBlcok) {
            self.tapPhotoBlcok(@"qi");
        }
    }
}

#pragma mark UI

- (UIButton *)addEventBtn {
    if (!_addEventBtn) {
        _addEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addEventBtn.frame = CGRectMake((SCREEN_WIDTH - btnWidth)/2.0, 0, btnWidth, btnWidth);
        UIImage *image = [UIImage imageNamed:@"ico/add.png"];
        [_addEventBtn setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholder:image];
        [_addEventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _addEventBtn;
}

- (YYAnimatedImageView *)leftView {
    if (!_leftView) {
        _leftView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth, btnWidth)];
        UIImage *image = [UIImage imageNamed:@"ico/left.png"];
        _leftView.contentMode = UIViewContentModeCenter;
        [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)]];
        [_leftView setImageWithURL:[NSURL URLWithString:@""] placeholder:image];
        _leftView.userInteractionEnabled = YES;
    }
    return _leftView;
}

- (YYAnimatedImageView *)rightView {
    if (!_rightView) {
        _rightView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(_addEventBtn.right, _addEventBtn.top, _leftView.width, _addEventBtn.height)];
        _rightView.contentMode = UIViewContentModeCenter;
        UIImage *image = [UIImage imageNamed:@"ico/right"];
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)]];
        [_rightView setImageWithURL:[NSURL URLWithString:@""] placeholder:image];
        _rightView.userInteractionEnabled = YES;
    }
    return _rightView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
