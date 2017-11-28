//
//  CrashHandle.m
//  LoveQi
//
//  Created by Mr on 2017/11/28.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "CrashHandle.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>

NSString *const CrashExceptionHandlerSignalExceptionName = @"CrashExceptionHandlerSignalExceptionName";
NSString *const CrashExceptionHandlerSignalKey = @"CrashExceptionHandlerSignalKey";
NSString *const CrashExceptionHandlerAddressesKey = @"CrashExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation CrashHandle

+ (NSArray *)backtrace {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
    if (anIndex == 0){
        dismissed = NO;
    }else if (anIndex == 1) {
          NSLog(@"ssssssss");
    }
}

- (void)validateAndSaveCriticalApplicationData {
    // 崩溃拦截可以做的事,写在这个方法也是极好的
    MRJLog(@"这里可以干啥呢");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MRJLog(@"原来还在运行啊");
//        exit(0);
    });
}

- (void)handleException:(NSException *)exception {
    [self validateAndSaveCriticalApplicationData];
    //这里可以打印或者显示出ERROR的原因.
     NSString *message = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开"@"异常原因如下:\n%@\n%@",nil),[exception reason],[[exception userInfo] objectForKey:CrashExceptionHandlerAddressesKey]];
    
    //设置弹出框来了提醒用户, 当然也可以是自己设计其他内容,
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开",nil)];
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常",nil)
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"继续",nil)
                                       otherButtonTitles:NSLocalizedString(@"退出",nil), nil];
    [alert show];
    
    // 利用RunLoop , 来完成拦截的操作
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);

    while (!dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode,0.001, false);
        }
    }
    
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT,SIG_DFL);
    signal(SIGILL,SIG_DFL);
    signal(SIGSEGV,SIG_DFL);
    signal(SIGFPE,SIG_DFL);
    signal(SIGBUS,SIG_DFL);
    signal(SIGPIPE,SIG_DFL);
    
    [exception raise];
    if ([[exception name] isEqual:CrashExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:CrashExceptionHandlerSignalKey]intValue]);
    }else{
        [exception raise];
    }
}

@end

// 程序崩溃时1(程序崩溃是首先进入的方法, 你可以debug自己调试)
void HandleException(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSArray *callStack = [CrashHandle backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];[userInfo setObject:callStack forKey:CrashExceptionHandlerAddressesKey];
    
    [[[CrashHandle alloc] init]performSelectorOnMainThread:@selector(handleException:)withObject:
     [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo]waitUntilDone:YES];
    
}

void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:CrashExceptionHandlerSignalKey];
    
    NSArray *callStack = [CrashHandle backtrace];
    [userInfo setObject:callStack forKey:CrashExceptionHandlerAddressesKey];
    
    [[[CrashHandle alloc] init] performSelectorOnMainThread:@selector(handleException:)withObject:[NSException exceptionWithName:CrashExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.",nil),signal]userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]forKey:CrashExceptionHandlerSignalKey]]waitUntilDone:YES];
}

//. 进入程序时(在AppDelegate.m)里添加那行代码后,就会启用这行代码了
void InstallCracshExceptionHandle(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGHUP, SignalHandler);
    signal(SIGINT, SignalHandler);
    signal(SIGQUIT, SignalHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
