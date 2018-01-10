//
//  AipCaptureCardVC.m
//  OCRLib
//
//  Created by Yan,Xiangda on 16/11/9.
//  Copyright © 2016年 Baidu Passport. All rights reserved.
//

#import "AipCaptureCardVC.h"
#import "AipCameraController.h"
#import "AipCameraPreviewView.h"
#import "AipCutImageView.h"
#import "AipNavigationController.h"
#import "AipOcrService.h"

#define MyLocal(x, ...) NSLocalizedString(x, nil)

#define V_X(v)      v.frame.origin.x
#define V_Y(v)      v.frame.origin.y
#define V_H(v)      v.frame.size.height
#define V_W(v)      v.frame.size.width

static  NSInteger  const bankCardViewCornerRadius = 14;

@interface AipCaptureCardVC () <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AipCutImageDelegate>

@property (weak, nonatomic) IBOutlet UIView *bankCardView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;
@property (weak, nonatomic) IBOutlet UIButton *checkCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *transformButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewBoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkViewBoom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLabelCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLabelCenterY;
@property (weak, nonatomic) IBOutlet UIImageView *emblemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet AipCutImageView *cutImageView;
@property (weak, nonatomic) IBOutlet AipCameraPreviewView *previewView;
@property (strong, nonatomic) AipCameraController *cameraController;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) UIDeviceOrientation curDeviceOrientation;
@property (assign, nonatomic) UIDeviceOrientation imageDeviceOrientation;
@property (assign, nonatomic) UIImageOrientation imageOrientation;
@property (assign, nonatomic) CGSize size;

@end

@implementation AipCaptureCardVC

#pragma mark - Lifecycle

- (void)dealloc{
    
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraController = [[AipCameraController alloc] initWithCameraPosition:AVCaptureDevicePositionBack];
    
    [self setupViews];
    
    [self setupWithCardType];
    
    self.shapeLayer = [CAShapeLayer layer];
    [self.backgroundView.layer addSublayer:self.shapeLayer];
    
    self.cutImageView.imgDelegate = self;
    //卡片类的图片，可以适当降低图片质量，提高识别速度。
    self.cutImageView.scale = 1.2;
    
    self.imageDeviceOrientation = UIDeviceOrientationPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setupShapeLayer];
    
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
    self.checkViewBoom.constant = -V_H(self.checkView);
    self.toolViewBoom.constant = 0;
    [self shapeLayerChangeLight];
    [self setupWithCardType]; 
    //关灯
    [self OffLight];
}

- (void)setupViews {
    
    self.navigationController.navigationBarHidden = YES;
    
    self.previewView.translatesAutoresizingMaskIntoConstraints = NO;
    self.previewView.session = self.cameraController.session;
    
    self.bankCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bankCardView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bankCardView.layer.borderWidth = 1.0;
    self.bankCardView.layer.cornerRadius = bankCardViewCornerRadius *[self.class speScale];
}

- (void)setupWithCardType{
    
    switch (self.cardType) {

        case CardTypeIdCardFont:
        {
            self.peopleImageView.hidden = NO;
            self.emblemImageView.hidden = YES;
            self.tipsLabel.text = MyLocal(@"对齐身份证正面");
        }
            break;
        case CardTypeIdCardBack:
        {
            self.peopleImageView.hidden = YES;
            self.emblemImageView.hidden = NO;
            self.tipsLabel.text = MyLocal(@"对齐身份证背面");
        }
            break;
        case CardTypeBankCard:
        {
            self.peopleImageView.hidden = YES;
            self.emblemImageView.hidden = YES;
            self.tipsLabel.text = MyLocal(@"对齐银行卡正面");
        }
            break;
        default:
            break;
    }
}

- (void)setupShapeLayer{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:self.bankCardView.frame cornerRadius:bankCardViewCornerRadius *[self.class speScale]] bezierPathByReversingPath]];
    [self shapeLayerChangeLight];
    self.shapeLayer.path = path.CGPath;
}

