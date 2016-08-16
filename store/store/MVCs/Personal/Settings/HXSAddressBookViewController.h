//
//  HXSAddressBookViewController.h
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HXSSearchDisplayController.h"

@interface HXSAddressBookViewController : HXSBaseViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView * tableview;
@property (nonatomic, copy) NSString * messageBody;

@end