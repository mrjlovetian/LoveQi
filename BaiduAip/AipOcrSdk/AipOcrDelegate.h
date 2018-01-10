//
// OCR识别结果delegate
// Created by chenxiaoyu on 17/3/2.
// Copyright (c) 2017 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AipOcrDelegate <NSObject>

@optional
- (void) ocrOnIdCardSuccessful:(id)result image:(UIImage*)image;

@optional
- (void) ocrOnBankCardSuccessful:(id)result image:(UIImage*)image;

@optional
- (void) ocrOnGeneralSuccessful:(id)resut image:(UIImage*)image;

@optional
- (void) ocrOnFail:(NSError *)error;
@end
