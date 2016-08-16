//
//  HXSAddressBookViewController.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSAddressBookViewController.h"
#import "HXSContactManager.h"

#define IS_SEARCH_CELL ([tableView isEqual:self.searchDisplayController.searchResultsTableView])


@interface HXSAddressBookViewController ()<UISearchControllerDelegate>

@property (strong, nonatomic) NSArray * plainContacts;
@property (strong, nonatomic) NSArray * allContacts;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) NSMutableArray * selectedContacts;

- (BOOL) isSelected:(HXSContactInfo *)contact;

@end

@implementation HXSAddressBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showInView:self.view status:@"读取通讯录好友中..."];
    BEGIN_BACKGROUND_THREAD
    self.plainContacts = [HXSContactManager getAllContacts];
    self.allContacts = [self partitionObjects:self.plainContacts collationStringSelector:@selector(name)];
    BEGIN_MAIN_THREAD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.tableview != nil)
    {
        [self.tableview reloadData];
    }
    END_MAIN_THREAD
    END_BACKGROUND_THREAD
    
    self.selectedContacts = [NSMutableArray array];
    
    self.searchDisplayController.searchContentsController.view.tintColor = HXS_DORM_MAIN_COLOR;
    self.searchDisplayController.searchResultsTableView.tintColor = HXS_DORM_MAIN_COLOR;
    
    self.searchDisplayController.searchBar.tintColor = [UIColor lightGrayColor];
    
    self.navigationItem.title = @"邀请手机好友";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(invite:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    self.tableview = nil;
    
    self.allContacts = nil;
    self.searchResults = nil;
    self.plainContacts = nil;
    self.selectedContacts = nil;
}


#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!IS_SEARCH_CELL)
    {
        return [self.allContacts count];
    }
    else
    {
        return [self.searchResults count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IS_SEARCH_CELL)
    {
        if (section >= 0 && section < self.allContacts.count)
        {
            NSArray * array = [self.allContacts objectAtIndex:section];
            return array.count;
        }
    }
    else
    {
        if (section >= 0 && section < self.searchResults.count)
        {
            NSArray * array = [self.searchResults objectAtIndex:section];
            return array.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HXSContactInfo * contactInfo = nil;
    if (IS_SEARCH_CELL)
    {
        if (section >= 0 && section < self.searchResults.count)
        {
            NSArray * array = [self.searchResults objectAtIndex:section];
            if (row >= 0 && row < array.count)
            {
                contactInfo = [array objectAtIndex:row];
            }
        }
    }
    else
    {
        if (section >= 0 && section < self.allContacts.count)
        {
            NSArray * array = [self.allContacts objectAtIndex:section];
            if (row >= 0 && row < array.count)
            {
                contactInfo = [array objectAtIndex:row];
            }
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell"];
    }
    cell.textLabel.text = contactInfo ? contactInfo.name : @"";
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (contactInfo && [self isSelected:contactInfo])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HXSContactInfo * info = nil;
    if (IS_SEARCH_CELL)
    {
        if (section >= 0 && section < self.searchResults.count)
        {
            NSArray * array = [self.searchResults objectAtIndex:section];
            if (row >= 0 && row < array.count)
            {
                info = [array objectAtIndex:row];
            }
        }
    }
    else
    {
        if (section >= 0 && section < self.allContacts.count)
        {
            NSArray * array = [self.allContacts objectAtIndex:section];
            if (row >= 0 && row < array.count)
            {
                info = [array objectAtIndex:row];
            }
        }
    }
    
    if (info != nil)
    {
        if ([self isSelected:info])
        {
            [self.selectedContacts removeObject:info];
        }
        else
        {
            [self.selectedContacts addObject:info];
        }
        
        [tableView reloadData];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (IS_SEARCH_CELL)
    {
        BOOL showSection = [[self.searchResults objectAtIndex:section] count] != 0;
        //only show the section title if there are rows in the section
        return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
    else
    {
        BOOL showSection = [[self.allContacts objectAtIndex:section] count] != 0;
        return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (BOOL) isSelected:(HXSContactInfo *)contact
{
    if ([self.selectedContacts indexOfObject:contact] < self.selectedContacts.count)
        return YES;
    else
        return NO;
}

- (void)invite:(id)sender
{
    if (self.selectedContacts.count == 0)
    {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:LS(@"请先选择好友") afterDelay:0.8];
    }
    else
    {
        if ([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate= self;
            
            NSString * url = @"http://www.59store.com/share?hxfrom=message";
            if([HXSUserAccount currentAccount].userID != nil) {
                url = [url stringByAppendingFormat:@"&uid=%@", [HXSUserAccount currentAccount].userID];
            }
            
            picker.body = self.messageBody?self.messageBody:[NSString stringWithFormat:@"我发现了一家开在寝室里的便利店，下单后5分钟就能送货上床。不信？试试看:%@ 59store夜猫店，充饥、解渴、解馋一个都不能少。", url];
            
            picker.navigationBar.tintColor = [UIColor colorWithRed:34/255.0 green:142/255.0 blue:206/255.0 alpha:1.0];
            NSMutableArray * recipients = [NSMutableArray array];
            for (int i = 0; i < self.selectedContacts.count; i++)
            {
                HXSContactInfo * info = [self.selectedContacts objectAtIndex:i];
                [recipients addObject:info.phoneNumber];
            }
            picker.recipients = recipients;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:LS(@"您的设备不支持发送短信") afterDelay:0.8];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search delegate

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"self.name contains[cd] %@",
                                    searchText];
	NSArray *searchResults_ = [self.plainContacts filteredArrayUsingPredicate:resultPredicate];
	self.searchResults = [self partitionObjects:searchResults_ collationStringSelector:@selector(name)];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews)
	{
		if([subview isKindOfClass:[UILabel class]])
		{
			[(UILabel*)subview setText:@"Enter to search"];
		}
	}
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews)
	{
		if([subview isKindOfClass:[UILabel class]])
		{
			[(UILabel*)subview setText:@"Enter to search"];
		}
	}
    
	self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:238/255.0 blue:233/255.0 alpha:1.0];
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    return YES;
}


#pragma mark -

-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array)
    {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    for (NSMutableArray *section in unsortedSections)
    {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}

#pragma mark - UISearchControllerDelegate
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    // This works fine in iOS8 without the ugly delay. Oh well.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController.viewControllers[0] showNavbar];
    });
}

@end
