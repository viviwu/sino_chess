//
//  XWConsultCenterViewController.m
//  CSFinance
//
//  Created by csco on 2018/5/8.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWConsultCenterViewController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionGroupHeader.h"
#import "MastersTableViewController.h"

#import "YYKit.h"
#import "NSString+YYAdd.h"
#import "YYTableView.h"
#import "YYPhotoGroupView.h"
#import "XWOpinionLayout.h"
#import "XWOpinionCell.h"

#import "XWImageTitleCell.h"
#import "XWTableCollectCell.h"

#import "XWOpinionComposeViewController.h"
#import "MyQnATableViewController.h"
#import "XWTopicsTableController.h"

@interface XWConsultCenterViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * topicBoard;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray<XWItemLayoutGroup*>* groupLayouts;

@end

@implementation XWConsultCenterViewController

- (UIView *)topicBoard
{
    if(nil == _topicBoard){
        _topicBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120.0)];
        _topicBoard.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120.0)];
        imgView.image = [UIImage imageNamed:@"LibertyStatue.jpg"];
        [_topicBoard addSubview:imgView];
//        [_topicBoard addSubview:self.collectionView];
    }
    return _topicBoard;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [YYTableView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#define kTCRID @"XWTableCollectCell"
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        // Fallback on earlier versions
        if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = _tableView.contentInset;
    [self.tableView registerClass:[XWTableCollectCell class] forCellReuseIdentifier:@"XWTableCollectCell"];
    
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    
    self.tableView.tableHeaderView = self.topicBoard;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.groupLayouts = [self defaultgroupLayouts];
//    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
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
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row<3) {
//        kTCRID
        XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.row];
        NSArray * sectionItems = groupLayout.itemGroup;
        if (indexPath.row == 0) {
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:kTCRID forIndexPath:indexPath];
            cell.cellType = XWTableCollectCellType10Menu;
            
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }else if(indexPath.row == 1){
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:kTCRID forIndexPath:indexPath];
            cell.cellType = XWTableCollectCellTypeDynTags;
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }else{
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:kTCRID forIndexPath:indexPath];
            cell.cellType = XWTableCollectCellType10Menu; 
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }
    }else{
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@""];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 135.0;
    }else if(indexPath.row == 1 ){
        return 80.0;
    }else if(indexPath.row == 2 ){
        return 65.0;
    }else
        return 100.0;
}

- (NSArray<XWItemLayoutGroup*>*)defaultgroupLayouts{
    NSArray * domains = @[@"IPO", @"PE", @"VC", @"MSCI", @"FOF", @"阳光私募", @"ETF", @"QDII", @"个股期权", @"更多"];
    NSArray * labels = @[@"小米IPO", @"MSCI", @"区块链", @"粤港澳大湾区", @"混改", @"深圳国企改革", @"大数据", @"云计算"];
    NSArray * userList = @[@"郎咸平", @"吴敬琏", @"许小年", @"厉以宁", @"谢国忠", @"任志强", @"薛蛮子", @"雷军"];
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWItemLayoutGroup * groupLayout =[[XWItemLayoutGroup alloc]init];
//        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.size = CGSizeMake(kScreenW, 1.0);
        NSMutableArray * itemGroup = [NSMutableArray array];
        if (k==0) {
//            groupLayout.groupStyle = 0 ;
//            groupLayout.title = @"热门细分领域";
//            groupLayout.detail = @"查看更多";
            groupLayout.size = CGSizeMake(kScreenW, 2.0);
            for (int i=0; i<domains.count; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/5-15.0, 60.0);
                itemLayout.title = domains[i];
                [itemGroup addObject:itemLayout];
            }
        }else if(k==1){
//            groupLayout.groupStyle = 6 ;
            groupLayout.size = CGSizeMake(kScreenW, 2.0);
//            groupLayout.title = @"热门话题";
            for (NSString * label in labels) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                NSString * topic = [NSString stringWithFormat:@"#%@#", label];
                CGFloat labelLength = [topic widthForFont:[UIFont systemFontOfSize:14.0]]+5.0;
                itemLayout.size = CGSizeMake(labelLength, 25.0);
                itemLayout.title = topic;
                [itemGroup addObject:itemLayout];
            }
        }else{
            groupLayout.groupStyle = 4 ;
//            groupLayout.title = @"热门答主";
            for (int i=0; i<userList.count; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/5-15.0, 60.0);
                itemLayout.title = userList[i];
                [itemGroup addObject:itemLayout];
            }
        }
        groupLayout.itemGroup = [itemGroup copy];
        [layouts addObject:groupLayout];
    }
    return layouts;
}

/**
 NSArray * arr = @[@"如何解读人社部：划转国有资本充实社保基金试点顺利启动？",
 @"如何看待 2017 年 6 月 21 日中国 A 股纳入 MSCI？意味着什么？",
 @"乐视网目前共涉198项诉讼仲裁 涉案金额超36亿元, 前途何在？",
 @"如何看待一线城市重排座次：从“北上广深”到“上北深广”？",
 @"曾经拒绝马云巨额投资的张一鸣, 可能要联姻阿里?",
 @"如何解读人社部：划转国有资本充实社保基金试点顺利启动？",
 @"如何看待 2017 年 6 月 21 日中国 A 股纳入 MSCI？意味着什么？",
 @"乐视网目前共涉198项诉讼仲裁 涉案金额超36亿元, 前途何在？",
 @"如何看待一线城市重排座次：从“北上广深”到“上北深广”？",
 @"曾经拒绝马云巨额投资的张一鸣, 可能要联姻阿里?"];

-(UICollectionView *) collectionView
{
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
        //        layout.itemSize = CGSizeMake(kScreenW/6, 50.0);
        layout.minimumLineSpacing = 2.5;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 120.0, kScreenW, 260.0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        //_collectionView.allowsMultipleSelection = YES; //多选
        _collectionView.delegate = (id)self;
        _collectionView.dataSource = (id)self;
        
        [_collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:@"domain"];
        [_collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:@"userico"];
        [_collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:@"topic"];
        
        //        [self.collectionView registerClass:[XWCollectionGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    }
    return _collectionView;
}


#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        XWTopicsTableController * topic = [[XWTopicsTableController alloc]init];
        topic.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topic animated:NO];
        topic.hidesBottomBarWhenPushed = NO;
    }else{
        
    }
    //        [self performSegueWithIdentifier:@"MasterList" sender:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groupLayouts.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    return groupLayout.itemGroup.count;
}

- (nonnull id)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    
    if (indexPath.section == 0) {
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"domain" forIndexPath:indexPath];
        cell.cellStyle  = XWImageTitleCellStyleMenu;
        [cell refreshWithLayoutModel:item];
        return cell;
    }else if (indexPath.section == 1) {
        //        XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
        //        cell.cellStyle = groupLayout.groupStyle;
        XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topic" forIndexPath:indexPath];
        cell.cellStyle =XWCollectionCellStyleTag;
        [cell refreshWithLayoutModel:item];
        return cell;
    }else{
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userico" forIndexPath:indexPath];
        cell.cellStyle  = XWImageTitleCellStyleUser;
        [cell refreshWithLayoutModel:item];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    return item.size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    return groupLayout.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
    }else{
        return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    }
}
 
  */

@end
