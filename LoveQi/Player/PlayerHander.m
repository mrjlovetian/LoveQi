//
//  PlayerHander.m
//  LoveQi
//
//  Created by tops on 2018/2/28.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "PlayerHander.h"

static PlayerHander *player;

@implementation PlayerHander

+ (id)sharedPlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[PlayerHander alloc] init];
    });
    return player;
}

@end
