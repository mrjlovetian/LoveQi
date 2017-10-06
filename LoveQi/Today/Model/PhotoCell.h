//
//  PhotoCell.h
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoHandle)();

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)BOOL canDelete;
@property (nonatomic, copy)PhotoHandle photoBlcok;
@end
