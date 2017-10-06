//
//  AddImageBottomView.h
//  LoveQi
//
//  Created by Mr on 2017/10/4.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddImageBlcok)();

@interface AddImageBottomView : UIView
@property (nonatomic, copy)AddImageBlcok addImageBlcok;
@end
