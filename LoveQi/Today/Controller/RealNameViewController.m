//
//  RealNameViewController.m
//  LoveQi
//
//  Created by Mr on 2018/1/8.
//  Copyright © 2018年 李琦. All rights reserved.
//

#import "RealNameViewController.h"
#import "RealNameProgressView.h"
#import "AddIDCardView.h"
//#import "RealName2ViewController.h"
#import "CreditScoreCardView.h"
//#import <objc/runtime.h>
#import "AipOcrSdk.h"
#import "UIImageView+YYWebImage.h"
//#import "NSString+url.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "BottomBtnView.h"
//#import "RealName3ViewController.h"

@interface RealNameViewController ()<AipOcrDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong)RealNameProgressView *progressView;
@property (nonatomic, strong)AddIDCardView *addIDCardView;
@property (nonatomic, strong)UIScrollView *backView;
@property (nonatomic, strong)MWPhoto *photo;
@property (nonatomic, strong)BottomBtnView *bottomBtnView;
@property (nonatomic, assign)BOOL isShowImage;

@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AipOcrService shardService] authWithAK:@"pDGty8qu5cFns17h4ve6r74n" andSK:@"rmcLrmWMHFrAxZ61W57WGnCL4rY57ChV"];
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.progressView];
    
    self.progressView.realNamePosition = self.index;
    
    self.addIDCardView.realNamePosition = self.index;
    
    if (self.index == 2) {
//        [self.backView addSubview:self.faceView];
//        [self getAlipayUrlRealName];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNetUrl:)  name:@"alipayNotice" object:nil];
    } else {
        [self.backView addSubview:self.addIDCardView];
        [self.view addSubview:self.bottomBtnView];
    }
    
    __weak typeof(self) weakSelf = self;
    self.addIDCardView.selectImageBlock = ^{
        if (self.index == 0) {
            [weakSelf uplodIdImage];
        }else if (self.index == 1){
            [weakSelf uplodIdBackImage];
        }
        //        else if (self.index == 2){
        //            [weakSelf uplodCardImage];
        //        }
    };
    
    self.addIDCardView.blowPictureBlock = ^{
//        [weakSelf lookPhoto];
    };
    
    
    self.backView.contentSize = CGSizeMake(SCREEN_WIDTH, _addIDCardView.bottom + 15);
//    [self loadIdinfo];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

