//
//  DateModel.h
//  LoveQi
//
//  Created by MRJ on 2017/1/31.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject
///文件读取
+ (NSData *)getDataWithPathFile:(NSString *)dateName;

///文件写入
+ (BOOL)writeDtatWithPathFile:(NSString *)dateName data:(NSData *)data;

///字典转data
+(NSData *)returnDataWithDictionary:(NSDictionary *)dict;

///data文件转dictonary
+(NSDictionary *)returnDictionaryWithData:(NSData *)data;

///设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

///图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
