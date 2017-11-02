//
//  PhotoManger.h
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManger : NSObject

@property (nonatomic, copy)NSString *curreKey;

@property (nonatomic, copy)NSArray *photoArray;

+ (instancetype)sharePhotoManger;

+ (void)goToPhotoForKey:(NSString *)key curreVC:(UIViewController *)vc;

+ (void)getImageWithAlubm:(UIViewController *)vc key:(NSString *)key;

+ (void)deletImageIndex:(NSInteger)index handle:(void (^)(BOOL result))success;

/// 获得所有的照片
+ (NSArray *)getImagesForKey:(NSString *)key;

/// 保存图片
+ (BOOL)writeImageFoeKey:(NSString *)key imageData:(NSArray *)imageArray;

@end
