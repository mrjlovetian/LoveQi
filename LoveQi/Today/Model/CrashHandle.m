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

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 19;

@implementation CrashHandle

/*
 int backtrace(void **buffer,int size)
 该函数用与获取当前线程的调用堆栈,获取的信息将会被存放在buffer中,它是一个指针数组。参数 size 用来指定buffer中可以保存多少个void* 元素。函数返回值是实际获取的指针个数,最大不超过size大小在buffer中的指针实际是从堆栈中获取的返回地址,每一个堆栈框架有一个返回地址。
 注意某些编译器的优化选项对获取正确的调用堆栈有干扰,另外内联函数没有堆栈框架;删除框架指针也会使无法正确解析堆栈内容
 char ** backtrace_symbols (void *const *buffer, int size)
 backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组. 参数buffer应该是从backtrace函数获取的数组指针,size是该数组中的元素个数(backtrace的返回值)，函数返回值是一个指向字符串数组的指针,它的大小同buffer相同.每个字符串包含了一个相对于buffer中对应元素的可打印信息.它包括函数名，函数的偏移地址,和实际的返回地址
 现在,只有使用ELF二进制格式的程序和苦衷才能获取函数名称和偏移地址.在其他系统,只有16进制的返回地址能被获取.另外,你可能需要传递相应的标志给链接器,以能支持函数名功能(比如,在使用GNU ld的系统中,你需要传递(-rdynamic))
 backtrace_symbols生成的字符串都是malloc出来的，但是不要最后一个一个的free，因为backtrace_symbols是根据backtrace给出的call stack层数，一次性的malloc出来一块内存来存放结果字符串的，所以，像上面代码一样，只需要在最后，free backtrace_symbols的返回指针就OK了。这一点backtrace的manual中也是特别提到的。
 注意:如果不能为字符串获取足够的空间函数的返回值将会为NULL
 */

+ (NSArray *)backtrace {
//    NSMutableArray* callers = [NSMutableArray array];
//    int limit = 128;
//    void *callstack[128];
//    int frames = backtrace(callstack, (int)limit);
//    char **strs = backtrace_symbols(callstack, frames);
//    int offset = 3;
//    while(offset < frames) {
//        [callers addObject: [NSString stringWithUTF8String: strs[offset]]];
//        offset++;
//    }
//    free(strs);
//    return callers;
    
    /// 第二种
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;

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
    MRJLog(@"-=-=-==-=-==-=-%@", message);
    
    //设置弹出框来了提醒用户, 当然也可以是自己设计其他内容,
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开",nil)];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常",nil)
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
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);

    [exception raise];
    if ([[exception name] isEqual:CrashExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:CrashExceptionHandlerSignalKey]intValue]);
    } else {
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
//    NSArray *callStack = [CrashHandle backtrace];
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:CrashExceptionHandlerAddressesKey];
    
    CrashHandle *handle = [[CrashHandle alloc] init];
    [handle handleException:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo]];
    
}

void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:CrashExceptionHandlerSignalKey];
    
    NSArray *callStack = [CrashHandle backtrace];
//    NSArray *callStack = [exception callStackSymbols];
    [userInfo setObject:callStack forKey:CrashExceptionHandlerAddressesKey];
    CrashHandle *handle = [[CrashHandle alloc] init];
    [handle handleException:[NSException exceptionWithName:CrashExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.",nil),signal]userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]forKey:CrashExceptionHandlerSignalKey]]];
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


