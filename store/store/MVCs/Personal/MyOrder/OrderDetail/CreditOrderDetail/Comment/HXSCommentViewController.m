//
//  HXSCommentViewController.m
//  store
//
//  Created by ArthurWang on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommentViewController.h"

#import "HXSStarLevelView.h"
#import "HXSCommentModel.h"

#define COMMENT_MAXLENGHT   100

#define PLACEHOLDER_STRING @"其他意见和建议..."

@interface HXSCommentViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet HXSStarLevelView *starLevelView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLabel;
@property (weak, nonatomic) IBOutlet HXSRoundedButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;


@property (nonatomic, strong) HXSCommentModel *commentModel;
@property (nonatomic, strong) HXSOrderInfo *orderInfo; // 订单详情
@property (nonatomic, copy) void (^complete)(void);

@end

@implementation HXSCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTextView];
    
    [self updateConfirmBtnStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.orderInfo = nil;
    self.complete  = nil;
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"评价";
}

- (void)initialTextView
{
    self.commentTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)updateConfirmBtnStatus
{
    if ((0 < [self.commentTextView.text length])
        && (![self.commentTextView.text hasPrefix:PLACEHOLDER_STRING])) {
        [self.confirmButton setEnabled:YES];
    } else {
        [self.confirmButton setEnabled:NO];
    }
}


#pragma mark - Public Methods

- (void)setupOrderInfo:(HXSOrderInfo *)orderInfo complete:(void (^)(void))complete
{
    self.orderInfo = orderInfo;
    self.complete = complete;
}

#pragma mark - Setter Getter Methods

- (HXSCommentModel *)commentModel
{
    if (nil == _commentModel) {
        _commentModel = [[HXSCommentModel alloc] init];
    }
    return _commentModel;
}


#pragma mark - actions

- (IBAction)confirmAction:(id)sender
{
    [self.view endEditing:YES];

    HXSOrderItem *orderItem = [self.orderInfo.items firstObject];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakself = self;
    [self.commentModel postCommentWithOrderSn:self.orderInfo.order_sn
                                   starsLevel:[NSNumber numberWithLong:self.starLevelView.starLevel]
                                      content:self.commentTextView.text
                                    productId:orderItem.rid                                    complete:^(HXSErrorCode status, NSString *message, NSDictionary *data) {
                                         [HXSLoadingView closeInView:weakself.view];
                                         
                                         [sender setUserInteractionEnabled:YES];
                                        
                                        if (kHXSNoError != status) {
                                            [MBProgressHUD showInViewWithoutIndicator:weakself.view
                                                                               status:message
                                                                           afterDelay:1.5f];
                                            return ;
                                        }
                                        
                                        CGFloat intervalTime = 1.0f;
                                        [MBProgressHUD showInViewWithoutIndicator:weakself.view
                                                                           status:@"评论成功"
                                                                       afterDelay:intervalTime];
                                        
                                        if (nil != weakself.complete) {
                                            weakself.complete();
                                        }
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(intervalTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [weakself.navigationController popViewControllerAnimated:YES];
                                        });
                                    }];
}

- (void)keyboardShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.scrollViewBottomConstraint.constant = keyboardSize.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardHidden:(NSNotification *)notification
{
    self.scrollViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}


#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (0 >= [textView.text length]) {
        textView.text = PLACEHOLDER_STRING;
        textView.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
    }
    
    if ([textView.text isEqualToString:PLACEHOLDER_STRING]) {
        textView.text = nil;
        textView.textColor = [UIColor colorWithRGBHex:0x999999];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectRange = [textView markedTextRange];
    
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
    if (selectRange &&
        position) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < COMMENT_MAXLENGHT) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger commentRes = COMMENT_MAXLENGHT - [newStr length];
    if (0 <= commentRes) {
        self.wordsCountLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)newStr.length, COMMENT_MAXLENGHT];
        
        return YES;
    } else {
        NSRange commentRg = {0, [text length] + commentRes};
        if (0 < commentRg.length) {
            // Do Nothing
        }
        return NO;
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = nil;
    text = textView.text;
    if (COMMENT_MAXLENGHT < [text length]) {
        textView.text = [text substringToIndex:COMMENT_MAXLENGHT];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        return;
    }
    
    if (COMMENT_MAXLENGHT < [textView.text length]) {
        textView.text = [textView.text substringToIndex:COMMENT_MAXLENGHT];
    }
    self.wordsCountLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, COMMENT_MAXLENGHT];
    
    if (0 >= [textView.text length]) {
        textView.text = PLACEHOLDER_STRING;
        textView.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        
        [textView resignFirstResponder];
    } else {
        textView.textColor = [UIColor colorWithRGBHex:0x999999];
    }
    
    [self updateConfirmBtnStatus];
}

@end
