//
//  AtuoLayoutTableViewCell.m
//  LoveQi
//
//  Created by tops on 2018/3/9.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "AtuoLayoutTableViewCell.h"
#import <YYKit.h>
#import <Masonry.h>

@interface AtuoLayoutTableViewCell()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIImageView *mimageView;

@end

@implementation AtuoLayoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.subTitleLab];
    [self.contentView addSubview:self.mimageView];
    
    _titleLab.text = @"lalla mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd mynameshi hshadd ";
    _subTitleLab.text = @"mynameshi hshadd ";
//    [_mimageView setImageURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/xhzengAIB/XHLearnEnglish/master/Screenshots/InstagramFeedTableView2.png"]];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
//        make.right.mas_equalTo(self.mimageView).mas_offset(-10);
    }];
    
    [self.mimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab).offset(10);
        make.top.mas_equalTo(self.titleLab);
        make.right.mas_equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.subTitleLab.mas_bottom);
        make.top.right.left.mas_equalTo(0).mas_offset(-10);
    }];
//    [self setNeedsDisplay];
//    [self updateConstraints];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;
        _titleLab.backgroundColor = [UIColor redColor];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab {
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] init];
        _subTitleLab.backgroundColor = [UIColor orangeColor];
    }
    return _subTitleLab;
}

- (UIImageView *)mimageView {
    if (!_mimageView) {
        _mimageView = [[UIImageView alloc] init];
        _mimageView.backgroundColor = [UIColor purpleColor];
    }
    return _mimageView;
}

#pragma mark set

- (void)setDic:(NSDictionary *)dic {
    _titleLab.text = dic[@"title"];
    _subTitleLab.text = dic[@"subtitle"];
    
//    [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(10);
//    }];
    
    [_subTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.bottom).mas_offset(10);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.subTitleLab.mas_bottom);
        make.top.right.left.mas_equalTo(0).mas_offset(-10);
    }];
}

@end
