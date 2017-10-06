//
//  AddEventView.h
//  LoveQi
//
//  Created by MRJ on 2017/1/29.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapPhoto)(NSString *photoName);
@interface AddEventView : UIView

@property (nonatomic, strong)UIButton *addEventBtn;
@property (nonatomic, copy)TapPhoto tapPhotoBlcok;
@end
