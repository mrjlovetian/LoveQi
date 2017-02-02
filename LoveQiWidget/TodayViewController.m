//
//  TodayViewController.m
//  LoveQiWidget
//
//  Created by MRJ on 2017/2/1.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "Header.h"

@interface TodayViewController () <NCWidgetProviding>
//@property (nonatomic, strong)FSCalendar *fscalendar;
@property (nonatomic, strong)UIImageView *imagView;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    [self.view addSubview:self.imagView];
//    [self.view addSubview:self.fscalendar];
    
#ifdef __IPHONE_10_0
    //如果需要折叠
//    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
    
    // Do any additional setup after loading the view from its nib.
}

#ifdef __IPHONE_10_0

// available NS_AVAILABLE_IOS(10_0)
//- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
//{
//    switch (activeDisplayMode)
//    {
//            //如果是正常折叠的高度
//        case NCWidgetDisplayModeCompact:
//        {
//            //设置当前的高度
//            self.preferredContentSize = CGSizeMake(0, 200);//宽度会自动变为屏幕的宽度，这里就索性给0了
//        }
//            break;
//            
//            //如果是展开的高度
//        case NCWidgetDisplayModeExpanded:
//        {
//            self.preferredContentSize = CGSizeMake(0, 800);
//        }
//            break;
//    }
//}

#else

// 表示当前widget的内嵌边距，如果不设置，那么返回的就是默认的defaultMarginInsets，不过在iOS10以及以后就不会再调用该方法了
// Widgets wishing to customize the default margin insets can return their preferred values.
// Widgets that choose not to implement this method will receive the default margin insets.
// This method will not be called on widgets linked against iOS versions 10.0 and later.
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 20, 0, 0);//随便写一下
}

#endif



//- (FSCalendar *)fscalendar
//{
//    if (!_fscalendar) {
//        _fscalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREENH_HEIGHT - 64 - 44)];
//        _fscalendar.dataSource = self;
//        _fscalendar.delegate = self;
//        _fscalendar.pagingEnabled = NO; // important
//        //        _fscalendar.scrollDirection = FSCalendarScrollDirectionVertical;
//        //        _fscalendar.allowsMultipleSelection = YES;
//        //        _fscalendar.firstWeekday = 2;
//        _fscalendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
//        _fscalendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesUpperCase;
//    }
//    return _fscalendar;
//}

- (UIImageView *)imagView
{
    if (!_imagView) {
        _imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        NSString *imageUrl = [NSString stringWithFormat:@"https://raw.githubusercontent.com/mrjlovetian/image/master/widgetImage/iloveyou.png"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        _imagView.contentMode = UIViewContentModeScaleAspectFit;
        _imagView.image = image;
    }
    return _imagView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
//    // Perform any setup necessary in order to update the view.
//    
//    // If an error is encountered, use NCUpdateResultFailed
//    // If there's no update required, use NCUpdateResultNoData
//    // If there's an update, use NCUpdateResultNewData
//
//    completionHandler(NCUpdateResultNewData);
//}

@end
