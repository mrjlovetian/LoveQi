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
@property (nonatomic, strong)UIToolbar *mrjToolBar;
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
            _textView.inputAccessoryView = self.mrjToolBar;
            clipped = YES;
        }
    }
    if (!clipped) {
        _textView.height = SCREEN_HEIGHT - Navight;
    }
}

#pragma mark UI

- (YYAnimatedImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://raw.githubusercontent.com/mrjlovetian/image/master/eventBackGround/background00%d.jpg", arc4random()%10]] options:YYWebImageOptionShowNetworkActivity];
    }
    return _backImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Navight, SCREEN_WIDTH, SCREEN_HEIGHT - Navight)];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Navight)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.inputAccessoryView = self.mrjToolBar;
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIToolbar *)mrjToolBar {
    if (_mrjToolBar == nil) {
        _mrjToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _mrjToolBar.tintColor = [UIColor blueColor];
        _mrjToolBar.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *barBut = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyBoard)];
        barBut.tintColor = [UIColor grayColor];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        _mrjToolBar.items = @[spaceItem,barBut];
    }
    return _mrjToolBar;
}

#pragma mark 私有方法

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)wirteDta {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    NSData *data = [content dataFromRange:NSMakeRange(0, content.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];   //将 NSAttributedString 转为NSData
    BOOL isSuccess = [DateModel writeDtatWithPathFile:self.date data:data];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (isSuccess) {
        hud.labelText = @"保存成功";
    } else {
        hud.labelText = @"保存失败";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)getData {
    NSData *data = [DateModel getDataWithPathFile:self.date];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:nil];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, str.length)];
    self.textView.attributedText = str;
}

@end
