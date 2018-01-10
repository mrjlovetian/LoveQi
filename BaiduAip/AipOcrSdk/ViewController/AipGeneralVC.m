//
//  AipGeneralVC.m
//  OCRLib
//  通用文字识别ViewController
//  Created by Yan,Xiangda on 2017/2/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "AipGeneralVC.h"
#import "AipCameraController.h"
#import "AipCameraPreviewView.h"
#import "AipCutImageView.h"
#import "AipNavigationController.h"
#import "AipOcrService.h"
#import "AipImageView.h"

#define MyLocal(x, ...) NSLocalizedString(x, nil)

#define V_X(v)      v.frame.origin.x
#define V_Y(v)      v.frame.origin.y
#define V_H(v)      v.frame.size.height
#define V_W(v)      v.frame.size.width

@interface AipGeneralVC () <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AipCutImageDelegate>

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;
@property (weak, nonatomic) IBOutlet UIButton *checkCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *transformButton;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewBoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkViewBoom;
@property (weak, nonatomic) IBOutlet AipCameraPreviewView *previewView;
@property (weak, nonatomic) IBOutlet AipCutImageView *cutImageView;
@property (weak, nonatomic) IBOutlet AipImageView *maskImageView;
@property (strong, nonatomic) AipCameraController *cameraController;
@property (assign, nonatomic) UIDeviceOrientation curDeviceOrientation;
@property (assign, nonatomic) UIDeviceOrientation imageDeviceOrientation;
@property (assign, nonatomic) UIImageOrientation imageOrientation;
@property (assign, nonatomic) CGSize size;

@end

@implementation AipGeneralVC

#pragma mark - Lifecycle

- (void)dealloc{
    
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraController = [[AipCameraController alloc] initWithCameraPosition:AVCaptureDevicePositionBack];
    
    [self setupViews];
    [self setUpMaskImageView];
    //delegate 用做传递手势事件
    self.maskImageView.delegate = self.cutImageView;
    self.cutImageView.imgDelegate = self;
    
    self.imageDeviceOrientation = UIDeviceOrientationPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.cameraController startRunningCamera];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self.cameraController stopRunningCamera];
}


#pragma mark - SetUp

//还原初始值
- (void)reset{
    
    self.imageOrientation = UIImageOrientationUp;
    self.closeButton.hidden = NO;
    self.previewView.hidden = NO;
    self.cutImageView.hidden = YES;
    self.maskImageView.hidden = YES;
    self.checkViewBoom.constant = -V_H(self.checkView);
    self.toolViewBoom.constant = 0;
    //关灯
    [self OffLight];
}

- (void)setupViews {
    
    self.navigationController.navigationBarHidden = YES;
    
    self.previewView.translatesAutoresizingMaskIntoConstraints = NO;
    self.previewView.session = self.cameraController.session;
}

- (void)setUpMaskImageView {
    
    self.maskImageView.showMidLines = YES;
    self.maskImageView.needScaleCrop = YES;
    self.maskImageView.showCrossLines = YES;
    self.maskImageView.cropAreaCornerWidth = 30;
    self.maskImageView.cropAreaCornerHeight = 30;
    self.maskImageView.minSpace = 30;
    self.maskImageView.cropAreaCornerLineColor = [UIColor colorWithWhite:1 alpha:1];
    self.maskImageView.cropAreaBorderLineColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.maskImageView.cropAreaCornerLineWidth = 3;
    self.maskImageView.cropAreaBorderLineWidth = 1;
    self.maskImageView.cropAreaMidLineWidth = 30;
    self.maskImageView.cropAreaMidLineHeight = 1;
    self.maskImageView.cropAreaCrossLineColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.maskImageView.cropAreaCrossLineWidth = 1;
    self.maskImageView.cropAspectRatio = 662/1010.0;
    
}

