//
//  MeiTuanDeatilViewController.m
//  LoveQi
//
//  Created by tops on 2018/1/31.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "MeiTuanDeatilViewController.h"

@interface MeiTuanDeatilViewController () <UIScrollViewDelegate>


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *temLab;
@property (nonatomic, strong) UILabel *receiveLab;

@property (nonatomic, strong) UIScrollView *scrollView;

#define c_x 90.0
#define c_y 10.0

#define d_x 20.0
#define d_y 130.0

@end

@implementation MeiTuanDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headView.backgroundColor = [UIColor colorWithHexString:@"ff801a"];
    
    [self.view addSubview:self.scrollView];
    [self.view bringSubviewToFront:self.headView];
    [self.headView addSubview:self.titleLab];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 40, 40);
    [rightBtn setTitle:@"点击" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:rightBtn];
    [self.scrollView addSubview:self.receiveLab];
    [self.view addSubview:self.temLab];
    // Do any additional setup after loading the view.
}

- (void)chengeLabelWithM:(CGFloat)m {
    CGFloat x = (d_x - c_x) * m;
    CGFloat y = (d_y - c_y) * m;
    
    self.temLab.frame = CGRectMake(d_x - x, d_y - y, self.titleLab.width, self.titleLab.height);
    MRJLog(@"..........%f----- -%@", m, NSStringFromCGRect(self.temLab.frame));
    self.temLab.text = self.receiveLab.text;
    self.titleLab.text = self.receiveLab.text;
    
    if (m <= 0) {
        self.receiveLab.hidden = NO;
        self.temLab.hidden = YES;
        self.titleLab.hidden = YES;
    } else if (m >= 1.0) {
        self.receiveLab.hidden = YES;
        self.temLab.hidden = YES;
        self.titleLab.hidden = NO;
    } else {
        self.receiveLab.hidden = YES;
        self.temLab.hidden = NO;
        self.titleLab.hidden = YES;
    }
}

- (void)clickBtn {
    static BOOL flag = YES;
    
    
    self.temLab.hidden = NO;
    CGRect titleRect = [self.headView convertRect:self.titleLab.frame toView:self.view];
    CGRect receiveRect = [self.scrollView convertRect:self.receiveLab.frame toView:self.view];
    if (flag) {
        
//        self.temLab.frame = titleRect;
//        self.temLab.text = self.titleLab.text;
//        self.titleLab.hidden = YES;
//
//        [UIView animateWithDuration:3.0 animations:^{
//            self.temLab.frame = receiveRect;
//        } completion:^(BOOL finished) {
//            self.receiveLab.hidden = NO;
//            self.receiveLab.text = self.temLab.text;
//            self.temLab.hidden = YES;
//        }];
//    } else {
//        self.temLab.frame = receiveRect;
//        self.temLab.text = self.titleLab.text;
//        self.receiveLab.hidden = YES;
//
//
//
//
//        [UIView animateWithDuration:3.0 animations:^{
//            self.temLab.frame = titleRect;
//        } completion:^(BOOL finished) {
//            self.titleLab.hidden = NO;
//            self.receiveLab.text = self.temLab.text;
//            self.temLab.hidden = YES;
//        }];
    }
    
    flag = !flag;
    MRJLog(@"***************titleRect = %@, ***************receiveRect = %@", NSStringFromCGRect(titleRect), NSStringFromCGRect(receiveRect));
}

#pragma mark UI

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(c_x, c_y, 100, 20)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
//        _titleLab.text = @"标题";
    }
    return _titleLab;
}

- (UILabel *)receiveLab {
    if (!_receiveLab) {
        _receiveLab = [[UILabel alloc] initWithFrame:CGRectMake(d_x, d_y, 100, 20)];
        _receiveLab.textAlignment = NSTextAlignmentCenter;
        _receiveLab.text = @"文字内容";
    }
    return _receiveLab;
}

- (UILabel *)temLab {
    if (!_temLab) {
        _temLab = [[UILabel alloc] init];
        _temLab.textAlignment = NSTextAlignmentCenter;
    }
    return _temLab;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 10);
    }
    return _scrollView;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MRJLog(@"-------------------%f", scrollView.contentOffset.y);
    CGFloat y = scrollView.contentOffset.y;
    if (y < 0) {
        self.headView.alpha = 0;
        [self chengeLabelWithM:0];
    } else {
        CGFloat m = y/(d_y - c_y);
        self.headView.alpha = m;
        MRJLog(@"******************%f", m);
        [self chengeLabelWithM:m];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
