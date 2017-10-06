//
//  AddImageBottomView.m
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AddImageBottomView.h"

@interface AddImageBottomView()
@property (nonatomic, strong)UIImageView *addImageView;
@property (nonatomic, strong)UIView *topLineView;
@end


@implementation AddImageBottomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark medthod

- (void)initUI {
    [self addSubview:self.addImageView];
    [self addSubview:self.topLineView];
}

- (void)addImage {
    if (self.addImageBlcok) {
        self.addImageBlcok();
    }
}

#pragma mark UI

- (UIImageView *)addImageView {
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 40)/2.0, 4.5, 40, 40)];
        _addImageView.userInteractionEnabled = YES;
        _addImageView.image = [UIImage imageNamed:@"ico/creation"];
        [_addImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    }
    return _addImageView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
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
