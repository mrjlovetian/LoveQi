//
//  RootViewController.m
//  LoveQi
//
//  Created by yhj on 2017/1/17.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "RootViewController.h"
#import <FSCalendar.h>
#import <EventKit/EventKit.h>
#import "Header.h"
#import "AddEvevtVC.h"
#import "AddEventView.h"
#import <UIImageView+YYWebImage.h>
#import <YYAnimatedImageView.h>
#import <BHBPopView.h>
#import "DateModel.h"
#import "JumpDateView.h"

@interface RootViewController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, JumpDateViewDelegate>

@property (nonatomic, strong)YYAnimatedImageView *backImageView;

@property (nonatomic, strong)FSCalendar *fscalendar;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, strong)NSDate *minimumDate;

@property (nonatomic, strong)NSDate *maximumDate;

@property (nonatomic, strong)NSCalendar *lunarCalendar;

@property (strong, nonatomic) NSArray<NSString *> *lunarChars;

@property (strong, nonatomic) NSArray<EKEvent *> *events;

@property (strong, nonatomic) NSCache *cache;

@property (nonatomic, strong)AddEventView *bottomView;

@property (nonatomic, strong)JumpDateView *jumpDateView;

@property (nonatomic, copy)NSString *selectDate;

@property (nonatomic, strong)NSMutableDictionary *mindDictionary;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小⑦";
    
    self.mindDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(today)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectDateFromWheel)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.selectDate = [self.dateFormatter stringFromDate:[NSDate date]];
    
    self.minimumDate = [self.dateFormatter dateFromString:@"1994-10-03"];
    self.maximumDate = [self.dateFormatter dateFromString:@"2093-10-03"];
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
    
    [self.view addSubview:self.backImageView];
    
    [self.view addSubview:self.fscalendar];
    
    [self.view addSubview:self.bottomView];
    
    [self loadCalendarEvents];
    
    [self getMyMind];
    
//    NSLog(@"-=-=-=-=-=-==%f", FSCalendarVersionNumber);
    
}

#pragma mark - Private methods

- (void)loadCalendarEvents
{
    __weak typeof(self) weakSelf = self;
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(granted) {
            NSDate *startDate = self.minimumDate;
            NSDate *endDate = self.maximumDate;
            NSInteger year = [self.fscalendar yearOfDate:[NSDate date]];
            startDate = [self.fscalendar dateWithYear:year-1 month:1 day:1];
            endDate = [self.fscalendar dateWithYear:year+2 month:12 day:31];
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf) return;
                weakSelf.events = events;
                [weakSelf.fscalendar reloadData];
            });
            
        } else {
            
            // Alert
            UIAlertController *alertController = [[UIAlertController alloc] init];
            alertController.title = @"Error";
            alertController.message = @"Permission of calendar is required for fetching events.";
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            
        }
        
    }];
    
}

- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self.cache objectForKey:date];
    if ([events isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    if (filteredEvents.count) {
        [self.cache setObject:filteredEvents forKey:date];
    } else {
        [self.cache setObject:[NSNull null] forKey:date];
    }
    return filteredEvents;
}

- (void)today
{
    [self.fscalendar selectDate:[NSDate date] scrollToDate:YES];
}

- (void)selectDateFromWheel
{
    [self.view addSubview:self.jumpDateView];
}

- (void)addEvent
{
    //    RootViewController *VC = [[RootViewController alloc] init];
    //    AddEvevtVC *VC = [[AddEvevtVC alloc] init];
    //    [self.navigationController pushViewController:VC animated:YES];
    
    [BHBPopView showToView:[[UIApplication sharedApplication].delegate window] andImages:@[@"/biaoqing/addEvevt", @"/biaoqing/smiley_002", @"/biaoqing/smiley_003", @"/biaoqing/smiley_011", @"/biaoqing/smiley_010", @"/biaoqing/smiley_015", @"/biaoqing/smiley_014", @"/biaoqing/smiley_006"] andTitles:@[ @"日记", @"不开心", @"难受", @"开心", @"喜欢", @"感动", @"伤心", @"委屈"] andSelectBlock:^(BHBItem *item) {
        
        if ([item.title isEqualToString:@"日记"]) {
            AddEvevtVC *VC = [[AddEvevtVC alloc] init];
            VC.date = self.selectDate;
            
            
            
            [self.navigationController pushViewController:VC animated:YES];
        }else
        {
            [self.mindDictionary addEntriesFromDictionary:@{self.selectDate:[NSString stringWithFormat:@"biaoqing/%@", item.title]}];
            //            if ([item.title isEqualToString:@"开心"])
            //            {
            //                [self.mindDictionary addEntriesFromDictionary:@{self.selectDate:@"biaoqing/smiley_011"}];
            //            }else if ([item.title isEqualToString:@"生气"])
            //            {
            //                [self.mindDictionary addEntriesFromDictionary:@{self.selectDate:@"biaoqing/smiley_002"}];
            //            }else if ([item.title isEqualToString:@"不开心"])
            //            {
            //                [self.mindDictionary addEntriesFromDictionary:@{self.selectDate:@"biaoqing/smiley_003"}];
            //            }else if ([item.title isEqualToString:@"喜欢"])
            //            {
            //                [self.mindDictionary addEntriesFromDictionary:@{self.selectDate:@"biaoqing/smiley_010"}];
            //            }
            [self saveMyMind];
        }
        YHJLog(@"-=-=-==-=-=%@", item.title);
    }];
}

- (void)saveMyMind
{
    //    self.mindDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"2017-02-08":[UIColor purpleColor],
    //                                                                          @"2017-02-06":[UIColor greenColor],
    //                                                                          @"2017-02-18":[UIColor cyanColor],
    //                                                                          @"2017-02-22":[UIColor yellowColor],
    //                                                                         }];
    [self.fscalendar reloadData];
    [DateModel writeDtatWithPathFile:@"mind" data:[DateModel returnDataWithDictionary:self.mindDictionary]];
}

- (void)getMyMind
{
    NSData *data = [DateModel getDataWithPathFile:@"mind"];
    if (data) {
        self.mindDictionary = [NSMutableDictionary dictionaryWithDictionary:[DateModel returnDictionaryWithData:data]];
        [self.fscalendar reloadData];
    }
}

#pragma mark JumpDateViewDelegate
- (void)JumpDateViewSelectDate:(NSDate *)date
{
    [self.fscalendar selectDate:date scrollToDate:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter stringFromDate:date];
    if ([self.mindDictionary.allKeys containsObject:key]) {
        UIImage *image = [UIImage imageNamed:_mindDictionary[key]];
        UIColor *backColor = [UIColor colorWithPatternImage:[DateModel image:image rotation:UIImageOrientationDown]];
        return backColor;
    }
    return nil;
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    EKEvent *event = [self eventsForDate:date].firstObject;
    if (event) {
        return event.title;
    }
    NSInteger day = [self.lunarCalendar component:NSCalendarUnitDay fromDate:date];
    return self.lunarChars[day-1];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select %@",[self.dateFormatter stringFromDate:date]);
    self.selectDate = [self.dateFormatter stringFromDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    return events.count;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:events.count];
    [events enumerateObjectsUsingBlock:^(EKEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colors addObject:[UIColor colorWithCGColor:obj.calendar.CGColor]];
    }];
    return colors.copy;
}

#pragma mark UI
- (JumpDateView *)jumpDateView
{
    if (!_jumpDateView) {
        _jumpDateView = [[JumpDateView alloc] initWithFrame:[UIScreen mainScreen].bounds maxDate:self.maximumDate minDate:self.minimumDate];
        _jumpDateView.delegate = self;
    }
    return _jumpDateView;
}

- (FSCalendar *)fscalendar
{
    if (!_fscalendar) {
        _fscalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREENH_HEIGHT - 64 - 44)];
        _fscalendar.dataSource = self;
        _fscalendar.delegate = self;
        _fscalendar.pagingEnabled = NO; // important
        //        _fscalendar.scrollDirection = FSCalendarScrollDirectionVertical;
        //        _fscalendar.allowsMultipleSelection = YES;
        //        _fscalendar.firstWeekday = 2;
        _fscalendar.scope = FSCalendarScopeMonth;
        
        _fscalendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _fscalendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesUpperCase;
    }
    return _fscalendar;
}

- (NSCalendar *)lunarCalendar
{
    if (!_lunarCalendar) {
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _lunarCalendar;
}

- (AddEventView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[AddEventView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT - 44, SCREEN_WIDTH, 44)];
        [_bottomView.addEventBtn addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (YYAnimatedImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
        [_backImageView setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/mrjlovetian/image/master/002.JPG"] options:YYWebImageOptionShowNetworkActivity];
    }
    return _backImageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
