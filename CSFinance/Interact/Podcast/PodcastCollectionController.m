//
//  PodcastCollectionController.m
//  CSFinance
//
//  Created by csco on 2018/4/23.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PodcastCollectionController.h"
#import "XWCollectionView.h"

@interface PodcastCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray<XWSectionLayout*>* sectionLayouts;

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
    }
    [self.collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    
    self.sectionLayouts = [self defaultSectionLayouts];
    [self.collectionView reloadData];
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>
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

- (NSArray<XWSectionLayout*>*)defaultSectionLayouts{
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWSectionLayout * sectionLayout =[[XWSectionLayout alloc]init];
        sectionLayout.cellReuseID = _cellReuseIDs[k];
        sectionLayout.headerSize = CGSizeMake(kScreenW, 40.0);
        NSMutableArray * celllayouts = [NSMutableArray array];
        if (k==0) {
            sectionLayout.headerTitle = @"近期路演";
            for (int i=0; i<3; i++) {
                sectionLayout.headerSize = CGSizeZero;
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW-10, kScreenW/2);
                cellLayout.title = @"XXX路演";
                [celllayouts addObject:cellLayout];
            }
        }else if (k==1) {
            sectionLayout.headerTitle = @"热门直播";
            for (int i=0; i<6; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/2+20.0);
                cellLayout.title = @"XXX直播";
                [celllayouts addObject:cellLayout];
            }
        }else{
            sectionLayout.headerTitle = @"Live课堂";
            for (int i=0; i<5; i++) {
                XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
                cellLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                cellLayout.title = @"XXX课堂";
                [celllayouts addObject:cellLayout];
            }
        }
        sectionLayout.celllayouts = [celllayouts copy];
        [layouts addObject:sectionLayout];
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
