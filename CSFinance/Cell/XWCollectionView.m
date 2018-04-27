//
//  XWCollectionView.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionView.h"

//#define selfW self.view.frame.size.width
//#define selfH self.view.frame.size.height



@interface XWCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
//@property(nonatomic, strong)UICollectionView * collectionView;

@end

@implementation XWCollectionView

+ (NSArray<XWItemLayout*>*)defaultgroupLayouts{
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWGroupLayout * groupLayout =[[XWGroupLayout alloc]init];
        groupLayout.headerLayout.size = CGSizeMake(kScreenW, 40.0);
        NSMutableArray * itemLayouts = [NSMutableArray array];
        for (int i=0; i<6; i++) {
            XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
            if (k==1) {
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, 100.0);
            }else if(k==2){
                itemLayout.size =  CGSizeMake(kScreenW/3-5.0, 150.0);
            }else{
                itemLayout.size = CGSizeMake(kScreenW-10.0, 80.0);
            }
            
            [itemLayouts addObject:itemLayout];
        }
        groupLayout.itemLayouts = [itemLayouts copy];
        [layouts addObject:groupLayout];
    }
    return layouts;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    //    CGFloat itemWidth = frame.size.width-10.0;
    //    CGFloat itemHeight = 125.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 2.5;
    layout.minimumInteritemSpacing = 2.5;
    //    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setUp];
    }
    return self;
}
/*
 - (UICollectionViewLayout*)collectionViewLayout
 {
 }
 */
- (void)setUp{
    self.userInteractionEnabled = YES;
    //    _layout.headerReferenceSize =CGSizeMake(itemWidth, itemHeight/2.0);
    //    _layout.footerReferenceSize =CGSizeMake(itemWidth, itemHeight/2.0);
    //    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, selfW, selfH) collectionViewLayout:_layout];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:@"cellA"];
    //    [self registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:@"cellB"];
    //    [self registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:@"cellC"];
    
    [self registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    //    [_collectionView registerClass:[XWCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    
    self.delegate = self;
    self.dataSource = self;
    //    [self.view addSubview:_collectionView];
}

- (void)setSelectHandle:(SelectActionHandle)selectHandle
{
    _selectHandle = [selectHandle copy];
}
//- (void)setActionDelegate:(id<XWCollectionViewActionDelegate>)actionDelegate
//{
//    _actionDelegate = actionDelegate;
//}

- (void)refreshWith:(id)groupLayouts
{
    self.groupLayouts = groupLayouts;
    [self reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectHandle) {
        self.selectHandle(indexPath);
    }
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

- (nonnull __kindof XWCollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWGroupLayout * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemLayouts[indexPath.row];
    
    XWCollectionViewCell * cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellA" forIndexPath:indexPath];
  
    [cell refreshWithLayoutModel:item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayout * item =[[XWItemLayout alloc]init];
    item.title = [NSString stringWithFormat:@"Header (%ld,%ld)", (long)indexPath.section, (long)indexPath.row];
    
    XWCollectionReusableView * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    
    [cell refreshWithLayoutModel:item];
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
    if (groupLayout.headerLayout.size.height) {
        return groupLayout.headerLayout.size;
    }else
        return CGSizeZero;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(selfW, 30.0);
//}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
