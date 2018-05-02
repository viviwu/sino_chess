//
//  PodcastCollectionController.m
//  CSFinance
//
//  Created by csco on 2018/4/23.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PodcastCollectionController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionReusableView.h"

#import "XWImageSubtitleCell.h"

@interface PodcastCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray<XWGroupLayout*>* groupLayouts;

@end

@implementation PodcastCollectionController

- (UICollectionView *)collectionView{
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (nil == _layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(2.5, 5.0, 5.0, 5.0);
        _layout.minimumLineSpacing = 2.5;
        _layout.minimumInteritemSpacing = 2.5;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    _cellReuseIDs = @[@"videoCellA", @"videoCellB", @"videoCellC"];
    for (NSString * cellid in _cellReuseIDs) {
        [self.collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:cellid];
//        [self.collectionView registerNib:[UINib nibWithNibName:@"XWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellid];
    }
    [self.collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    
    self.groupLayouts = [self defaultgroupLayouts];
    [self.collectionView reloadData];
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groupLayouts.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XWGroupLayout * groupLayout = self.groupLayouts[section];
    return groupLayout.itemLayouts.count;
}

- (nonnull __kindof XWCollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemLayouts[indexPath.row];
    
    XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
    cell.cellStyle = groupLayout.groupStyle;
    [cell refreshWithLayoutModel:item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    
    XWCollectionReusableView * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    
    [cell refreshWithLayoutModel:groupLayout.headerLayout];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemLayouts[indexPath.row];
    if (item.size.height) {
        return item.size;
    }else
        return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWGroupLayout * groupLayout = self.groupLayouts[section];
    if (!CGSizeEqualToSize(groupLayout.headerLayout.size, CGSizeZero)) {
        return groupLayout.headerLayout.size;
    }else
        return CGSizeZero;
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

- (NSArray<XWGroupLayout*>*)defaultgroupLayouts{
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWGroupLayout * groupLayout =[[XWGroupLayout alloc]init];
        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.headerLayout.size = CGSizeMake(kScreenW, 30.0);
        NSMutableArray * itemLayouts = [NSMutableArray array];
        if (k==0) {
            groupLayout.headerLayout.title = @"近期路演";
            for (int i=0; i<3; i++) {
                groupLayout.headerLayout.size = CGSizeZero;
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10, kScreenW/2);
                itemLayout.title = @"XXX路演";
                [itemLayouts addObject:itemLayout];
            }
        }else if (k==1) {
            groupLayout.groupStyle = 2;
            groupLayout.headerLayout.title = @"热门直播";
            for (int i=0; i<4; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/2+50.0);
                itemLayout.title = @"XXX直播";
                [itemLayouts addObject:itemLayout];
            }
        }else{
            groupLayout.headerLayout.title = @"Live课堂";
            groupLayout.groupStyle = 2;
            for (int i=0; i<6; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                itemLayout.title = @"XXX课堂";
                [itemLayouts addObject:itemLayout];
            }
        }
        groupLayout.itemLayouts = [itemLayouts copy];
        [layouts addObject:groupLayout];
    }
    return layouts;
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
