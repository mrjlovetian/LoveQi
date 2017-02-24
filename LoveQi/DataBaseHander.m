//
//  DataBaseHander.m
//  LoveQi
//
//  Created by Mr on 2017/2/23.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "DataBaseHander.h"
#import <FMDB.h>

static DataBaseHander *dataBaseHander = nil;

@interface DataBaseHander()
@property (nonatomic, strong)FMDatabase *dataBase;
@end

@implementation DataBaseHander
+ (instancetype)shareDataBase
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseHander = [[DataBaseHander alloc] init];
    });
    return dataBaseHander;
}

+ (BOOL)creatableSql:(NSString *)sql
{
    return [[[self shareDataBase] dataBase] executeQuery:sql];
}

+ (BOOL)insertToSql:(NSString *)sql
{
    return [[[self shareDataBase] dataBase] executeQuery:sql];
}

+ (NSArray *)selectSql:(NSString *)sql
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    FMResultSet *result = [[[self shareDataBase] dataBase] executeQuery:sql];
    while (result.next) {
        NSDictionary *dic = @{@"name":[result stringForColumn:@"name"], @"content":[result stringForColumn:@"content"]};
        [arr addObject:dic];
    }
    return arr;
}

+ (BOOL)deleteSql:(NSString *)sql
{
    return [[[self shareDataBase] dataBase] executeQuery:sql];
}

+ (BOOL)dropSql:(NSString *)sql
{
    return [[[self shareDataBase] dataBase] executeQuery:sql];
}

- (FMDatabase *)dataBase
{
    if (!_dataBase) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [path stringByAppendingString:@"LQ.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:filePath];
        if (_dataBase.open) {
            YHJLog(@"数据库打开成功");
        }else
        {
            YHJLog(@"数据库打开失败");
        }
    }
    return _dataBase;
}
@end
