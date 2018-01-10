//
// Created by chenxiaoyu on 17/2/15.
// Copyright (c) 2017 baidu. All rights reserved.
//
// 一个测试类，release中删除

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TestImages : NSObject

- (void) imageWithURL:(NSString *)url
    completionHandler:(void (^)(UIImage *image))handler;

- (void) test1;
@end