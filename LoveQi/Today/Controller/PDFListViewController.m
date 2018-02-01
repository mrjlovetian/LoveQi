//
//  PDFListViewController.m
//  LoveQi
//
//  Created by Mr on 2017/11/2.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "PDFListViewController.h"
#import <vfrReader/ReaderViewController.h>

@interface PDFListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ReaderViewControllerDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation PDFListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headView.titleStr = @"书籍目录";
    
    [self.view addSubview:self.collectionView];
    
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *pdfArr = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:DocumentsPath error:nil]];
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:1];
    [pdfArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temArray addObject:[NSString stringWithFormat:@"%@/%@", DocumentsPath, obj]];
    }];
    self.dataSource = temArray;
    [self.collectionView reloadData];
}

#pragma mark ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pdf" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReaderDocument *pdf = [[ReaderDocument alloc] initWithFilePath:self.dataSource[indexPath.row] password:nil];
    ReaderViewController *vc = [[ReaderViewController alloc] initWithReaderDocument:pdf];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH - NavBAR_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"pdf"];
    }
    return _collectionView;
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
