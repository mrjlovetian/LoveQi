//
//  ResultViewController.m
//  LoveQi
//
//  Created by Mr on 2017/10/10.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "QRCResultViewController.h"
#import <WebKit/WebKit.h>
#import <MRJActionSheet.h>

@interface QRCResultViewController ()

@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)UIButton *rightBtn;

@end

@implementation QRCResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.headView addSubview:self.rightBtn];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.qrcResult]]];
    
    // Do any additional setup after loading the view.
}

#pragma mark method

- (void)more {
    NSString *title = [NSString stringWithFormat:@"网页由%@提供", self.webView.URL.host];
    MRJActionSheet *sheet = [[MRJActionSheet alloc] initWithTitle:title buttonTitles:@[@"复制链接", @"在safari上打开"] redButtonIndex:-1 defColor:nil actionSheetClickBlock:^(MRJActionSheet *actionSheet, int buttonIndex) {
        if (buttonIndex == 0) {
            [[UIPasteboard generalPasteboard] setString:self.qrcResult];
        } else if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.qrcResult]];
        }
    }];
    [sheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UI

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT)];
    }
    return _webView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 75, 20, 60, 44);
        [_rightBtn setImage:[UIImage imageNamed:@"ico/btn_more"] forState:UIControlStateNormal];
        _rightBtn.contentMode = UIViewContentModeCenter;
        [_rightBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
