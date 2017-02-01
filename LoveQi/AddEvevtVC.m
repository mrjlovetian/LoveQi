//
//  AddEvevtVC.m
//  LoveQi
//
//  Created by MRJ on 2017/1/29.
//  Copyright © 2017年 李琦. All rights reserved.
//

#import "AddEvevtVC.h"
#import <UIImageView+YYWebImage.h>
#import <YYAnimatedImageView.h>
#import <YYKit.h>
#import "DateModel.h"

@interface AddEvevtVC ()<YYTextKeyboardObserver>
@property (nonatomic, strong)YYAnimatedImageView *backImageView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)YYTextView *textView;
@end

@implementation AddEvevtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日记";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(wirteDta)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self getData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.backImageView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textView];
    // Do any additional setup after loading the view.
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.height = SCREENH_HEIGHT - Navight;
    }
}


#pragma mark UI

- (YYAnimatedImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
        [_backImageView setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/mrjlovetian/image/master/005.JPG"] options:YYWebImageOptionShowNetworkActivity];
    }
    return _backImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Navight, SCREEN_WIDTH, SCREENH_HEIGHT - Navight)];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (YYTextView *)textView
{
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-Navight)];
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 私有方法
- (void)wirteDta
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    
//    NSString *imageName = @"cooltext228422199634003.png";
//    
//    UIImage *image = [UIImage imageNamed:imageName];//通过文件名加载图片，有缓存
//    
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil]; //附件
//    
//    attachment.image = image;
//    
//    
//    NSAttributedString *textattach = [NSAttributedString attributedStringWithAttachment:attachment];//附件转化为 NSAttributedString
    
    
//    NSRange range = self.textView.selectedRange;    //点击的位置，插入点
//    
//    NSInteger i = 0;
//    
//    i = range.location;
    
//    [content insertAttributedString:textattach atIndex:10];   //将图片插入
//    self.textView.attributedText = content;
    NSData *data = [content dataFromRange:NSMakeRange(0, content.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];   //将 NSAttributedString 转为NSData
    
    BOOL isSuccess = [DateModel writeDtatWithPathFile:self.date data:data];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (isSuccess) {
       
        hud.labelText = @"保存成功";
        
    }else
    {
        hud.labelText = @"保存失败";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)getData
{
    NSData *data = [DateModel getDataWithPathFile:self.date];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:nil];
    self.textView.attributedText = str;
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
