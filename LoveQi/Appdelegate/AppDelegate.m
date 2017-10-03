//
//  AppDelegate.m
//  LoveQi
//
//  Created by yhj on 2017/1/17.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LaunchImageView.h"
#import "AddEvevtVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *RootVC = [[RootViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:RootVC];
    self.window.rootViewController = Nav;
    [self.window makeKeyAndVisible];
    [LaunchImageView loadLaunchImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LaunchImageView removeLaunch];
    });
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 3d touch
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if([shortcutItem.type isEqualToString:@"one"]){
        AddEvevtVC *vc = [[AddEvevtVC alloc] init];
        vc.date = [dateFormatter stringFromDate:[NSDate date]];
        [nav pushViewController:vc animated:YES];
    }
//    else if ([shortcutItem.type isEqualToString:@"two"]){
//        AddEvevtVC *vc = [[AddEvevtVC alloc] init];
//        [nav pushViewController:vc animated:YES];
//    }
}


@end
