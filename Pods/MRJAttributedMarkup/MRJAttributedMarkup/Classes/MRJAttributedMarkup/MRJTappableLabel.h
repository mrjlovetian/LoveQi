//
//  MRJAttributedMarkup
//
//  Created by mrjlovetian@gmail.com on 03/09/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRJTappableLabel : UILabel

@property (nonatomic, readwrite, copy) void (^onTap) (CGPoint);

@end
