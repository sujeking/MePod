//
//  HXSDormAboutUsViewController.m
//  store
//
//  Created by ranliang on 15/5/9.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormAboutUsViewController.h"
#import "HXSGuideViewController.h"

@interface HXSDormAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *versionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopContraint;

@end

@implementation HXSDormAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    
    self.versionButton.enabled = NO;
    [self.versionButton setTitle:[[HXAppConfig sharedInstance] appVersion] forState:UIControlStateNormal];
    
    self.navigationItem.title = @"关于59store";
    
    //为iPhone 4S重新设置一下图片大小
    if (SCREEN_HEIGHT < 481) {
        self.imageWidthConstraint.constant *= 0.8;
        self.imageHeightContraint.constant *= 0.8;
        self.imageTopContraint.constant = 20;
    }
}

- (void)popTheViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickAbout:(id)sender {
    HXSGuideViewController * controller = [[HXSGuideViewController alloc] initWithNibName:@"HXSGuideViewController" bundle:nil];
    controller.block = ^ {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onClickService:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4001185959"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
