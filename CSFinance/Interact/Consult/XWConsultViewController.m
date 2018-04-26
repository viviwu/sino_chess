//
//  XWConsultViewController.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/24.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWConsultViewController.h"
#import "XWCollectionView.h"

@interface XWConsultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<XWSectionLayout*>* sectionLayouts;

@end

@implementation XWConsultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.sectionInset = UIEdgeInsetsMake(2.5, 5.0, 5.0, 5.0);
    _layout.minimumLineSpacing = 2.5;
    _layout.minimumInteritemSpacing = 2.5;
    //    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:_layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _cellReuseIDs = @[@"cellA", @"cellB", @"cellC", @"cellD", @"cellE", @"cellF"];
    for (NSString * cellid in _cellReuseIDs) {
        [self.collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    }
    
    [self.collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    //    [_collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.sectionLayouts = [self defaultSectionLayouts];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"MasterList" sender:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionLayouts.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XWSectionLayout * sectionLayout = self.sectionLayouts[section];
    return sectionLayout.celllayouts.count;
}

- (nonnull __kindof XWCollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWSectionLayout * sectionLayout = self.sectionLayouts[indexPath.section];
    XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:sectionLayout.cellReuseID forIndexPath:indexPath];
    
    XWCellLayout * item = sectionLayout.celllayouts[indexPath.row];
    NSString * str = [NSString stringWithFormat:@"Cell (%ld,%ld)", (long)indexPath.section, (long)indexPath.row];
    [cell refreshWithData:@{@"title":item.title, @"detail": str}];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWSectionLayout * sectionLayout = self.sectionLayouts[indexPath.section];
    XWCollectionReusableView * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    [cell refreshWithData:sectionLayout.headerTitle];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWSectionLayout * sectionLayout = self.sectionLayouts[indexPath.section];
    XWCellLayout * item = sectionLayout.celllayouts[indexPath.row];
    if (item.size.height) {
        return item.size;
    }else
        return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWSectionLayout * sectionLayout = self.sectionLayouts[section];
    if (sectionLayout.headerSize.height) {
        return sectionLayout.headerSize;
    }else
        return CGSizeZero;
}


- (NSArray<XWSectionLayout*>*)defaultSectionLayouts{
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<6; k++) {
        XWSectionLayout * sectionLayout =[[XWSectionLayout alloc]init];
        sectionLayout.cellReuseID = _cellReuseIDs[k];
        sectionLayout.headerSize = CGSizeMake(kScreenW, 40.0);
        NSMutableArray * celllayouts = [NSMutableArray array];
        if (k==0) {
            NSArray * titles = @[@"预约专家", @"找专家"];
            for (int i=0; i<2; i++) {
                sectionLayout.headerSize = CGSizeZero;
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/6);
                cellLayout.title = titles[i];
                [celllayouts addObject:cellLayout];
            }
        }else if (k==1) {
            for (int i=0; i<8; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/4-5.0, kScreenW/3);
                cellLayout.title = @"细分领域";
                [celllayouts addObject:cellLayout];
            }
        }else if(k==2){
            for (int i=0; i<1; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW-10.0, kScreenW*0.4);
                cellLayout.title = @"每日热门推荐";
                [celllayouts addObject:cellLayout];
            }
        }else if(k==3){
            for (int i=0; i<2; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                cellLayout.title = @"近期热门话题";
                [celllayouts addObject:cellLayout];
            }
        }else if(k==4){
            for (int i=0; i<6; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/3-5.0, kScreenW/5);
                cellLayout.title = @"🏷️话题";
                [celllayouts addObject:cellLayout];
            }
        }else{
            for (int i=0; i<5; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW-10.0, kScreenW/4);
                [celllayouts addObject:cellLayout];
            }
        }
        sectionLayout.celllayouts = [celllayouts copy];
        [layouts addObject:sectionLayout];
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
