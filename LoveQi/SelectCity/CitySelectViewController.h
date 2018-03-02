//
//  CitySelectViewController.h
//  LoveQi
//
//  Created by tops on 2018/3/1.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import <MRJViewController.h>
#import "CityModelManger.h"

@protocol SelectCityListVCDelegate <NSObject>

- (void)selectCityDidResults:(CityModelManger *)city;

@end

@interface CitySelectViewController : MRJViewController

@property (nonatomic,weak)id <SelectCityListVCDelegate>delegate;

@end
