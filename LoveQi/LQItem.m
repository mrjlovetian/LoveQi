//
//  LQItem.m
//  LoveQi
//
//  Created by Mr on 2017/6/19.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "LQItem.h"

@interface LQItem()
@property (nonatomic, strong)UIImageView *itemImageView;
@property (nonatomic, strong)UILabel *itemLab;
@end

@implementation LQItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark UI

- (void)initUI
{
    [self addSubview:self.itemImageView];
    [self addSubview:self.itemLab];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.lqitemBlock) {
            self.lqitemBlock(self.itemStr);
        }
    }]];
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.width, self.height - 35)];
        _itemImageView.backgroundColor = [UIColor orangeColor];
    }
    return _itemImageView;
}

- (UILabel *)itemLab
{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemImageView.bottom + 5, self.width, 15)];
        _itemLab.textAlignment = NSTextAlignmentCenter;
        _itemLab.font = [UIFont systemFontOfSize:15];
    }
    return _itemLab;
}

#pragma mark SET
- (void)setItemIm:(UIImage *)itemIm
{
    _itemIm = itemIm;
    _itemImageView.image = itemIm;
}

- (void)setItemStr:(NSString *)itemStr
{
    _itemStr = itemStr;
    _itemLab.text = itemStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