#pragma mark Method
/// 身份照
- (void)uplodIdImage {
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

/// 身份证背面照
- (void)uplodIdBackImage {
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickNext {
    if (self.index < 2) {
//        if (self.index == 0) {
//            if (MF_isStringNull(((IDInfo *)[IDInfo shareIDInfo]).idcardPosPicUrl) || !_isShowImage) {
//                [self showTips:@"broker_Please upload your ID card to the front".local_broker];
//                return;
//            }
//        } else if (self.index == 1 ) {
//            if (MF_isStringNull(((IDInfo *)[IDInfo shareIDInfo]).idcardNegPicUrl) || !_isShowImage) {
//                [self showTips:@"broker_Please upload your ID card on the back".local_broker];
//                return;
//            }
//        }
//
//        if (self.index == 1) {
//            if ([[((IDInfo *)[IDInfo shareIDInfo]).idcardNumber substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"**"]) {
//                [self showTips:@"证件识别中，请稍等！"];
//                return;
//            }
//        }
        RealNameViewController *vc = [[RealNameViewController alloc] init];
        vc.index = self.index + 1;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
//        if (self.index == 2) {
//            if (MF_isStringNull(((IDInfo *)[IDInfo shareIDInfo]).personWithIdcardPicUrl) || !_isShowImage) {
//                [self showTips:@"broker_Please upload your ID card".local_broker];
//                return;
//            }
//        }
//        RealName2ViewController *vc = [[RealName2ViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)lookPhoto {
    _photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.addIDCardView.idImageUrl]];
    if (self.addIDCardView.idImage != nil) {
        _photo = [MWPhoto photoWithImage:self.addIDCardView.idImage];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    if (self.index == 0) {
        browser.title = @"正面身份证照";
    } else if (self.index == 1) {
        browser.title = @"反面身份证照";
    }else if (self.index == 2){
        browser.title = @"手持身份证照";
    }
    
//    if (self.addIDCardView.idImage == nil && MF_isStringNull(self.addIDCardView.idImageUrl)) {
//        return;
//    }
    
    browser.displayActionButton = YES;
    [browser setCurrentPhotoIndex:0];
//    browser.isCustomeShareButton = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

- (BOOL)verifIDCardImage {
//    if ([NSString dealStringNotNull:((IDInfo *)[IDInfo shareIDInfo]).realName].length == 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MF_ShowTips(@"照片无法识别，请重新上传身份证照片");
//        });
//        return NO;
//    }
//    if ([NSString dealStringNotNull:((IDInfo *)[IDInfo shareIDInfo]).idcardNumber].length == 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MF_ShowTips(@"照片无法识别，请重新上传身份证照片");
//        });
//        return NO;
//    }
    return YES;
}

#pragma mark MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return _photo;
}

#pragma mark AipOcrDelegate
- (void)ocrOnIdCardSuccessful:(id)result image:(UIImage*)image {
    
    NSDictionary *infoDic = result[@"words_result"];
    if ([[infoDic objectForKey:@"公民身份号码"] objectForKey:@"words"]) {
//        ((IDInfo *)[IDInfo shareIDInfo]).realName = [[infoDic objectForKey:@"姓名"] objectForKey:@"words"];
//        ((IDInfo *)[IDInfo shareIDInfo]).birthday = [[infoDic objectForKey:@"出生"] objectForKey:@"words"];
//        ((IDInfo *)[IDInfo shareIDInfo]).idcardNumber = [[infoDic objectForKey:@"公民身份号码"] objectForKey:@"words"];
        if ([@"男" isEqualToString:[[infoDic objectForKey:@"性别"] objectForKey:@"words"]]) {
//            ((IDInfo *)[IDInfo shareIDInfo]).gender = 1;
        } else if ([@"女" isEqualToString:[[infoDic objectForKey:@"性别"] objectForKey:@"words"]]) {
//            ((IDInfo *)[IDInfo shareIDInfo]).gender = 2;
        } else {
//            ((IDInfo *)[IDInfo shareIDInfo]).gender = 0;
        }
//        ((IDInfo *)[IDInfo shareIDInfo]).address = [[infoDic objectForKey:@"住址"] objectForKey:@"words"];
//        ((IDInfo *)[IDInfo shareIDInfo]).nation =  [[infoDic objectForKey:@"民族"] objectForKey:@"words"];
        
        _addIDCardView.idImage = image;
        
        if ([self verifIDCardImage]) {
//            [FileAPIEngine apiPostPrivteImageBroker:self image:image success:^(id res) {
//                ((IDInfo *)[IDInfo shareIDInfo]).idcardPosPicUrl = res;
//                _isShowImage = YES;
//            } failure:^(NSError *err) {
//                [self showTips:err.localizedDescription];
//            }];
        }
        /// if ([[infoDic objectForKey:@"签发机关"] objectForKey:@"words"])
    } else {
//        ((IDInfo *)[IDInfo shareIDInfo]).sign = [[infoDic objectForKey:@"签发机关"] objectForKey:@"words"];
//        ((IDInfo *)[IDInfo shareIDInfo]).cutdownDate = [[infoDic objectForKey:@"签发日期"] objectForKey:@"words"];
        _addIDCardView.idImage = image;
//        [FileAPIEngine apiPostPrivteImageBroker:self image:image success:^(id res) {
//            ((IDInfo *)[IDInfo shareIDInfo]).idcardNegPicUrl = res;
//            _isShowImage = YES;
//        } failure:^(NSError *err) {
//            [self showTips:err.localizedDescription];
//        }];
    }
}

- (void)ocrOnFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self closeWaiter];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showTips:@"broker_The ID card cannot be recognized. Please upload it again".local_broker];
    });
}

#pragma mark UI
- (RealNameProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[RealNameProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    }
    return _progressView;
}

- (AddIDCardView *)addIDCardView {
    if (!_addIDCardView) {
        _addIDCardView = [[AddIDCardView alloc] initWithFrame:CGRectMake(0, _progressView.bottom + 20, SCREEN_WIDTH, 0)];
    }
    return _addIDCardView;
}

- (UIScrollView *)backView {
    if (!_backView) {
        _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavBAR_HEIGHT - 45)];
    }
    return _backView;
}

- (BottomBtnView *)bottomBtnView {
    if (!_bottomBtnView) {
        _bottomBtnView = [[BottomBtnView alloc] initWithBottomBtnClick:^(NSString *title) {
            [self clickNext];
        }];
    }
    return _bottomBtnView;
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
