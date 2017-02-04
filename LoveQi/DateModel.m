//
//  DateModel.m
//  LoveQi
//
//  Created by MRJ on 2017/1/31.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "DateModel.h"

@implementation DateModel
+ (NSData *)getDataWithPathFile:(NSString *)dateName
{
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    NSString *pathFile = [path stringByAppendingPathComponent:dateName];  //要保存的文件名
    NSData *data = [NSData dataWithContentsOfFile:pathFile];
    return data;
}

+ (BOOL)writeDtatWithPathFile:(NSString *)dateName data:(NSData *)data
{
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    NSString *pathFile = [path stringByAppendingPathComponent:dateName];  //要保存的文件名
    
    
    [data writeToFile:pathFile atomically:YES];  //写入文件
    return YES;
}

//字典转data
+(NSData *)returnDataWithDictionary:(NSDictionary *)dict
{
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"myMind"];
    [archiver finishEncoding];
        return data;
}

//路径文件转dictonary
+(NSDictionary *)returnDictionaryWithData:(NSData *)data
{
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary * myDictionary = [unarchiver decodeObjectForKey:@"myMind"];
    [unarchiver finishDecoding];
    //    NSLog(@"%@", myDictionary);
    return myDictionary;
}

+ (NSData *)getDataFormImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}
@end
