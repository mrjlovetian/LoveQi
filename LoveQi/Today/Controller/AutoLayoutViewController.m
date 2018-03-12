//
//  AutoLayoutViewController.m
//  LoveQi
//
//  Created by tops on 2018/3/9.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "AutoLayoutViewController.h"
#import "Masonry.h"
#import "AtuoLayoutTableViewCell.h"

@interface AutoLayoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation AutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavBAR_HEIGHT);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(SCREEN_HEIGHT).offset(0);
    }];
    
    
    self.dataSource = @[@{@"title":@"标题是标题是标题是标题是标题是标题是标题是标题是", @"subtitle":@"这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是", @"subtitle":@"这是一个指标i", @"imageurl":@""}, @{@"title":@"标题是这是一个指标i这是一个指标i这是一个指标i这是一个指标i", @"subtitle":@"这是一个指标i", @"imageurl":@""}];
    
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AtuoLayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AtuoLayoutTableViewCell"];
    cell.dic = self.dataSource[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", indexPath, @"君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑君莫笑"];
//    cell.textLabel.numberOfLines = 0;
//    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(10);
//        make.right.mas_equalTo(-15);
//    }];
    return cell;
}

#pragma mark UI

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AtuoLayoutTableViewCell class] forCellReuseIdentifier:@"AtuoLayoutTableViewCell"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

@end