//设置背景图
- (void)setupCutImageView:(UIImage *)image fromPhotoLib:(BOOL)isFromLib {
    
    if (isFromLib) {
        
        self.cutImageView.userInteractionEnabled = YES;
        self.transformButton.hidden = NO;
    }else{
        
        self.cutImageView.userInteractionEnabled = NO;
        self.transformButton.hidden = YES;
    }
    self.previewView.hidden = YES;
    [self.cutImageView setBGImage:image fromPhotoLib:isFromLib useGestureRecognizer:NO];
    self.cutImageView.hidden = NO;
    self.maskImageView.hidden = NO;
    self.closeButton.hidden = YES;
    self.checkViewBoom.constant = 0;
    self.toolViewBoom.constant = -V_H(self.toolsView);
}

#pragma mark - Action handling

- (IBAction)turnLight:(id)sender {
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(![device isTorchModeSupported:AVCaptureTorchModeOn] || ![device isTorchModeSupported:AVCaptureTorchModeOff]) {
        
        //ytodo [self passport_showTextHUDWithTitle:@"暂不支持照明功能" hiddenAfterDelay:0.2];
        return;
    }
    [self.previewView.session beginConfiguration];
    [device lockForConfiguration:nil];
    if (!self.lightButton.selected) { // 照明状态
        if (device.torchMode == AVCaptureTorchModeOff) {
            // Set torch to on
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        
    }else
    {
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    self.lightButton.selected = !self.lightButton.selected;
    [device unlockForConfiguration];
    [self.previewView.session commitConfiguration];
}

- (IBAction)pressTransform:(id)sender {
    
    //向右转90'
    self.cutImageView.bgImageView.transform = CGAffineTransformRotate (self.cutImageView.bgImageView.transform, M_PI_2);
    if (self.imageOrientation == UIImageOrientationUp) {
        
        self.imageOrientation = UIImageOrientationRight;
    }else if (self.imageOrientation == UIImageOrientationRight){
        
        self.imageOrientation = UIImageOrientationDown;
    }else if (self.imageOrientation == UIImageOrientationDown){
        
        self.imageOrientation = UIImageOrientationLeft;
    }else{
        
        self.imageOrientation = UIImageOrientationUp;
    }
    
}

//上传图片识别结果
- (IBAction)pressCheckChoose:(id)sender {
    
    //ytodo tips: MyLocal(@"识别中...")
    
    CGRect rect  = [self TransformTheRect];
    
    UIImage *cutImage = [self.cutImageView cutImageFromView:self.cutImageView.bgImageView withSize:self.size atFrame:rect];
    
    UIImage *image = [self rotateImageEx:cutImage.CGImage byDeviceOrientation:self.imageDeviceOrientation];
    
    UIImage *finalImage = [self rotateImageEx:image.CGImage orientation:self.imageOrientation];
    
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextFromImage:finalImage withOptions:options successHandler:^(id result) {
        if ([self.delegate respondsToSelector:@selector(ocrOnGeneralSuccessful:image:)]) {
            [self.delegate ocrOnGeneralSuccessful:result image:finalImage];
        }
    } failHandler:^(NSError *err) {
        if ([self.delegate respondsToSelector:@selector(ocrOnFail:)]) {
            [self.delegate ocrOnFail:err];
        }
    }];


    
}


- (IBAction)pressCheckBack:(id)sender {
    
    [self reset];
}


- (IBAction)captureIDCard:(id)sender {
    
    __weak __typeof (self) weakSelf = self;
    [self.cameraController captureStillImageWithHandler:^(NSData *imageData) {
        
        
        [weakSelf setupCutImageView:[UIImage imageWithData:imageData]fromPhotoLib:NO];
    }];
}


- (IBAction)pressBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openPhotoAlbum:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //model 一个 View
        [self presentViewController:picker animated:YES completion:^{
            
            
        }];
    }
    else {
        NSAssert(NO, @" ");
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
#pragma mark - notification

//监测设备方向
- (void)orientationChanged:(NSNotification *)notification{
    
    if (![self deviceOrientationCanChange]) {
        
        return;
    }
    
    CGAffineTransform transform;
    
    if (self.curDeviceOrientation == UIDeviceOrientationPortrait) {
        
        transform = CGAffineTransformMakeRotation(0);

        self.imageDeviceOrientation = UIDeviceOrientationPortrait;
    }else if (self.curDeviceOrientation == UIDeviceOrientationLandscapeLeft){
        
        transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.imageDeviceOrientation = UIDeviceOrientationLandscapeLeft;
    }else if (self.curDeviceOrientation == UIDeviceOrientationLandscapeRight){
        
        transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        self.imageDeviceOrientation = UIDeviceOrientationLandscapeRight;
    }else {
        
        transform = CGAffineTransformMakeRotation(0);
        
        self.imageDeviceOrientation = UIDeviceOrientationPortrait;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.albumButton.transform = transform;
        self.closeButton.transform = transform;
        self.lightButton.transform = transform;
        self.closeButton.transform = transform;
        self.captureButton.transform = transform;
        self.checkCloseBtn.transform = transform;
        self.checkChooseBtn.transform = transform;
        self.transformButton.transform = transform;
    } completion:^(BOOL finished) {
        
        
    }];
    
    
}

