//
//  CreditScoreCardView.m
//  TopBroker3
//
//  Created by Mr on 2017/6/6.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "CreditScoreCardView.h"

@implementation CreditScoreCardView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.cardImageView];
    [self addSubview:self.submitBtn];
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 175*V_ScaleRate_New_W)];
        _cardImageView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
        _cardImageView.contentMode = UIViewContentModeCenter;
    }
    return _cardImageView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(_cardImageView.left, _cardImageView.bottom, _cardImageView.width, 40*V_ScaleRate_New_W);
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _submitBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
