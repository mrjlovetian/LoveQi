//
//  RealNameAddImageView.m
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import "RealNameAddImageView.h"
#import "UIImageView+YYWebImage.h"

@interface RealNameAddImageView ()
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIImageView *addImageView;
@property (nonatomic, strong)UILabel *titlelab;
@end

@implementation RealNameAddImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.backImageView];
    [self addSubview:self.addImageView];
    [self addSubview:self.titlelab];
}


#pragma mark UI
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _backImageView.layer.cornerRadius = 3.0;
        _backImageView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    }
    return _backImageView;
}


- (UIImageView *)addImageView {
    if (!_addImageView){
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 55)/2.0, 46*V_ScaleRate_New_W, 55, 55)];
        _addImageView.image = MF_Image(@"addRealNameCard");
    }
    return _addImageView;
}

- (UILabel *)titlelab {
    if (!_titlelab) {
        _titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, _addImageView.bottom + 12, _backImageView.width, 16)];
        _titlelab.font = [UIFont systemFontOfSize:16];
        _titlelab.textAlignment = NSTextAlignmentCenter;
        _titlelab.textColor = [UIColor colorWithHexString:@"666666"];
        _titlelab.text = @"上传/拍照";
    }
    return _titlelab;
}

#pragma mark SET
- (void)setIdImage:(UIImage *)idImage {
    _idImage = idImage;
    
    if (idImage) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.addImageView.hidden = YES;
            self.titlelab.hidden = YES;
        }];
        
        _backImageView.image = idImage;
    } else {
        self.addImageView.hidden = NO;
        self.titlelab.hidden = NO;
    }
}

- (void)setIdImageUrl:(NSString *)idImageUrl {
    UIImage *image = MF_Image(@"pic_moren");
    if (idImageUrl.length > 0) {
        self.addImageView.hidden = YES;
        self.titlelab.hidden = YES;
        [_backImageView setImageWithURL:[NSURL URLWithString:idImageUrl] placeholder:image];
    } else {
        self.addImageView.hidden = NO;
        self.titlelab.hidden = NO;
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
