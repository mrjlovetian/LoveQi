//
//  RefreshViewController.m
//  LoveQi
//
//  Created by Mr on 2017/12/25.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "RefreshViewController.h"
#import "MRJFooter.h"

@interface RefreshViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL refresh;

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
        self.tableView.mj_footer = [MRJFooter footerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.refresh) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    weakSelf.refresh = !weakSelf.refresh;
                } else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                    weakSelf.refresh = !weakSelf.refresh;
                }
            });
        }];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            
        });
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indetif = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetif];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetif];
    }
    return cell;
}

#pragma mark UI

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT - 100)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
