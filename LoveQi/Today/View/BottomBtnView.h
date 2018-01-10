//
//  BottomBtnView.h
//  TopBroker3
//
//  Created by Mr on 2017/11/3.
//  Copyright © 2017年 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BottomClickHandle)(NSString *title);

@interface BottomBtnView : UIView

@property (nonatomic, strong)UIButton *clickBtn;

- (instancetype)initWithBottomBtnClick:(BottomClickHandle)handle;

@end
