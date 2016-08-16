//
//  HXSWalletSelectContactViewController.m
//  store
//
//  Created by hudezhi on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSWalletSelectContactViewController.h"
#import "HXSContactManager.h"

@interface HXSWalletSelectContactViewController ()

@property (strong, nonatomic) NSArray *plainContacts;
@property (strong, nonatomic) NSArray *allContacts;

@end

@implementation HXSWalletSelectContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tintColor = [UIColor colorWithRGBHex:0x0065CD];
    
    [MBProgressHUD showInView:self.view status:@"读取通讯录好友中..."];
    BEGIN_BACKGROUND_THREAD
    self.plainContacts = [HXSContactManager getAllContacts];
    self.allContacts = [self partitionObjects:self.plainContacts collationStringSelector:@selector(name)];
    BEGIN_MAIN_THREAD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
    END_MAIN_THREAD
    END_BACKGROUND_THREAD
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array) {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allContacts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= 0 && section < self.allContacts.count) {
        NSArray * array = [self.allContacts objectAtIndex:section];
        return array.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HXSContactInfo * contactInfo = nil;

    if (section >= 0 && section < self.allContacts.count) {
        NSArray * array = [self.allContacts objectAtIndex:section];
        if (row >= 0 && row < array.count) {
            contactInfo = [array objectAtIndex:row];
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BorrowSelectContactCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BorrowSelectContactCell"];
    }
    cell.textLabel.text = contactInfo ? contactInfo.name : @"";
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section >= 0 && section < self.allContacts.count) {
        NSArray * array = [self.allContacts objectAtIndex:section];
        if (row >= 0 && row < array.count) {
            self.contactInfo = [array objectAtIndex:row];
            [self performSegueWithIdentifier:@"BackToConatctSegue" sender:nil];
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL showSection = [[self.allContacts objectAtIndex:section] count] != 0;
    return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
