//
//  MRJAttributedMarkup
//
//  Created by mrjlovetian@gmail.com on 03/09/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (MRJTagReplace)

- (void)replaceAllTagsIntoArray:(NSMutableArray *)array;

@end
