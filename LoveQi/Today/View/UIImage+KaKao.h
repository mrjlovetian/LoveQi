//
//  UIImage+KaKao.h
//  TopBroker3
//
//  Created by 杨红丽 on 16/9/28.
//  Copyright © 2016年 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KaKao)

+(UIImage *)getImageByName:(NSString *)imgName;

+(UIImage *)getImageByName:(NSString *)imgName Path:(NSString *) path;
@end
