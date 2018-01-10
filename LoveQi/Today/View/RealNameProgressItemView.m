//
//  RealNameProgressItemView.m
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "RealNameProgressItemView.h"

@interface RealNameProgressItemView()
@property (nonatomic, strong)UILabel *itemLab;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UIImageView *doneImageView;
@end

@implementation RealNameProgressItemView

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
    [self addSubview:self.itemLab];
    [self addSubview:self.titleLab];
}

- (UILabel *)itemLab
{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 24)/2.0, 0, 24, 24)];
        _itemLab.font = [UIFont systemFontOfSize:13];
        _itemLab.layer.cornerRadius = _itemLab.height/2.0;
        _itemLab.textColor = [UIColor colorWithHexString:@"D9D9D9"];
        _itemLab.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
        _itemLab.backgroundColor = [UIColor whiteColor];
        _itemLab.layer.borderWidth = 2.0;
        _itemLab.clipsToBounds = YES;
        _itemLab.textAlignment = NSTextAlignmentCenter;
    }
    return _itemLab;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemLab.bottom + 9, self.width, 12)];
        _titleLab.textColor = [UIColor colorWithHexString:@"D9D9D9"];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)doneImageView
{
    if (!_doneImageView) {
        _doneImageView = [[UIImageView alloc] initWithFrame:_itemLab.frame];
        _doneImageView.layer.cornerRadius = _doneImageView.height/2.0;
        _doneImageView.layer.borderColor = [UIColor colorWithHexString:@"0091e8"].CGColor;
        _doneImageView.layer.borderWidth = 2.0;
        _doneImageView.image = MF_Image(@"radlnamedone");
        _doneImageView.contentMode = UIViewContentModeCenter;
        _doneImageView.backgroundColor = [UIColor whiteColor];
        _doneImageView.clipsToBounds = YES;
    }
    return _doneImageView;
}

#pragma mark SET
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _titleLab.text = titleStr;
}

- (void)setProgressStr:(NSString *)progressStr
{
    _progressStr = progressStr;
    _itemLab.text = [NSString stringWithFormat:@"%@", progressStr];//MF_SWF(@"%@", progressStr);
}

- (void)setRealNameProgress:(RealNameProgress)realNameProgress
{
    _realNameProgress = realNameProgress;
    switch (realNameProgress) {
        case RealNameProgressBefore:
            _itemLab.textColor = [UIColor colorWithHexString:@"D9D9D9"];
            _itemLab.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
            _titleLab.textColor = [UIColor colorWithHexString:@"D9D9D9"];
            break;
        case RealNameProgressBegin:
            _itemLab.textColor = [UIColor colorWithHexString:@"0091e8"];
            _itemLab.layer.borderColor = [UIColor colorWithHexString:@"0091e8"].CGColor;
            _titleLab.textColor = [UIColor colorWithHexString:@"0091e8"];
            break;
        case RealNameProgressEnd:
            [self addSubview:self.doneImageView];
            _itemLab.hidden = YES;
            _titleLab.textColor = [UIColor colorWithHexString:@"0091e8"];
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
