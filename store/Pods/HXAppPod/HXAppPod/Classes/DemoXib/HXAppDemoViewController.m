//
//  HXAppDemoViewController.m
//  Pods
//
//  Created by chsasaw on 16/6/1.
//
//

#import "HXAppDemoViewController.h"

@interface HXAppDemoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIImageView * imageView2;
@property (nonatomic, strong) NSBundle *assetBundle;

@end

@implementation HXAppDemoViewController

+ (id)controllerFromXib {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXAppPod" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:bundle];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Get asset bundle
        self.assetBundle = nibBundleOrNil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickButton:(id)sender {
    NSString *imagePath = [self.assetBundle pathForResource:@"59dorm" ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    [self.imageView setImage:image];
    
    UIImage *image2 = [UIImage imageNamed:@"ic_select2" inBundle:self.assetBundle compatibleWithTraitCollection:nil];
    [self.imageView2 setImage:image2];
}

@end
