//
//  PhotoManger.m
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "PhotoManger.h"
#import <MRJCameraTool/MRJCameraTool.h>
#import <MWPhotoBrowser.h>

@interface PhotoManger()<MWPhotoBrowserDelegate>

@end

static PhotoManger *manger;

@implementation PhotoManger
+ (instancetype)sharePhotoManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[PhotoManger alloc] init];
    });
    return manger;
}

+ (void)goToPhotoForKey:(NSString *)key curreVC:(UIViewController *)vc {
    [self sharePhotoManger];
    if ([self getImagesForKey:key].count > 0) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
        browser.delegate = manger;
        browser.startOnGrid = YES;
        [vc.navigationController pushViewController:browser animated:YES];
    } else {
        [self getImageWithAlubm:vc key:key];
    }
}

+ (void)getImageWithAlubm:(UIViewController *)vc key:(NSString *)key {
    [MRJCameraTool cameraAtView:vc imageWidth:SCREEN_WIDTH maxNum:9 success:^(NSArray *images) {
        [self writeImageFoeKey:key imageData:images];
    }];
}

+ (NSArray *)getImagesForKey:(NSString *)key {
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    NSString *pathFile = [path stringByAppendingPathComponent:key];  //要保存的文件名
    NSData *data = [NSData dataWithContentsOfFile:pathFile];
    NSArray *imageArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return imageArray;
}

+ (BOOL)writeImageFoeKey:(NSString *)key imageData:(NSArray *)imageArray {
    NSMutableArray *temArray = [NSMutableArray arrayWithArray:[self getImagesForKey:key]];
    [temArray addObjectsFromArray:imageArray];
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    NSString *pathFile = [path stringByAppendingPathComponent:key];  //要保存的文件名
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temArray];
    return [data writeToFile:pathFile atomically:YES];  //写入文件
}

+ (void)deletImageIndex:(NSInteger)index handle:(void (^)(BOOL result))success {
    NSMutableArray *temArray = [NSMutableArray arrayWithArray:[self getImagesForKey:manger.curreKey]];
    [temArray removeObjectAtIndex:index];
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];  //获得沙箱的 Document 的地址
    NSString *pathFile = [path stringByAppendingPathComponent:manger.curreKey];  //要保存的文件名
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temArray];
    BOOL res = [data writeToFile:pathFile atomically:YES];  //写入文件
    success(res);
}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [PhotoManger getImagesForKey:manger.curreKey].count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [[MWPhoto alloc] initWithImage:[[PhotoManger getImagesForKey:manger.curreKey] objectAtIndex:index]];
    return photo;
}

@end