#pragma mark - loadData

#pragma mark - public

+(CGFloat)speScale{
    
    return (CGFloat) (([UIScreen mainScreen].bounds.size.width == 414) ? 1.1: ([UIScreen mainScreen].bounds.size.width == 320) ? 0.85 : 1);
}

+(UIViewController *)ViewControllerWithDelegate:(id<AipOcrDelegate>)delegate {
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"AipOcrSdk" bundle:[NSBundle bundleForClass:[self class]]];
    
    AipGeneralVC *vc = [mainSB instantiateViewControllerWithIdentifier:@"AipGeneralVC"];
    vc.delegate = delegate;
    
    AipNavigationController *navController = [[AipNavigationController alloc] initWithRootViewController:vc];
    return navController;
}

#pragma mark - private

- (CGRect)TransformTheRect{
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    CGFloat cropAreaViewX = V_X(self.maskImageView.cropAreaView);
    CGFloat cropAreaViewY = V_Y(self.maskImageView.cropAreaView);
    CGFloat cropAreaViewW = V_W(self.maskImageView.cropAreaView);
    CGFloat cropAreaViewH = V_H(self.maskImageView.cropAreaView);
    
    CGFloat bgImageViewX  = V_X(self.cutImageView.bgImageView);
    CGFloat bgImageViewY  = V_Y(self.cutImageView.bgImageView);
    CGFloat bgImageViewW  = V_W(self.cutImageView.bgImageView);
    CGFloat bgImageViewH  = V_H(self.cutImageView.bgImageView);
    
    if (self.imageOrientation == UIImageOrientationUp) {
        
        
        if (cropAreaViewX< bgImageViewX) {
            
            x = 0;
            width = cropAreaViewW - (bgImageViewX - cropAreaViewX);
        }else{
            
            x = cropAreaViewX-bgImageViewX;
            width = cropAreaViewW;
        }
        
        if (cropAreaViewY< bgImageViewY) {
            
            y = 0;
            height = cropAreaViewH - (bgImageViewY - cropAreaViewY);
        }else{
            
            y = cropAreaViewY-bgImageViewY;
            height = cropAreaViewH;
        }
        
        self.size = CGSizeMake(bgImageViewW, bgImageViewH);
    }else if (self.imageOrientation == UIImageOrientationRight){
        
        if (cropAreaViewY<bgImageViewY) {
            
            x = 0;
            width = cropAreaViewH - (bgImageViewY - cropAreaViewY);
        }else{
            
            x = cropAreaViewY - bgImageViewY;
            width = cropAreaViewH;
        }
        
        CGFloat newCardViewX = cropAreaViewX + cropAreaViewW;
        CGFloat newBgImageViewX = bgImageViewX + bgImageViewW;
        
        if (newCardViewX>newBgImageViewX) {
            y = 0;
            height = cropAreaViewW - (newCardViewX - newBgImageViewX);
        }else{
            
            y = newBgImageViewX - newCardViewX;
            height = cropAreaViewW;
        }
        
        self.size = CGSizeMake(bgImageViewH, bgImageViewW);
    }else if (self.imageOrientation == UIImageOrientationLeft){
        
        if (cropAreaViewX < bgImageViewX) {
            
            y = 0;
            height = cropAreaViewW - (bgImageViewX - cropAreaViewX);
        }else{
            
            y = cropAreaViewX-bgImageViewX;
            height = cropAreaViewW;
        }
        
        CGFloat newCardViewY = cropAreaViewY + cropAreaViewH;
        CGFloat newBgImageViewY = bgImageViewY + bgImageViewH;
        
        if (newCardViewY< newBgImageViewY) {
            
            x = newBgImageViewY - newCardViewY;
            width = cropAreaViewH;
        }else{
            
            x = 0;
            width = cropAreaViewH - (newCardViewY - newBgImageViewY);
        }
        
        self.size = CGSizeMake(bgImageViewH, bgImageViewW);
    }else{
        
        CGFloat newCardViewX = cropAreaViewX + cropAreaViewW;
        CGFloat newBgImageViewX = bgImageViewX + bgImageViewW;
        
        CGFloat newCardViewY = cropAreaViewY + cropAreaViewH;
        CGFloat newBgImageViewY = bgImageViewY + bgImageViewH;
        
        if (newCardViewX < newBgImageViewX) {
            
            x = newBgImageViewX - newCardViewX;
            width = cropAreaViewW;
        }else{
            
            x = 0;
            width = cropAreaViewW - (newCardViewX - newBgImageViewX);
        }
        
        if (newCardViewY < newBgImageViewY) {
            
            y = newBgImageViewY - newCardViewY;
            height = cropAreaViewH;
            
        }else{
            
            y = 0;
            height = cropAreaViewH - (newCardViewY - newBgImageViewY);
        }
        
        self.size = CGSizeMake(bgImageViewW, bgImageViewH);
    }
    
    return CGRectMake(x, y, width, height);
}

