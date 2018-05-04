//
//  XWConsultViewController.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/24.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWConsultViewController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionGroupHeader.h"
#import "MastersTableViewController.h"

#import "NSString+YYAdd.h"

//#import "XWImageTitleCell.h"
//#import "XWCollectionRightCell.h"

@interface XWConsultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<XWItemLayoutGroup*>* groupLayouts;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *mineAccount;
@property (weak, nonatomic) IBOutlet UIView *headerBoard;

//@property (nonatomic, strong) UIView * topToolBar;

@end

@implementation XWConsultViewController

- (IBAction)seeMineQnA:(id)sender {
    
}
- (IBAction)quickAsk:(id)sender {
    
}
- (IBAction)orderMaster:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.sectionInset = UIEdgeInsetsMake(2.5, 10.0, 5.0, 10.0);
    _layout.minimumLineSpacing = 2.5;
    _layout.minimumInteritemSpacing = 2.5;
    //    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat topY = _headerBoard.frame.origin.y + _headerBoard.frame.size.height- 20.0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, topY, kScreenW, kScreenH) collectionViewLayout:_layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    _cellReuseIDs = @[@"cellA", @"cellB", @"cellC", @"cellD", @"cellE", @"cellF"];
    for (int i=0; i<_cellReuseIDs.count; i++) {
        NSString * cellid = _cellReuseIDs[i];
        [self.collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    }
    
    [self.collectionView registerClass:[XWCollectionGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.groupLayouts = [self defaultgroupLayouts];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexPath = self.collectionView.indexPathsForSelectedItems.lastObject;
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    
    MastersTableViewController *destinationVC = segue.destinationViewController;
    destinationVC.title = item.title;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MasterList" sender:self];
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
    XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
    cell.cellStyle = groupLayout.groupStyle;
    
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    [cell refreshWithLayoutModel:item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    return item.size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    if (groupLayout.size.height>10.0) {
        XWCollectionGroupHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        [header refreshWithGroupLayoutModel:groupLayout];
        return header;
    }else
        return [[UICollectionReusableView alloc]init];
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
- (NSArray<XWItemLayoutGroup*>*)defaultgroupLayouts{
    NSArray * domains = @[@"IPO", @"私募", @"新三板", @"债权", @"顾问", @"咨询", @"量化", @"选股"];
    NSArray * labels = @[@"小米IPO", @"MSCI", @"区块链", @"BAT", @"小米概念股", @"中兴被罚", @"粤港澳大湾区", @"虹膜识别", @"混改", @"深圳国企改革", @"大数据"];
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
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<5; k++) {
        XWItemLayoutGroup * groupLayout =[[XWItemLayoutGroup alloc]init];
        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.size = CGSizeMake(kScreenW, 24.0);
        NSMutableArray * itemGroup = [NSMutableArray array];
        if (k==0) {
            groupLayout.groupStyle = 0 ;
            groupLayout.size = CGSizeMake(kScreenW, 35.0);
            groupLayout.title = @"热门细分领域";
            groupLayout.detail = @"查看更多";
            for (int i=0; i<8; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/4-10.0, kScreenW/4);
                itemLayout.title = domains[i];
                [itemGroup addObject:itemLayout];
            }
        }else if(k==1){
            groupLayout.groupStyle = 0 ;
            for (int i=0; i<1; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10.0, kScreenW*0.45);
                itemLayout.title = @"每日热门推荐";
                [itemGroup addObject:itemLayout];
            }
        }else if(k==2){
            groupLayout.groupStyle = 0 ;
            groupLayout.title = @"近期热门话题";
            for (int i=0; i<2; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                itemLayout.title = @"近期热门话题";
                [itemGroup addObject:itemLayout];
            }
        }else if(k==3){
            groupLayout.groupStyle = 6 ;
            groupLayout.title = @"热门话题标签";
            for (NSString * label in labels) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                CGFloat labelLength = [label widthForFont:[UIFont systemFontOfSize:14.0]] +10.0;
                itemLayout.size = CGSizeMake(labelLength, 30.0);
                itemLayout.title = label;
                [itemGroup addObject:itemLayout];
            }
        }else{
            groupLayout.groupStyle = 4 ;
            groupLayout.title = @"近期热议";
            for (int i=0; i<arr.count; i++) {
                
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10.0, kScreenW/4);
                itemLayout.title = arr[i];
                [itemGroup addObject:itemLayout];
            }
        }
        groupLayout.itemGroup = [itemGroup copy];
        [layouts addObject:groupLayout];
    }
    return layouts;
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


@end
