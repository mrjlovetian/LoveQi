//
//  MRJAttributedMarkup
//
//  Created by mrjlovetian@gmail.com on 03/09/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJAttributedStyleAction.h"

NSString *kMRJAttributedStyleAction = @"MRJAttributedStyleAction";

@implementation MRJAttributedStyleAction

- (instancetype)initWithAction:(void (^)())action {
    self = [super init];
    if (self) {
        self.action = action;
    }
    return self;
}

+ (NSArray *)styledActionWithAction:(void (^)())action {
    MRJAttributedStyleAction* container = [[MRJAttributedStyleAction alloc] initWithAction:action];
    return [container styledAction];
}

- (NSArray *)styledAction {
    return @[ @{kMRJAttributedStyleAction:self}, @"link"];
}

@end
