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
//#import <NIMSDK/NIMSDK.h>
#import <RongIMKit/RongIMKit.h>
#import "IMManger.h"
#import <vfrReader/ReaderViewController.h>
#import "CrashHandle.h"

#define RONGYUN_KEY @"lmxuhwagxsc9d"

@interface AppDelegate ()<RCIMUserInfoDataSource, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate, ReaderViewControllerDelegate>

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
    
    InstallCracshExceptionHandle();
    
    /// 
//    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:IMSECRET];
//    [[NIMSDK sharedSDK] registerWithOption:option];
//
//    [IMManger getIMaccid:@"yuhongjiang"];
    // Override point for customization after application launch.
    
//    yuhongjiang
//    e44Ko1cpVJNYdknbCZot73QwxeF68ZWLZaUbo//LltLgMEzFz908u7K/LYULK/MG/JTcoXXkZg6tW0SvGFfFp0Q6e/XqNXUV
    
//    liqi
//    KyWLOe69gcPHyZck51wkkQFkGZgRnLYtCesYOs6LJc6V8i7xt9Q7wdde1lJccv0py4wEtTpd73XfZ9IrGVy44Q==
    [[RCIM sharedRCIM] initWithAppKey:RONGYUN_KEY];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] connectWithToken:@"KyWLOe69gcPHyZck51wkkQFkGZgRnLYtCesYOs6LJc6V8i7xt9Q7wdde1lJccv0py4wEtTpd73XfZ9IrGVy44Q==" success:^(NSString *userId) {
        MRJLog(@"登录成功%@", userId);
    } error:^(RCConnectErrorCode status) {
        MRJLog(@"登录失败%d", status);
    } tokenIncorrect:^{
        
    }];
    
#ifdef Dev
    MRJLog(@"***************************dev");
#elif DEBUG
    MRJLog(@"===========================DEBUG");
#elif Test
    MRJLog(@"===========================TEST");
# else
    MRJLog(@"-=-=-=-=-=");
#endif
    
    
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

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
    ViewController *displayController = (ViewController *)navigation.topViewController;
    
    [displayController.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    [displayController.label setText:sourceApplication];
    
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    UINavigationController *navigation = (UINavigationController *)application.keyWindow.rootViewController;
//    ReaderViewController *displayController = (ReaderViewController *)navigation.topViewController;
    // 1. 实例化控制器
//    NSString *path = [[NSBundle mainBundle] pathForResource:url.path ofType:@"pdf"];
//    ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:path password:nil];
//    [PDFManger savePDFName:url];
    ReaderDocument *pdf = [[ReaderDocument alloc] initWithFilePath:url.path password:nil];
    ReaderViewController *vc = [[ReaderViewController alloc] initWithReaderDocument:pdf];
    vc.delegate = self;
    [navigation pushViewController:vc animated:YES];
    return YES;
}
#endif

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
//    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];
    [viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark RCIMConnectionStatusDelegate
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark RCIMReceiveMessageDelegate

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left {
    MRJLog(@"-=-=-=-=-=-=%@", message);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:nil];
}

#pragma mark RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    if ([userId isEqualToString:@"liqi"]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"liqi";
        user.name = @"李琦";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    } else {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"yuhongjiang";
        user.name = @"余洪江";
        return completion(user);
    }
    
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
