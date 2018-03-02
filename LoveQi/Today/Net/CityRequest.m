//
//  CityRequest.m
//  LoveQi
//
//  Created by tops on 2018/3/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "CityRequest.h"

@implementation CityRequest

- (MRJ_RequestMethod)requestMethod {
    return MRJ_RequestMethodGET;
}

- (NSString *)requestUrl {
    ///http://gateway.dev.apitops.com/broker-center-api/v1/credit/loan/getCreditDetail
    ///http://mrjloveliqi.com/message/getMenuList
    //    return @"http://gateway.dev.apitops.com/broker-center-api/v1/credit/loan/getCreditDetail";
    return @"http://broker-center.dev.apitops.com/broker-center-web/api/v1/city/getALLLocationCity";
}

@end
