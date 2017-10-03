//
//  LaunchImageView.h
//  LoveQi
//
//  Created by MRJ on 2017/1/30.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchImageView : UIView

+ (void)loadLaunchImage;

+ (void)removeLaunch;

@end

@interface LaunchImage : NSObject
+ (UIImage *)getImage;


@end
