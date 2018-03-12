//
//  MRJViewController.m
//  LoveQi
//
//  Created by Mr on 2017/10/9.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "MRJViewController.h"
#import "UIColor+MRJAdditions.h"
#import "Macro.h"

@interface MRJViewController ()

@end

@implementation MRJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.headView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    self.headView.handleBlock = ^{
        if(weakSelf.navigationController == nil){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)setHideBackView:(BOOL)isHide {
    self.headView.hideBackBtn = isHide;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HeardView *)headView {
    if (!_headView) {
        _headView = [[HeardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBAR_HEIGHT)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.headView.titleStr = titleStr;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES ;
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
