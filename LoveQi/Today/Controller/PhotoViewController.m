//
//  PhotoViewController.m
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "PhotoViewController.h"
#import <MWPhotoBrowser.h>
#import "PhotoManger.h"
#import "PhotoCell.h"
#import "AddImageBottomView.h"
#import "MRJCameraTool.h"
#import <UIScrollView+EmptyDataSet.h>

@interface PhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)AddImageBottomView *bottomView;
@property (nonatomic, assign)BOOL canDelete;
@end

@implementation PhotoViewController

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[PhotoManger getImagesForKey:self.photoName] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.image = [[PhotoManger getImagesForKey:self.photoName] objectAtIndex:indexPath.row];
    cell.canDelete = _canDelete;
    cell.photoBlcok = ^{
        [PhotoManger deletImageIndex:indexPath.row handle:^(BOOL result) {
            if (result) {
                [_collectionView reloadData];
            }
        }];
    };
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
    browser.delegate = self;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [[PhotoManger getImagesForKey:self.photoName] count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [[MWPhoto alloc] initWithImage:[[PhotoManger getImagesForKey:self.photoName] objectAtIndex:index]];
    return photo;
}

#pragma mark DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"这里空空的"];
    return titleStr;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *decriptStr = [[NSMutableAttributedString alloc] initWithString:@"去添加一些你们留下照片吧！"];
    return decriptStr;
}

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    UIImage *image = [UIImage imageNamed:@"001.JPG"];
//    return image;
//}

#pragma mark Method

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.photoName isEqualToString:@"mrj"]) {
        self.title = @"这里是小江江";
    } else {
        self.title = @"这里是小李琦";
    }
    
    [PhotoManger sharePhotoManger].curreKey = self.photoName;
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editPhoto)];
    self.navigationItem.rightBarButtonItem = editBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    
    __weak typeof(self) weakSelf = self;
    _bottomView.addImageBlcok = ^{
        [MRJCameraTool cameraAtView:weakSelf imageWidth:SCREEN_WIDTH maxNum:9 success:^(NSArray *images) {
            [PhotoManger writeImageFoeKey:weakSelf.photoName imageData:images];
            [weakSelf.collectionView reloadData];
        }];
    };
}

- (void)editPhoto {
    if ([[PhotoManger getImagesForKey:self.photoName] count] > 0) {
        _canDelete = !_canDelete;
        [_collectionView reloadData];
    } else {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"还没有添加照片哦" message:@"点击下面的添加按钮添加吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [vc addAction:confirmAction];
        [vc addAction:cancelAction];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20)/3.0, (SCREEN_WIDTH - 20)/3.0 * 1.33);
        layout.minimumLineSpacing = 10;
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    }
    return _collectionView;
}

- (AddImageBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[AddImageBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 40)];
    }
    return _bottomView;
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
