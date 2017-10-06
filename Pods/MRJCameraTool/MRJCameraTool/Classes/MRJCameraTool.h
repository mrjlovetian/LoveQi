//
//  MRJCameraTool.h
//  Pods
//
//  Created by Mr on 2017/9/18.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CameraToolDefault = 0, // 系统相册
    CameraToolCustomize,   // 自定义
} CameraToolType;

typedef void (^CompleteChooseCallback)(UIImage *image);
typedef void (^PhotosCompleteChooseCallback)(NSArray *images);

@interface MRJCameraTool : UIView
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;///
@property (nonatomic, assign) BOOL isEdit;///编辑设置
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CameraToolType type;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, copy) CompleteChooseCallback completeChooseCallback;
@property (nonatomic, copy) PhotosCompleteChooseCallback photosCompleteChooseCallback;

- (void)showActionSheet;

+ (void)cameraDisableAlert;

/*系统相机封装
 *@param myVc
 *@param isEdit 是否编辑
 *@param success 返回image对象
 */
+ (void)cameraAtView:(UIViewController *)curreVC isEdit:(BOOL)isEdit success:(CompleteChooseCallback)success;

/*自定义选择图片封装
 *@param myVc
 *@param width 图片分辨率宽度，px
 *@param maxNum 最多可以选择多少张
 *@param success 返回image数组对象
 */
+ (void)cameraAtView:(UIViewController *)curreVC imageWidth:(CGFloat)width maxNum:(NSInteger)maxNum success:(PhotosCompleteChooseCallback)success;

/*自定义选择图片封装
 *@param myVc
 *@param type 默认从相册和相机获取
 *@param width 图片分辨率宽度，px
 *@param maxNum 最多可以选择多少张
 *@param success 返回image数组对象
 */
+ (void)cameraAtView:(UIViewController *)curreVC sourceType:(UIImagePickerControllerSourceType)type imageWidth:(CGFloat)width maxNum:(NSInteger)maxNum success:(PhotosCompleteChooseCallback)success;

@end
