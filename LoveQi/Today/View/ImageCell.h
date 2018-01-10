//
//  ImageCell.h
//  LoveQi
//
//  Created by Mr on 2018/1/8.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageCellColseBolck)();
typedef void(^ImageCellTapBlock)(NSIndexPath *indexPath);

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isHideCloseBtn;

@property (nonatomic, copy) ImageCellColseBolck imageCellColseBlock;
@property (nonatomic, copy) ImageCellTapBlock imageCellTapBlock;

@end