- (void)setupCutImageView:(UIImage *)image fromPhotoLib:(BOOL)isFromLib {
    
    if (isFromLib) {
        
        self.cutImageView.userInteractionEnabled = YES;
        self.transformButton.hidden = NO;
        [self.cutImageView setBGImage:image fromPhotoLib:isFromLib useGestureRecognizer:YES];
    }else{
        
        self.cutImageView.userInteractionEnabled = NO;
        self.transformButton.hidden = YES;
        [self.cutImageView setBGImage:image fromPhotoLib:isFromLib useGestureRecognizer:NO];
    }
    //关灯
    [self OffLight];
    self.previewView.hidden = YES;
    self.closeButton.hidden = YES;
    self.cutImageView.hidden = NO;
    self.checkViewBoom.constant = 0;
    self.toolViewBoom.constant = -V_H(self.toolsView);
    [self shapeLayerChangeDark];
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
    
    CGRect customerRect = CGRectMake(0, rect.origin.y - 10, [UIScreen mainScreen].bounds.size.width, rect.size.height + 20);
    
    UIImage *cutImage = [self.cutImageView cutImageFromView:self.cutImageView.bgImageView withSize:self.size atFrame:customerRect];
    
    UIImage *image = [self rotateImageEx:cutImage.CGImage byDeviceOrientation:self.imageDeviceOrientation];
    
    UIImage *finalImage = [self rotateImageEx:image.CGImage orientation:self.imageOrientation];
    
    switch (self.cardType) {
        case CardTypeIdCardFont:{
            [[AipOcrService shardService] detectIdCardFrontFromImage:finalImage withOptions:nil successHandler:^(id result) {
                if ([self.delegate respondsToSelector:@selector(ocrOnIdCardSuccessful:image:)]) {
                    [self.delegate ocrOnIdCardSuccessful:result image:finalImage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self dismissViewControllerAnimated:YES completion:nil];
                    });
                   
                }
            } failHandler:^(NSError *err) {
                if ([self.delegate respondsToSelector:@selector(ocrOnFail:)]) {
                    [self.delegate ocrOnFail:err];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
            break;
        }
            
        case CardTypeIdCardBack:
        {
            
//            if ([self.delegate respondsToSelector:@selector(ocrOnIdCardSuccessful:image:)]) {
//                [self.delegate ocrOnIdCardSuccessful:nil image:finalImage];
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
            [[AipOcrService shardService] detectIdCardBackFromImage:finalImage withOptions:nil successHandler:^(id result) {
                if ([self.delegate respondsToSelector:@selector(ocrOnIdCardSuccessful:image:)]) {
                    [self.delegate ocrOnIdCardSuccessful:result image:finalImage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            } failHandler:^(NSError *err) {
                if ([self.delegate respondsToSelector:@selector(ocrOnFail:)]) {
                    [self.delegate ocrOnFail:err];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
        }
            break;
        case CardTypeBankCard: {
            
            [[AipOcrService shardService] detectBankCardFromImage:finalImage successHandler:^(id result) {
//                NSLog(@"%@", result);
//                [self showBankCardResultWithInfo:result[@"result"]];
                if ([self.delegate respondsToSelector:@selector(ocrOnBankCardSuccessful:image:)]) {
                    [self.delegate ocrOnBankCardSuccessful:result image:finalImage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            } failHandler:^(NSError *err) {
//                NSLog(@"%@", err);
                if ([self.delegate respondsToSelector:@selector(ocrOnFail:)]) {
                    [self.delegate ocrOnFail:err];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
        }
            break;
            
            
        default:
            break;
    }
    

}


- (IBAction)pressCheckBack:(id)sender {
    
    [self reset];
}


- (IBAction)captureIDCard:(id)sender {
    
    __weak __typeof (self) weakSelf = self;
    [self.cameraController captureStillImageWithHandler:^(NSData *imageData) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        [weakSelf setupCutImageView:image fromPhotoLib:NO];
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

    if(self.curDeviceOrientation == UIDeviceOrientationLandscapeLeft){
        
        transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.tipsLabelCenterX.constant = -140*[self.class speScale];
        self.tipsLabelCenterY.constant = -80*[self.class speScale];
        self.imageDeviceOrientation = UIDeviceOrientationLandscapeLeft;
    }else {
        
        transform = CGAffineTransformMakeRotation(0);
        
        self.tipsLabelCenterX.constant = 0;
        self.tipsLabelCenterY.constant = 100*[self.class speScale];
        self.imageDeviceOrientation = UIDeviceOrientationPortrait;
    }
    
    self.tipsLabel.transform = transform;
    self.bankCardView.transform = transform;
    
    //重置shapeLayer
    [self setupShapeLayer];
    
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
    
    return ([UIScreen mainScreen].bounds.size.width == 414) ? 1.1: ([UIScreen mainScreen].bounds.size.width == 320) ? 0.85 : 1;
}

+(UIViewController *)ViewControllerWithCardType:(CardType)type andDelegate:(id<AipOcrDelegate>)delegate {
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"AipOcrSdk" bundle:[NSBundle bundleForClass:[self class]]];
    
    AipCaptureCardVC *vc = [mainSB instantiateViewControllerWithIdentifier:@"AipCaptureCardVC"];
    
    vc.cardType = type;
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
    
    CGFloat bankCardViewX = V_X(self.bankCardView);
    CGFloat bankCardViewY = V_Y(self.bankCardView);
    CGFloat bankCardViewW = V_W(self.bankCardView);
    CGFloat bankCardViewH = V_H(self.bankCardView);
    
    CGFloat bgImageViewX  = V_X(self.cutImageView.bgImageView);
    CGFloat bgImageViewY  = V_Y(self.cutImageView.bgImageView);
    CGFloat bgImageViewW  = V_W(self.cutImageView.bgImageView);
    CGFloat bgImageViewH  = V_H(self.cutImageView.bgImageView);
    
    if (self.imageOrientation == UIImageOrientationUp) {
        
        
        if (bankCardViewX< bgImageViewX) {
            
            x = 0;
            width = bankCardViewW - (bgImageViewX - bankCardViewX);
        }else{
            
            x = bankCardViewX-bgImageViewX;
            width = bankCardViewW;
        }
        
        if (bankCardViewY< bgImageViewY) {
            
            y = 0;
            height = bankCardViewH - (bgImageViewY - bankCardViewY);
        }else{
            
            y = bankCardViewY-bgImageViewY;
            height = bankCardViewH;
        }
        
        self.size = CGSizeMake(bgImageViewW, bgImageViewH);
    }else if (self.imageOrientation == UIImageOrientationRight){
        
        if (bankCardViewY<bgImageViewY) {
            
            x = 0;
            width = bankCardViewH - (bgImageViewY - bankCardViewY);
        }else{
            
            x = bankCardViewY - bgImageViewY;
            width = bankCardViewH;
        }
        
        CGFloat newCardViewX = bankCardViewX + bankCardViewW;
        CGFloat newBgImageViewX = bgImageViewX + bgImageViewW;
        
        if (newCardViewX>newBgImageViewX) {
            y = 0;
            height = bankCardViewW - (newCardViewX - newBgImageViewX);
        }else{
            
            y = newBgImageViewX - newCardViewX;
            height = bankCardViewW;
        }
        
        self.size = CGSizeMake(bgImageViewH, bgImageViewW);
    }else if (self.imageOrientation == UIImageOrientationLeft){
        
        if (bankCardViewX < bgImageViewX) {
            
            y = 0;
            height = bankCardViewW - (bgImageViewX - bankCardViewX);
        }else{
            
            y = bankCardViewX-bgImageViewX;
            height = bankCardViewW;
        }
        
        CGFloat newCardViewY = bankCardViewY + bankCardViewH;
        CGFloat newBgImageViewY = bgImageViewY + bgImageViewH;
        
        if (newCardViewY< newBgImageViewY) {
            
            x = newBgImageViewY - newCardViewY;
            width = bankCardViewH;
        }else{
            
            x = 0;
            width = bankCardViewH - (newCardViewY - newBgImageViewY);
        }
        
        self.size = CGSizeMake(bgImageViewH, bgImageViewW);
    }else{
        
        CGFloat newCardViewX = bankCardViewX + bankCardViewW;
        CGFloat newBgImageViewX = bgImageViewX + bgImageViewW;
        
        CGFloat newCardViewY = bankCardViewY + bankCardViewH;
        CGFloat newBgImageViewY = bgImageViewY + bgImageViewH;
        
        if (newCardViewX < newBgImageViewX) {
            
            x = newBgImageViewX - newCardViewX;
            width = bankCardViewW;
        }else{
            
            x = 0;
            width = bankCardViewW - (newCardViewX - newBgImageViewX);
        }
        
        if (newCardViewY < newBgImageViewY) {
            
            y = newBgImageViewY - newCardViewY;
            height = bankCardViewH;
            
        }else{
            
            y = 0;
            height = bankCardViewH - (newCardViewY - newBgImageViewY);
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

- (void)shapeLayerChangeLight{
    
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
}

- (void)shapeLayerChangeDark{
    
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
}


#pragma mark - dataSource && delegate

//AipCutImageDelegate

- (void)AipCutImageBeginPaint{
    
}
- (void)AipCutImageScale{
    
    [self shapeLayerChangeLight];
}
- (void)AipCutImageMove{
    
    [self shapeLayerChangeLight];
}
- (void)AipCutImageEndPaint{
    
    [self shapeLayerChangeDark];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
