//
//  IMManger.m
//  LoveQi
//
//  Created by Mr on 2017/10/5.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "IMManger.h"
#import <NSDate+Extension.h>
#import <NSString+Hash.h>
#import <AFNetworking.h>

@implementation IMManger

+ (void)getIMaccid:(NSString *)accid {
    NSString *Nonce = @"897011805";
//    [[NSDate date] timeIntervalSince1970];
    NSString *curreTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *CheckSum = [[NSString stringWithFormat:@"%@%@%@", IMSECRET, Nonce, curreTime] sha1String];
    
    NSDictionary *parm = @{@"accid":accid};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", Nonce] forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:curreTime forHTTPHeaderField:@"curreTime"];
    [manager.requestSerializer setValue:CheckSum forHTTPHeaderField:@"CheckSum"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:IMSECRET forHTTPHeaderField:@"AppKey"];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    [manager POST:@"https://api.netease.im/nimserver/user/create.action" parameters:parm progress:^(NSProgress * _Nonnull uploadProgress) {
        MRJLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MRJLog(@"请求成功%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MRJLog(@"请求失败%@", error.localizedDescription);
    }];
    
}


@end
