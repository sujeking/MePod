//
//  HXSCommunityTopicViewController.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityTopicViewController.h"
#import "HXSTopicCollectionViewCell.h"
#import "HXSTopicCollectionReusableView.h"
#import "HXSCommunityTopicsModel.h"
#import "HXSLoginViewController.h"
#import "HXSTopicCollectionViewCell.h"
#import "HXSCommunityTopicListViewController.h"

static NSString *HXSTopicCollectionViewCellIdentify = @"HXSTopicCollectionViewCell";
static NSString *HXSTopicCollectionReusableViewIdentify = @"HXSTopicCollectionReusableView";

@interface HXSCommunityTopicViewController ()<UICollectionViewDelegate,
                                                UICollectionViewDataSource,
                                                HXSTopicCollectionViewCellDelegate,
                                                HXSCommunityTopicListDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, assign) BOOL ifEditing;  // 是否处在编辑状态
@property(nonatomic, assign) BOOL ifOperated; // 用户是否已经操作过界面

@property(nonatomic,strong) NSMutableArray *followTopicsArray;
@property(nonatomic,strong) NSMutableArray *unFollowTopicsArray;

@end

@implementation HXSCommunityTopicViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialPropers];
    [self initialCollectionView];
    [self getTopicList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - intial
- (void)initialNav{
    
    self.navigationItem.title = @"所有话题";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEditOrSaveButton:)];
    
}

- (void)initialPropers{
    
    self.ifEditing = NO;
    self.ifOperated = NO;
    
    self.followTopicsArray = [NSMutableArray array];
    self.unFollowTopicsArray = [NSMutableArray array];
}

- (void)initialCollectionView{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];

    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);//(上，左，下，右)
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    self.collectionView.collectionViewLayout = flowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:HXSTopicCollectionViewCellIdentify bundle:nil]forCellWithReuseIdentifier:HXSTopicCollectionViewCellIdentify];
    [self.collectionView registerNib:[UINib nibWithNibName:HXSTopicCollectionReusableViewIdentify bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HXSTopicCollectionReusableViewIdentify];
    [self addFreshHeader];
 }

- (void)addFreshHeader{

    __weak typeof(self) weakSelf = self;
    [self.collectionView addRefreshHeaderWithCallback:^{
        [weakSelf getTopicList];
    }];
}

#pragma mark - webServies
- (void)getTopicList{
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    [HXSCommunityTopicsModel getCommmutityTopicList:^(HXSErrorCode code, NSString *message, NSArray *followTopics, NSArray *unFollowTopics) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.collectionView endRefreshing];
        
        if(kHXSNoError == code){
            [weakSelf.followTopicsArray removeAllObjects];
            [weakSelf.followTopicsArray addObjectsFromArray:followTopics];
            
            [weakSelf.unFollowTopicsArray removeAllObjects];
            [weakSelf.unFollowTopicsArray addObjectsFromArray:unFollowTopics];
            
            [weakSelf.collectionView reloadData];
        }else{
            if(code != kHXSItemNotExit) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
        }
    }];
}

- (void)followTopics{
    
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    [HXSCommunityTopicsModel commmutityFollowTopics:self.followTopicsArray complete:^(HXSErrorCode code, NSString *message, NSDictionary *dictionary) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(kHXSNoError == code){
            weakSelf.ifOperated = NO;
            weakSelf.ifEditing = NO;
            weakSelf.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.collectionView reloadData];
            [weakSelf addFreshHeader];
        }    }];
}

#pragma mark - IBAction
// 编辑/保存
- (void)onClickEditOrSaveButton:(id)sender{
    
    if ([HXSUserAccount currentAccount].isLogin){
        if(!self.ifEditing){ // 未编辑状态，点击切换成编辑状态
            self.ifEditing = !self.ifEditing;
            self.navigationItem.rightBarButtonItem.title = @"保存";
            [self.collectionView reloadData];
            [self.collectionView  removeRefreshHeader];
            
        }else{ // 编辑状态下，点击保存:1.用户未操作 2.用户已经操作
            if(!self.ifOperated){
                self.ifEditing = !self.ifEditing;
                self.navigationItem.rightBarButtonItem.title = @"编辑";
                [self.collectionView reloadData];
                [self addFreshHeader];
            }else{
                [self followTopics];
            }
        }
    }else{// 点击编辑去登录，然后获取登录以后的话题状态
        __weak typeof(self) weakSelf = self;
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            weakSelf.ifEditing = !self.ifEditing;
            weakSelf.navigationItem.rightBarButtonItem.title = @"保存";
            [weakSelf getTopicList];
            [self.collectionView  removeRefreshHeader];
        }];
   }
}

#pragma  mark - UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return [self.followTopicsArray count];
    }
    else if(section == 1)
    {
        return [self.unFollowTopicsArray count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HXSTopicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HXSTopicCollectionViewCellIdentify forIndexPath:indexPath];
    cell.ifEditing = self.ifEditing;
    cell.delegate = self;
    if(0 == indexPath.section){
        cell.editType = TopicCollectionViewCellEditTypeDelete;
        cell.topic = [self.followTopicsArray objectAtIndex:indexPath.row];
    }
    else{
        
        cell.editType = TopicCollectionViewCellEditTypeAdd;
        cell.topic = [self.unFollowTopicsArray objectAtIndex:indexPath.row];
    }
    return cell;
}

// 定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 60)/3,70);
}

// 这里为collectionView添加Header和Footer

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        HXSTopicCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HXSTopicCollectionReusableViewIdentify forIndexPath:indexPath];
        
        if(indexPath.section == 0)
            reusableView.titleLabel.text = @"关注的话题";
        else if(indexPath.section == 1)
            reusableView.titleLabel.text = @"话题推荐";
        else
            reusableView.titleLabel.text = @"";

        return reusableView;
    }
    else
    {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.ifEditing) {
        return;
    } else {
        
        HXSTopic *topicEntity = nil;
        if(indexPath.section == 0) { // 已经关注
            topicEntity = [self.followTopicsArray objectAtIndex:indexPath.row];
            topicEntity.isFollowedIntNum = @(HXSTopicFollowTypeFollowed);
        } else { // 未关注
            topicEntity = [self.unFollowTopicsArray objectAtIndex:indexPath.row];
            topicEntity.isFollowedIntNum = @(HXSTopicFollowTypeUnFollowed);
        }
        
        HXSCommunityTopicListViewController *communityTopicListViewController = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topicEntity.idStr title:nil delegate:self];
        
        [self.navigationController pushViewController:communityTopicListViewController animated:YES];
    }
}

#pragma mark - HXSTopicCollectionViewCellDelegate
-(void)editButtonClicked:(HXSTopic *)topic TditType:(TopicCollectionViewCellEditType)editType{
    
    self.ifOperated = YES;
    if(TopicCollectionViewCellEditTypeAdd == editType){// 添加话题
        // 新关注的话题要置顶
        [self.followTopicsArray insertObject:topic atIndex:0];
        [self.unFollowTopicsArray removeObject:topic];
        [self.collectionView reloadData];
    }else{
        
        if([self.followTopicsArray count] <= 2){
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"至少留下两个话题哦~" afterDelay:1];
        }else{
            [self.unFollowTopicsArray addObject:topic];
            [self.followTopicsArray removeObject:topic];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - HXSCommunityTopicListDelegate
-(void)refreshTopicList{
    [self getTopicList];
}
@end
