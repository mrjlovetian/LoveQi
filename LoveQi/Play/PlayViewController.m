//
//  PlayViewController.m
//  LoveQi
//
//  Created by tops on 2018/3/12.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "PlayViewController.h"
#import <UILabel+AutomaticWriting.h>

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *LAB = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH - 20, 100)];
    [LAB setText:@"我是小红军" automaticWritingAnimationWithDuration:3.0];
    [self.view addSubview:LAB];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
