//
//  SQLViewconTroller.m
//  LoveQi
//
//  Created by Mr on 2017/2/23.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "SQLViewconTroller.h"
#import "DataBaseHander.h"

@interface SQLViewconTroller ()

@end

@implementation SQLViewconTroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *result = [DataBaseHander selectSql:@"select * from lqTable where name = 'mick'"];
    
    MRJLog(@"-=-=-=-=-=-=-==%@", result);
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *filePath = [path stringByAppendingString:@"LQ.db"];
//    
//    FMDatabase *base = [FMDatabase databaseWithPath:filePath];
//    BOOL isOpen = [base open];
//    if (isOpen) {
//        YHJLog(@"数据库打开成功");
//        
//        NSString *insert = @"insert into lqTable (id, name, content) values (10, 'mick', 'this is very good database')";
//        BOOL i1 = [base executeUpdate:insert];
//        if (i1) {
//            YHJLog(@"成功插入数据");
//        }
//        
//        
//        NSString *selectSql = @"select * from lqTable";
//        FMResultSet *result = [base executeQuery:selectSql];
//    
//        while (result.next) {
//            YHJLog(@"查询结果%@ content=%@", [result stringForColumn:@"name"], [result stringForColumn:@"content"]);
//        }
    
        
        /*NSString *createTable = @"create table lqTable (id integer, name varchar, content varchar)";
        BOOL c1 = [base executeUpdate:createTable];
        if (c1) {
            YHJLog(@"创建表成功");
            NSString *insert = @"insert into lqTable (name, content) values ('mick', 'this is very good database')";
            BOOL i1 = [base executeUpdate:insert];
            if (i1) {
                YHJLog(@"成功插入数据");
            }
            
            
        }*/
//    }
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
//    
//    [queue inDatabase:^(FMDatabase *db) {
//        
//    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
