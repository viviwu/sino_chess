//
//  XWConsultViewController.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/24.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWConsultViewController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionReusableView.h"

//#import "XWImageTitleCell.h"
//#import "XWCollectionRightCell.h"

@interface XWConsultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<XWGroupLayout*>* groupLayouts;
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
//        if (i==_cellReuseIDs.count-1) {
//            [self.collectionView registerNib:[UINib nibWithNibName:@"XWCollectionRightCell" bundle:nil] forCellWithReuseIdentifier:cellid];
//        }else{
//            [self.collectionView registerNib:[UINib nibWithNibName:@"XWImageTitleCell" bundle:nil] forCellWithReuseIdentifier:cellid];
//        }
    }
    
    [self.collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    //    [_collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.groupLayouts = [self defaultgroupLayouts];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
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
    XWGroupLayout * groupLayout = self.groupLayouts[section];
    return groupLayout.itemLayouts.count;
}

- (nonnull id)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
    cell.cellStyle = groupLayout.groupStyle;
    
    XWItemLayout * item = groupLayout.itemLayouts[indexPath.row];
    [cell refreshWithLayoutModel:item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemLayouts[indexPath.row];
    return item.size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    if (groupLayout.headerLayout.size.height>10.0) {
        XWCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        [header refreshWithLayoutModel:groupLayout.headerLayout];
        return header;
    }else
        return [[UICollectionReusableView alloc]init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWGroupLayout * groupLayout = self.groupLayouts[section];
    return groupLayout.headerLayout.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
    }else{
        return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    }
}
- (NSArray<XWGroupLayout*>*)defaultgroupLayouts{
    
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
        XWGroupLayout * groupLayout =[[XWGroupLayout alloc]init];
        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.headerLayout.size = CGSizeMake(kScreenW, 24.0);
        NSMutableArray * itemLayouts = [NSMutableArray array];
        if (k==0) {
            groupLayout.groupStyle = 0 ;
            groupLayout.headerLayout.size = CGSizeMake(kScreenW, 35.0);
            groupLayout.headerLayout.title = @"热门细分领域";
            groupLayout.headerLayout.detail = @"查看更多";
            for (int i=0; i<8; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/4-10.0, kScreenW/4);
                itemLayout.title = @"细分领域";
                [itemLayouts addObject:itemLayout];
            }
        }else if(k==1){
            groupLayout.groupStyle = 0 ;
            for (int i=0; i<1; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10.0, kScreenW*0.45);
                itemLayout.title = @"每日热门推荐";
                [itemLayouts addObject:itemLayout];
            }
        }else if(k==2){
            groupLayout.groupStyle = 0 ;
            for (int i=0; i<2; i++) {
                groupLayout.headerLayout.title = @"近期热门话题";
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                itemLayout.title = @"近期热门话题";
                [itemLayouts addObject:itemLayout];
            }
        }else if(k==3){
            groupLayout.groupStyle = 6 ;
            for (int i=0; i<7; i++) {
//                cell.cellStyle = XWCollectionCellStyleTag;
                groupLayout.headerLayout.title = @"热门话题标签";
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(80.0, 30.0);
                itemLayout.title = [NSString stringWithFormat:@"🏷️标签%d", i];
                [itemLayouts addObject:itemLayout];
            }
        }else{
            groupLayout.groupStyle = 4 ;
            for (int i=0; i<arr.count; i++) {
                groupLayout.headerLayout.title = @"近期热议";
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10.0, kScreenW/4);
                itemLayout.title = arr[i];
                [itemLayouts addObject:itemLayout];
            }
        }
        groupLayout.itemLayouts = [itemLayouts copy];
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
