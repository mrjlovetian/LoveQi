//
//  RunloopViewController.m
//  LoveQi
//
//  Created by tops on 2018/2/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "RunloopViewController.h"
#import <CoreFoundation/CoreFoundation.h>

typedef void(^TaskBlock)();

@interface RunloopViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *tasks;

@end

static NSString *cellindetif = @"cellindetif";

@implementation RunloopViewController

- (void)nonThing {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tasks = [NSMutableArray arrayWithCapacity:1];
    
    [self.view addSubview:self.tableView];
    
    if (@available (iOS 11, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(nonThing) userInfo:nil repeats:YES];
    
//    [self receiveMethod];
    
//    [self.view addSubview:self.scrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Method

- (void)addBlock:(TaskBlock)block {
    [self.tasks addObject:block];
}

- (void)receiveMethod {
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAfterWaiting, YES, 0, &callBack, &context);
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
    
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunloopViewController *VC = (__bridge RunloopViewController *)info;
    MRJLog(@"......%@", VC.tasks);
    if (VC.tasks.count > 0) {
        TaskBlock block = VC.tasks[0];
        block();
        [VC.tasks removeObjectAtIndex:0];
    }
}

#pragma mark UI

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellindetif];
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollView;
}

#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindetif];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindetif forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellindetif];
//    }
//    [self addBlock:^{
        cell.imageView.image = [UIImage imageNamed:@"runloop"];
//    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
