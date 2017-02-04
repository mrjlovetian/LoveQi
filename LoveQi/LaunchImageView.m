//
//  LaunchImageView.m
//  LoveQi
//
//  Created by MRJ on 2017/1/30.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "LaunchImageView.h"
#import <UIImageView+YYWebImage.h>

@interface LaunchImageView()
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation LaunchImageView

+ (void)loadLaunchImage
{
    LaunchImageView *launchImage = [[LaunchImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchImage.tag = 9527;
    [[[UIApplication sharedApplication].delegate window] addSubview:launchImage];
}

+ (void)removeLaunch
{
    LaunchImageView *launchImage = [[[UIApplication sharedApplication].delegate window] viewWithTag:9527];
    [launchImage removeFromSuperview];
    launchImage = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    [self addSubview:self.imageView];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.image = [LaunchImage getImage];
        /*
         YYWebImageOptionUseNSURLCache
         */
    }
    return _imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation LaunchImage
+ (UIImage *)getImage
{
    __block NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"launchImage"];
    NSString *imageUrl = [NSString stringWithFormat:@"https://raw.githubusercontent.com/mrjlovetian/image/master/launchImage/00%d.JPG", (arc4random() % 4) + 1];
    
    UIImage *image = [UIImage imageNamed:@"001.JPG"];
    if (data) {
        image = [UIImage imageWithData:data];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"launchImage"];
    });
    
    
   
    return image;
}

@end
