//
//  MRJAttributedMarkup
//
//  Created by mrjlovetian@gmail.com on 03/09/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJTappableLabel.h"

@implementation MRJTappableLabel

- (void)setOnTap:(void (^)(CGPoint))onTap {
    _onTap = onTap;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint pt = [gesture locationInView:self];
        if (self.onTap) {
            self.onTap(pt);
        }
    }
}

@end
