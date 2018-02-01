//
//  AddIDCardView.m
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "AddIDCardView.h"
#import "RealNameAddImageView.h"

@interface AddIDCardView()
@property (nonatomic, strong)UIImageView *demoIDCardView;///实例照片
@property (nonatomic, strong)UILabel *titleLab;//描述
@property (nonatomic, strong)RealNameAddImageView *addCardView;///添加照片
@property (nonatomic, strong)UIButton *seeImageBtn;
@end

@implementation AddIDCardView

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
    [self addSubview:self.demoIDCardView];
    [self addSubview:self.titleLab];
    [self addSubview:self.addCardView];
    [self addSubview:self.seeImageBtn];
    
    self.height = self.seeImageBtn.bottom;
}

#pragma mark Method
- (void)tap
{
    if (self.selectImageBlock) {
        self.selectImageBlock();
    }
}

- (void)clickBtn
{
    if (self.blowPictureBlock) {
        self.blowPictureBlock();
    }
}

#pragma mark UI
- (UIImageView *)demoIDCardView
{
    if (!_demoIDCardView) {
        _demoIDCardView = [[UIImageView alloc] initWithFrame:CGRectMake(50*V_ScaleRate_New_W, 0, SCREEN_WIDTH - 100*V_ScaleRate_New_W, (SCREEN_WIDTH - 100*V_ScaleRate_New_W) * 35.0 / 55.0)];
        _demoIDCardView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        _demoIDCardView.layer.cornerRadius = 3.0;
        _demoIDCardView.contentMode = UIViewContentModeCenter;
    }
    return _demoIDCardView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_demoIDCardView.left, _demoIDCardView.bottom + 15, _demoIDCardView.width, 50)];
//        _titleLab.font = KKShare.font13;
        _titleLab.numberOfLines = 0;
        _titleLab.textColor = [UIColor colorWithHexString:@"f64c48"];
        
    }
    return _titleLab;
}

- (RealNameAddImageView *)addCardView
{
    if (!_addCardView) {
        _addCardView = [[RealNameAddImageView alloc] initWithFrame:CGRectMake(_demoIDCardView.left, _titleLab.bottom + 10, _demoIDCardView.width, _demoIDCardView.height)];
        [_addCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return _addCardView;
}

- (UIButton *)seeImageBtn
{
    if (!_seeImageBtn) {
        _seeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seeImageBtn.frame = CGRectMake(_demoIDCardView.left, _addCardView.bottom + 13, _demoIDCardView.width, 20);
        [_seeImageBtn setTitle:@"查看大图" forState:UIControlStateNormal];
//        [_seeImageBtn setTitleColor:KKShare.colorGray6 forState:UIControlStateNormal];
//        _seeImageBtn.titleLabel.font = KKShare.font14;
        [_seeImageBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeImageBtn;
}

#pragma mark SET
- (void)setRealNamePosition:(RealNamePosition)realNamePosition
{
    _realNamePosition = realNamePosition;
    UIImage *image = MF_Image(@"id001");
    NSString *contentStr = @"上传要求:\n1.正面照片、字迹清晰、无反光。\n2.必须包含整个身份证，不能缺少边角。";
    switch (realNamePosition) {
        case RealNamePositionMain:
            image = MF_Image(@"id001");
            _demoIDCardView.image = image;
            contentStr = @"上传要求:\n1.正面照片、字迹清晰、无反光。\n2.必须包含整个身份证，不能缺少边角。";
            break;
        case RealNamePositionBack:
            image = MF_Image(@"id003");
            _demoIDCardView.image = image;
            contentStr = @"上传要求:\n1.反面照片、字迹清晰、无反光。\n2.必须包含整个身份证，不能缺少边角。";
            break;
        case RealNamePositionHandle:
            image = MF_Image(@"id002");
            _demoIDCardView.image = image;
            contentStr = @"上传要求:\n1.正面手持身份证、身份证上的文字清晰可见。\n2.人脸和身份证照片完整显示，不能有遮挡。";
            break;
            
        default:
            break;
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 1.5;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:_titleLab.font, NSForegroundColorAttributeName:_titleLab.textColor} range:NSMakeRange(0, attStr.length)];
    _titleLab.attributedText = attStr;
}

- (void)setIdImage:(UIImage *)idImage
{
    _idImage = idImage;
    _addCardView.idImage = idImage;
}

- (void)setIdImageUrl:(NSString *)idImageUrl
{
    _idImageUrl = idImageUrl;
    _addCardView.idImageUrl = idImageUrl;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
