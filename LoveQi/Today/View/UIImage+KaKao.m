//
//  UIImage+KaKao.m
//  TopBroker3
//
//  Created by 杨红丽 on 16/9/28.
//  Copyright © 2016年 kakao. All rights reserved.
//

#import "UIImage+KaKao.h"

@implementation UIImage (KaKao)

+(UIImage *)getImageByName:(NSString *)imgName{
    
    if (imgName) {
        
        UIImage *image =  [UIImage imageNamed:imgName];
        
        return image;
        
    }
    else{
        return nil;
    }
}

+(UIImage *)getImageByName:(NSString *)imgName Path:(NSString *) path{
    
    if (imgName) {
        
        UIImage *image =  [UIImage imageNamed:imgName];
        
        if (image==nil) {
        }
        
        return image;
    }
    else{
        return nil;
    }
}

@end
