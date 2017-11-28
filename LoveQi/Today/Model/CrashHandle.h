//
//  CrashHandle.h
//  LoveQi
//
//  Created by Mr on 2017/11/28.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashHandle : NSObject
{
    BOOL dismissed;
}
void HandleException(NSException *exception);
void SingalHandler(int singal);
void InstallCracshExceptionHandle(void);
@end