- (void)OffLight {
    if (self.lightButton.selected) {
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self.previewView.session beginConfiguration];
        [device lockForConfiguration:nil];
        if([device isTorchModeSupported:AVCaptureTorchModeOff]) {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
        [self.previewView.session commitConfiguration];
    }
    
    self.lightButton.selected = NO;
}

//旋转照片
-(UIImage *)rotateImageEx:(CGImageRef)imgRef orientation:(UIImageOrientation) orient
{
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1.0;
    
    CGSize imageSize = CGSizeMake(width, height);
    CGFloat boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



- (UIImage *)rotateImageEx:(CGImageRef)imgRef byDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1.0;
    
    CGSize imageSize = CGSizeMake(width, height);
    CGFloat boundHeight;
    UIImageOrientation orient = UIImageOrientationUp;
    switch(deviceOrientation)
    {
        case UIDeviceOrientationUnknown:
            break;
            
        case UIDeviceOrientationPortrait:     // Device oriented vertically, home button on the bottom
            orient = UIImageOrientationUp;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            break;
            
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            orient = UIImageOrientationLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            orient = UIImageOrientationRight;
            break;
            
        case UIDeviceOrientationFaceUp:              // Device oriented flat, face up
            break;
            
        case UIDeviceOrientationFaceDown:            // Device oriented flat, face down
        default:
            break;
    }
    
    
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform,M_PI / 2.0);
            break;
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height),imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


//切换手机方向有很多种，只有在有效的方向上切换，才会在横屏响应函数orientationChanged 中响应
- (BOOL)deviceOrientationCanChange
{
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)
    {
        self.curDeviceOrientation = UIDeviceOrientationPortrait;
        return YES;
    }
    else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft)
    {
        self.curDeviceOrientation = UIDeviceOrientationLandscapeLeft;
        return YES;
    }
    else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        self.curDeviceOrientation = UIDeviceOrientationLandscapeRight;
        return YES;
    }
    return NO;
}



#pragma mark - dataSource && delegate

//AipCutImageDelegate

- (void)AipCutImageBeginPaint{
    
}
- (void)AipCutImageScale{
    
}
- (void)AipCutImageMove{
    
}
- (void)AipCutImageEndPaint{
    
}

//UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSAssert(image, @" ");
    if (image) {
        
        [self setupCutImageView:image fromPhotoLib:YES];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - function

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
