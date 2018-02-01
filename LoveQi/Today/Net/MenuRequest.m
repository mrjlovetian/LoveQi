//
//  MenuRequest.m
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "MenuRequest.h"

@implementation MenuRequest

- (MRJ_RequestMethod)requestMethod {
    return MRJ_RequestMethodGET;
}

- (NSString *)requestUrl {
    ///http://gateway.dev.apitops.com/broker-center-api/v1/credit/loan/getCreditDetail
    ///http://mrjloveliqi.com/message/getMenuList
//    return @"http://gateway.dev.apitops.com/broker-center-api/v1/credit/loan/getCreditDetail";
    return @"http://mrjloveliqi.com/message/getMenuList";
}

@end
