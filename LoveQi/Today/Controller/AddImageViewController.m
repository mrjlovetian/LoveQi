//
//  AddImageViewController.m
//  LoveQi
//
//  Created by Mr on 2018/1/8.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "AddImageViewController.h"
#import <MRJCameraTool.h>
#import "BottomBtnView.h"
#import "ImageCell.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

static NSString *indetif = @"image";

@interface AddImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BottomBtnView *bottomBtnView;
@property (nonatomic, strong) NSMutableArray *itemArr;

@end

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *addImage = MF_Image(@"addRealNameCard");
    [self.itemArr addObject:addImage];
    [self.view addSubview:self.bottomBtnView];
    [self.view addSubview:self.collectionView];
}

#pragma mark Method

- (void)addSelectImage {
    [MRJCameraTool cameraAtView:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary imageWidth:SCREEN_WIDTH maxNum:5+1 - self.itemArr.count success:^(NSArray *images) {
        [self.itemArr removeLastObject];
        [self.itemArr addObjectsFromArray:images];
        UIImage *addImage = MF_Image(@"addRealNameCard");
        [self.itemArr addObject:addImage];
        [self.collectionView reloadData];
    }];
}

#pragma mark MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.itemArr.count-1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithImage:self.itemArr[index]];
    return photo;
}

#pragma mark UICollectionViewDelegate

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.itemArr.count > 5) {
        return 5;
    }
    return self.itemArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indetif forIndexPath:indexPath];
    cell.isHideCloseBtn = (indexPath.row+1 == self.itemArr.count);
    cell.indexPath = indexPath;
    cell.image = self.itemArr[indexPath.row];
    
    cell.imageCellColseBlock = ^{
        [self.itemArr removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
    };
    cell.imageCellTapBlock = ^(NSIndexPath *indexPath) {
        if (indexPath.row+1 == self.itemArr.count) {
            MRJLog(@"添加图片");
            [self addSelectImage];
        } else {
            MRJLog(@"点击图片");
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            [browser setCurrentPhotoIndex:indexPath.row];
            [self.navigationController pushViewController:browser animated:YES];
        }
    };
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT - self.bottomBtnView.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:indetif];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
        layout.itemSize = CGSizeMake(80, 100);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 20;
   }
    return _collectionView;
}

- (NSMutableArray *)itemArr {
    if (!_itemArr) {
        _itemArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemArr;
}

- (BottomBtnView *)bottomBtnView {
    if (!_bottomBtnView) {
        _bottomBtnView = [[BottomBtnView alloc] initWithBottomBtnClick:^(NSString *title) {
            [self addSelectImage];
        }];
    }
    return _bottomBtnView;
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
