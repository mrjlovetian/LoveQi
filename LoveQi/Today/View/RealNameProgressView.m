//
//  RealNameProgressView.m
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "RealNameProgressView.h"
#import "RealNameProgressItemView.h"

@interface RealNameProgressView()
@property (nonatomic, strong)RealNameProgressItemView *item1View;
@property (nonatomic, strong)RealNameProgressItemView *item2View;
@property (nonatomic, strong)RealNameProgressItemView *item3View;

@property (nonatomic, strong)UIView *progress1View;
@property (nonatomic, strong)UIView *progress2View;
@end

@implementation RealNameProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.progress1View];
    [self addSubview:self.progress2View];
    
    [self addSubview:self.item1View];
    [self addSubview:self.item2View];
    [self addSubview:self.item3View];
}

- (RealNameProgressItemView *)item1View {
    if (!_item1View) {
        _item1View = [[RealNameProgressItemView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/3.0, 42)];
        _item1View.titleStr = @"身份证正面";
        _item1View.progressStr = @"1";
    }
    return _item1View;
}

- (RealNameProgressItemView *)item2View {
    if (!_item2View) {
        _item2View = [[RealNameProgressItemView alloc] initWithFrame:CGRectMake(_item1View.right, 15, SCREEN_WIDTH/3.0, 42)];
        _item2View.titleStr = @"身份证反面";
        _item2View.progressStr = @"2";
    }
    return _item2View;
}

- (RealNameProgressItemView *)item3View {
    if (!_item3View) {
        _item3View = [[RealNameProgressItemView alloc] initWithFrame:CGRectMake(_item2View.right, 15, SCREEN_WIDTH/3.0, 42)];
        _item3View.titleStr = @"人脸识别";
        _item3View.progressStr = @"3";
    }
    return _item3View;
}

- (UIView *)progress1View {
    if (!_progress1View) {
        _progress1View = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6.0, 25, 115*V_ScaleRate_New_W, 1.5)];
        _progress1View.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"];
    }
    return _progress1View;
}

- (UIView *)progress2View {
    if (!_progress2View) {
        _progress2View = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, _progress1View.top, _progress1View.width, 1.5)];
        _progress2View.backgroundColor = [UIColor colorWithHexString:@"D9D9D9"];
    }
    return _progress2View;
}

#pragma mark SET
- (void)setRealNamePosition:(RealNamePosition)realNamePosition {
    switch (realNamePosition) {
        case RealNamePositionMain:
            _item1View.realNameProgress = RealNameProgressBegin;
            break;
        case RealNamePositionBack:
            _item1View.realNameProgress = RealNameProgressEnd;
            _item2View.realNameProgress = RealNameProgressBegin;
            _progress1View.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
            break;
        case RealNamePositionHandle:
            _item1View.realNameProgress = RealNameProgressEnd;
            _item2View.realNameProgress = RealNameProgressEnd;
            _item3View.realNameProgress = RealNameProgressBegin;
            _progress1View.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
            _progress2View.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
            break;
        case RealNamePositionDone:
            _item1View.realNameProgress = RealNameProgressEnd;
            _item2View.realNameProgress = RealNameProgressEnd;
            _item3View.realNameProgress = RealNameProgressEnd;
            _progress1View.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
            _progress2View.backgroundColor = [UIColor colorWithHexString:@"0091e8"];
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
