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

+ (NSArray<XWCellLayout*>*)defaultSectionLayouts{
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWSectionLayout * sectionLayout =[[XWSectionLayout alloc]init];
        sectionLayout.headerSize = CGSizeMake(kScreenW, 40.0);
        NSMutableArray * celllayouts = [NSMutableArray array];
        for (int i=0; i<6; i++) {
            XWCellLayout * cellLayout = [[XWCellLayout alloc]init];
            if (k==1) {
                cellLayout.size = CGSizeMake(kScreenW/2-7.5, 100.0);
            }else if(k==2){
                cellLayout.size =  CGSizeMake(kScreenW/3-5.0, 150.0);
            }else{
                cellLayout.size = CGSizeMake(kScreenW-10.0, 80.0);
            }
            
            [celllayouts addObject:cellLayout];
        }
        sectionLayout.celllayouts = [celllayouts copy];
        [layouts addObject:sectionLayout];
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

- (void)refreshWith:(id)sectionLayouts
{
    self.sectionLayouts = sectionLayouts;
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
    XWCellLayout * item = sectionLayout.celllayouts[indexPath.row];
    NSString * str = [NSString stringWithFormat:@"Cell (%ld,%ld)", (long)indexPath.section, (long)indexPath.row];
    XWCollectionViewCell * cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellA" forIndexPath:indexPath];
  
    [cell refreshWithData:@{@"title":item.title, @"detail": str}];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [NSString stringWithFormat:@"Header (%ld,%ld)", (long)indexPath.section, (long)indexPath.row];
    XWCollectionReusableView * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    [cell refreshWithData:str];
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
