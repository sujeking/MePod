//
//  HXSDormEditRemarksViewController.m
//  store
//
//  Created by chsasaw on 15/6/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormEditRemarksViewController.h"
#import "HXSSettingsManager.h"

static NSInteger const kMaxLengthTextView = 150;

@interface HXSDormEditRemarksViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *leftWordsLabel;

@end

@implementation HXSDormEditRemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"留言";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:
     self.textView];
    
    NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
    self.textView.text = remarks;
    self.textView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickSaveButton:)];
    
    self.textView.text = [[HXSSettingsManager sharedInstance] getRemarks];
    [self.textView becomeFirstResponder];
    self.textView.tintColor = [UIColor lightGrayColor];
    
    _leftWordsLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)self.textView.text.length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc
{
    self.textView.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:self.textView];
}

- (void)onClickSaveButton:(id)sender {
    [[HXSSettingsManager sharedInstance] setRemarks:self.textView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]){
        return YES;
    }
    
    NSMutableString *mutalbeStr = [[NSMutableString alloc] initWithString:textView.text];
    
    [mutalbeStr replaceCharactersInRange:range withString:text];
    
    if (kMaxLengthTextView < [mutalbeStr length]) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _leftWordsLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)self.textView.text.length];
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    
    NSString *toBeString = self.textView.text;
    NSString *lang =  [self.textView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLengthTextView) {
                self.textView.text = [toBeString substringToIndex:kMaxLengthTextView];
            }
        } else {  // 有高亮选择的字符串，则暂不对文字进行统计和限制

        }
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLengthTextView) {
            self.textView.text = [toBeString substringToIndex:kMaxLengthTextView];
        }  
    }
    _leftWordsLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)self.textView.text.length];
}

@end
