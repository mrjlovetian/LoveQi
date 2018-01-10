//
//  AddIDCardView.h
//  TopBroker3
//
//  Created by Mr on 2017/8/31.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameProgressView.h"

typedef void(^SelectImageBlcok)();

typedef void (^BlowPictureBlock)();

@interface AddIDCardView : UIView
@property (nonatomic, assign)RealNamePosition realNamePosition;

@property (nonatomic, copy)SelectImageBlcok selectImageBlock;

@property (nonatomic, copy)BlowPictureBlock blowPictureBlock;

@property (nonatomic, strong)UIImage *idImage;

@property (nonatomic, copy)NSString *idImageUrl;
@end
