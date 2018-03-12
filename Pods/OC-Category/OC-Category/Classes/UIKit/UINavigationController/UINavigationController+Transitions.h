//
//  Created by 余洪江 on 16/03/01.
//  Copyright © MRJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transitions)

- (void)pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition;

- (UIViewController *)popViewControllerWithTransition:(UIViewAnimationTransition)transition;

@end
