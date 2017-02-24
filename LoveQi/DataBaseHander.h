//
//  DataBaseHander.h
//  LoveQi
//
//  Created by Mr on 2017/2/23.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseHander : NSObject
+ (instancetype)shareDataBase;

+ (BOOL)creatableSql:(NSString *)sql;

+ (BOOL)insertToSql:(NSString *)sql;

+ (NSArray *)selectSql:(NSString *)sql;

+ (BOOL)deleteSql:(NSString *)sql;

+ (BOOL)dropSql:(NSString *)sql;
@end
