//
//  MRJAttributedMarkup
//
//  Created by mrjlovetian@gmail.com on 03/09/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRJAttributedStyleAction : NSObject

@property (readwrite, copy) void (^action) ();

- (instancetype)initWithAction:(void (^)())action;
+ (NSArray *)styledActionWithAction:(void (^)())action;
- (NSArray *)styledAction;


@end
