//
//  JumpVCHandler.m
//  LoveQi
//
//  Created by Mr on 2017/11/2.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "JumpVCHandler.h"
#import "LQChatViewController.h"
#import "PDFListViewController.h"
#import <vfrReader/ReaderViewController.h>

@implementation JumpVCHandler

+ (void)PushRootVC:(UIViewController *)rootVC jumpVC:(UIViewController *)jumpVC {
    [rootVC.navigationController pushViewController:jumpVC animated:YES];
}

+ (void)presentRootVC:(UIViewController *)rootVC jumpVC:(UIViewController *)jumpVC {
    [rootVC presentViewController:rootVC animated:YES completion:nil];
}

+ (void)jumpRootVC:(UIViewController *)rootVC toIndex:(NSInteger)index {
    if (index == 0) {
        //liqi
        LQChatViewController *vc = [[LQChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"yuhongjiang"];
        [rootVC.navigationController pushViewController:vc animated:YES];
        [rootVC.navigationController setNavigationBarHidden:NO];
    } else if (index == 1) {
        PDFListViewController *vc = [[PDFListViewController alloc] init];
        [rootVC.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        
    }
}

@end
