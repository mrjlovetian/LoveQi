//
//  DynamicMenuViewController.m
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "DynamicMenuViewController.h"
#import "MenuRequest.h"
#import "MenuModel.h"
#import <NSObject+YYModel.h>
#import "MenuViewManger.h"
#import <objc/runtime.h>

@interface DynamicMenuViewController ()

@end

@implementation DynamicMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MenuRequest *request = [[MenuRequest alloc] init];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof MRJ_BaseRequest * _Nonnull request) {
        
        NSDictionary *json = [request.responseObject[@"Data"] objectForKey:@"menuList"];
        NSArray *array = [NSArray modelArrayWithClass:[MenuModel class] json:json];
//        for (MenuModel *model in array) {
//            MRJ_Log(@"----------------------%@", model.titleStr);
//        }
        UIView *menuView = [MenuViewManger getMenuViewWith:array menuBlock:^(NSInteger index, NSString *menuTitleStr, NSString *functionName) {
            MRJ_Log(@"*******************index = %ld, menuStr = %@", index, menuTitleStr);
            SEL selector = NSSelectorFromString(functionName);
            
            class_addMethod(self.class, selector, (IMP)abc, "v:@");
            [self performSelector:selector withObject:nil];
            
            
        }];
        menuView.top = NavBAR_HEIGHT + NavBAR_HEIGHT;
        [self.view addSubview:menuView];

    } failure:^(__kindof MRJ_BaseRequest * _Nonnull request) {
        MRJ_Log(@"error is what ? %@", request.error.localizedDescription);
    }];
    // Do any additional setup after loading the view.
}

void abc() {
    MRJ_Log(@"动态生成的方法");
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
