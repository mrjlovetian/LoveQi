//
//  MRJCameraTool.m
//  Pods
//
//  Created by Mr on 2017/9/18.
//
//

#import "MRJCameraTool.h"
#import "TZImagePickerController.h"
#import "SKFCamera.h"
#import "MRJActionSheet.h"
#import "UIColor+Additions.h"

@interface MRJCameraTool ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate, MRJActionSheetDelegate>
@property (nonatomic, strong)NSMutableArray *selectImage;
@end

@implementation MRJCameraTool

///占用一个像素的主屏幕位置
/// 确保委托方法的顺利执行
+ (id)cameraToolDefault{
    MRJCameraTool *camTool = [[MRJCameraTool alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    camTool.backgroundColor = [UIColor clearColor];
    camTool.width = 640.0;
    camTool.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return camTool;
}

+ (void)cameraAtView:(UIViewController *)curreVC isEdit:(BOOL)isEdit success:(CompleteChooseCallback)success{
    MRJCameraTool *camTool = [self cameraToolDefault];
    camTool.isEdit = isEdit;
    camTool.vc = curreVC;
    camTool.type = CameraToolDefault;
    [camTool showActionSheet];
    [curreVC.view addSubview:camTool];
    
    __weak MRJCameraTool *cam = camTool;
    camTool.completeChooseCallback = ^(UIImage *image){
        [cam removeFromSuperview];
        if (image) {
            if (success) {
                success(image);
            }
        }
    };
}

+ (void)cameraAtView:(UIViewController *)curreVC imageWidth:(CGFloat)width maxNum:(NSInteger)maxNum success:(PhotosCompleteChooseCallback)success{
    [self cameraAtView:curreVC sourceType:UIImagePickerControllerSourceTypePhotoLibrary imageWidth:width maxNum:maxNum success:success];
}

+ (void)cameraAtView:(UIViewController *)curreVC sourceType:(UIImagePickerControllerSourceType)type imageWidth:(CGFloat)width maxNum:(NSInteger)maxNum success:(PhotosCompleteChooseCallback)success {
    if (maxNum <= 0) {
        return;
    }
    MRJCameraTool *camTool = [self cameraToolDefault];
    camTool.vc = curreVC;
    camTool.type = CameraToolCustomize;
    camTool.maxNum = maxNum;
    camTool.width = width;
    [curreVC.view addSubview:camTool];
    
    switch (type) {
        case UIImagePickerControllerSourceTypePhotoLibrary:
            [camTool showActionSheet];
            break;
        case UIImagePickerControllerSourceTypeCamera:
            [camTool goCamera];
            break;
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
            [camTool goPhotosPicker];
            break;
        default:
            break;
    }
    
    __weak MRJCameraTool *cam = camTool;
    camTool.photosCompleteChooseCallback = ^(NSArray *images){
        if (images) {
            if (success) {
                success(images);
            }
        }
        [cam removeFromSuperview];
    };
}

+ (void)cameraDisableAlert{
    UIAlertView *atView = [[UIAlertView alloc]initWithTitle:@"不能打开相机" message:@"设置 - > 隐私 - > 相机" delegate:nil cancelButtonTitle:@"去设置" otherButtonTitles:nil, nil];
    [atView show];
}

- (void)showActionSheet{
    MRJActionSheet *choiceSheet = [[MRJActionSheet alloc] initWithTitle:nil buttonTitles:@[@"拍照", @"相册"] redButtonIndex:-1 defColor:nil delegate:self];
    [choiceSheet show];
}

#pragma mark MRJActionSheetDelegate

- (void)actionSheet:(MRJActionSheet *)actionSheet didClickedButtonAtIndex:(int)buttonIndex {
    
    if (buttonIndex == 2) return;
    
    if (self.type == CameraToolDefault) {
        
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        if([UIImagePickerController isSourceTypeAvailable:type]){
            if( buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                type = UIImagePickerControllerSourceTypeCamera;
            }
            if (type==UIImagePickerControllerSourceTypeCamera) {
                SKFCamera *homec=[[SKFCamera alloc]init];
                __weak typeof(self)myself=self;
                homec.fininshcapture=^(UIImage *ss){
                    if (ss) {
                        UIImage *newImage = [myself imageWithImage:ss];
                        if (myself.type == CameraToolDefault) {
                            if (myself.completeChooseCallback) {
                                myself.completeChooseCallback(newImage);
                            }
                        }
                        else if (myself.type == CameraToolCustomize) {
                            if (myself.photosCompleteChooseCallback) {
                                myself.photosCompleteChooseCallback(@[newImage]);
                            }
                        }
                    }
                } ;
                [self.vc presentViewController:homec animated:NO completion:^{}];
            }else{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = self.isEdit;
                picker.delegate = self;
                picker.sourceType = type;
                [self.vc presentViewController:picker animated:YES completion:nil];
            }
        }
    }
    else if (self.type == CameraToolCustomize) {
        if (buttonIndex == 0) {
            [self goCamera];
            
        } else  if (buttonIndex == 1) {
            [self goPhotosPicker];
        }
    }
}

/// 跳相机
- (void)goCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.vc presentViewController:picker animated:YES completion:nil];
    } else {
        [MRJCameraTool cameraDisableAlert];
    }
}

/// 跳相册
- (void)goPhotosPicker {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxNum delegate:self];
    imagePickerVc.photoWidth=self.width;
    imagePickerVc.barItemTextColor = [UIColor colorWithHexString:@"0091e8"];
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleColor = [UIColor colorWithHexString:@"333333"];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.oKButtonTitleColorNormal = [UIColor colorWithHexString:@"0091e8"];
    [self.vc presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - KKAssetPickerController Delegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.photosCompleteChooseCallback(photos);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset{
    self.photosCompleteChooseCallback(@[animatedImage]);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [info objectForKey:_isEdit?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    if (image) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *newImage = [self imageWithImage:image];
            if (self.type == CameraToolDefault) {
                if (self.completeChooseCallback) {
                    self.completeChooseCallback(newImage);
                }
            }
            else if (self.type == CameraToolCustomize) {
                if (self.photosCompleteChooseCallback) {
                    self.photosCompleteChooseCallback(@[newImage]);
                }
            }
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (UIImage*)imageWithImage:(UIImage*)image {
    float Proportion = image.size.width/image.size.height;
    CGSize newSize = CGSizeMake(self.width, self.width/Proportion);
    
    if (image.size.width > self.width) {
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        image  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

@end
