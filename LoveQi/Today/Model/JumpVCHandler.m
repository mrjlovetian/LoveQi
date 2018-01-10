//
//  JumpVCHandler.m
//  LoveQi
//
//  Created by Mr on 2017/11/2.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "JumpVCHandler.h"
//#import "LQChatViewController.h"
#import "PDFListViewController.h"
#import <vfrReader/ReaderViewController.h>
#import "AddressBookViewController.h"
#import "RefreshViewController.h"
#import "WebViewController.h"
#import "RealNameViewController.h"
#import "AddImageViewController.h"

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
//        LQChatViewController *vc = [[LQChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"yuhongjiang"];
//        [rootVC.navigationController pushViewController:vc animated:YES];
//        [rootVC.navigationController setNavigationBarHidden:NO];
    } else if (index == 1) {
        PDFListViewController *vc = [[PDFListViewController alloc] init];
        [rootVC.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        
        AddressBookViewController *vc = [[AddressBookViewController alloc] init];
        [rootVC.navigationController pushViewController:vc animated:YES];
    } else if (index == 3) {
        
        NSString *url = @"topbroker://com.kakao.topbroker?params=D3AmOSptQzENWwhCO1JArQoDbW2m17K7RMIW6zHCsXnsBKvQvpaDEB0%2FFxKJGI5xJNM%2Bob6%2FAJvilwOpaIKoyZ6wedh1TecUNgpLFOAB8EatYwTTvZxb2iiT5slOi1lqU297URaPCgcS8fRV0NIch2ZvdpVTcpJI8w25o18jw1Q%3D&sign=AhHHxIM1ZmvsOe8shpl%2FDVAWzsTruE78twQgASxbSOR8NsRlu0fIgrgnoZLU2MfZQpBSt5ERfYlZRn515N237s0w%2B2XNw3%2FfLYYeyLarBw%2Bd%2BOmoqMZTwzy30ZipiLfYnQkI2yz53Y6rDWpt%2BwdBZCrH0KwHr%2BpU59INS85W8Ko%3D";
//        http://gateway.dev.apitops.com/broker-center-api/v1/broker/credit/realName/zhiMaCustomerCertificationCertifyResult?params=D3AmOSptQzENWwhCO1JArQoDbW2m17K7RMIW6zHCsXnsBKvQvpaDEB0%2FFxKJGI5xJNM%2Bob6%2FAJvilwOpaIKoyZ6wedh1TecUNgpLFOAB8EatYwTTvZxb2iiT5slOi1lqU297URaPCgcS8fRV0NIch2ZvdpVTcpJI8w25o18jw1Q%3D&sign=AhHHxIM1ZmvsOe8shpl%2FDVAWzsTruE78twQgASxbSOR8NsRlu0fIgrgnoZLU2MfZQpBSt5ERfYlZRn515N237s0w%2B2XNw3%2FfLYYeyLarBw%2Bd%2BOmoqMZTwzy30ZipiLfYnQkI2yz53Y6rDWpt%2BwdBZCrH0KwHr%2BpU59INS85W8Ko%3D
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];

        
//        NSString *url = @"http://broker-center.dev.apitops.com/broker-center-web/api/v1/broker/credit/realName/zhiMaCustomerCertificationCertifyResult";
//        NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@", [self URLEncodedStringWithUrl:url]];
//        if ([self canOpenAlipay]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否下载并安装支付宝完成认证?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
//            [alertView show];
//        }
    } else if (index == 4) {
//        RefreshViewController *vc = [[RefreshViewController alloc] init];
        AddImageViewController *vc = [[AddImageViewController alloc] init];
        [rootVC.navigationController pushViewController:vc animated:YES];
//        NSArray *arr = @[@""];
//        MRJLog(@"-=-=-=-=-=%@", arr[1]);
    } else if (index == 5) {
        RealNameViewController *vc = [[RealNameViewController alloc] init];
        vc.index = 0;
//        WebViewController *vc = [[WebViewController alloc] init];
         [rootVC.navigationController pushViewController:vc animated:YES];
    }
}

+ (NSString *)URLEncodedStringWithUrl:(NSString *)url {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

+ (BOOL)canOpenAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}

@end
