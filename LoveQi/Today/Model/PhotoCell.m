//
//  PhotoCell.m
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell()
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *deleteBtn;
@end

@implementation PhotoCell

#pragma mark Method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.imageView];
    [self addSubview:self.deleteBtn];
    self.backgroundColor = [UIColor clearColor];
}

- (void)removePhoto {
    if (self.photoBlcok) {
        self.photoBlcok();
    }
}

#pragma mark UI

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.width - 20, 0, 20, 20);
        _deleteBtn.backgroundColor = [UIColor redColor];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(removePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

#pragma mark SET

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setCanDelete:(BOOL)canDelete {
    _canDelete = canDelete;
    _deleteBtn.hidden = !canDelete;
}

@end
