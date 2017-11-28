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
#import "AddressBookViewController.h"

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
        
        AddressBookViewController *vc = [[AddressBookViewController alloc] init];
        [rootVC.navigationController pushViewController:vc animated:YES];
    } else if (index == 3) {
        NSString *url = @"https://zmopenapi.zmxy.com.cn/openapi.do?charset=UTF-8&method=zhima.customer.certification.certify&channel=apppc&sign=XaYJQWRQ6cbmMcK6G7Hrb6XHtB8cVEOyepsZ0uI94C5qZgyLfb6TJCtUz%2FQJa7OgSCQyMwD1fJNL4Bkw%2FM6JKHoUpLvaeAqXO3cMFHHUVr%2FJydbAit04MP15jB8BD0eikQRrff75bUdHUJy45x6Ncv0HZzP6pMkD8J9R%2FmpXdmk%3D&version=1.0&app_id=300001102&sign_type=RSA&platform=zmop&params=VtJourwPr6k46WTld25mBE5Sr9qJlTg%2B8h5zVKA4ifnHucUd0%2Fuko5irBkiQJzFLgFUOOYPBt7FgAUUwfDCsed7ncAeWpGognFXP4fjCGbHytVOR3UVH1UVBfcssTm5IDXL1sAuq50EHMTpNMeoyLp5k8r%2BHvPY0e5BQmaKob%2F0%3D";
        NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@", [self URLEncodedStringWithUrl:url]];
        if ([self canOpenAlipay]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否下载并安装支付宝完成认证?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
            [alertView show];
        }
    } else if (index == 4) {
        NSArray *arr = @[@""];
        MRJLog(@"-=-=-=-=-=%@", arr[1]);
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
