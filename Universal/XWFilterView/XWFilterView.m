//
//  XWFilterView.m
//  XWScrollBanner
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWFilterView.h"
#import "XWFilterCell.h"

#define kCBarH 40.0
#define kSelfH self.bounds.size.height
#define kSelfW self.bounds.size.width

@interface XWFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * controBar;
@property (nonatomic, strong) UIButton * resetBtn;
@property (nonatomic, strong) UIButton * confirmBtn;
@end

@implementation XWFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray*)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        _dataSource = dataSource;
        [self.collectionView reloadData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (UICollectionView *)collectionView{
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSelfW, kSelfH-kCBarH) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = YES; //多选
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    CGFloat itemWidth = kSelfW/4;
    CGFloat itemHeight = 25.0;
    if (nil == _layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.minimumLineSpacing = 5;
    _layout.minimumInteritemSpacing = 5;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.headerReferenceSize =CGSizeMake(itemWidth*2, itemHeight+5.0);
    return _layout;
}

- (void)setUp{
    self.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[XWFilterCell class] forCellWithReuseIdentifier:@"filter"];
    
    [self.collectionView registerClass:[XWFilterSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.controBar];
}

- (UIView *)controBar{
    if (!_controBar) {
        _controBar = [[UIView alloc]initWithFrame:CGRectMake(0, kSelfH-kCBarH, kSelfW, kCBarH)];
        _controBar.backgroundColor = [UIColor redColor];
        [self addSubview:_controBar];
        [self bringSubviewToFront:_controBar];
        
        [_controBar addSubview:self.resetBtn];
        [_controBar addSubview:self.confirmBtn];
    }
    return _controBar;
}

- (UIButton*)resetBtn{
    if (nil==_resetBtn) {
        _resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kSelfW/2, kCBarH)];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
    }
    return _resetBtn;
}

- (UIButton*)confirmBtn{
    if (nil==_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSelfW/2, 0, kSelfW/2, kCBarH)];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor redColor]];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}

- (void)reset{
    for (XWFilterGroup * group in self.dataSource) {
        // NSAssert([arr[0] isKindOfClass:[XWFilter class]], @"obj isNotKindOfClass XWFilter!!!");
        for (XWFilter * model in group.items) {
            if (model.selected) {
                model.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)confirm{
    [self removeFromSuperview];
    NSMutableArray * results = [NSMutableArray array];
    for (XWFilterGroup * group in self.dataSource) {
//        NSAssert([arr[0] isKindOfClass:[XWFilter class]], @"obj isNotKindOfClass XWFilter!!!");
        for (XWFilter * model in group.items) {
            if (model.selected) {
                [results addObject:[NSString stringWithString:model.title]];
            }
        }
    }
    if (self.multiResulter) {
        self.multiResulter(results);
    } 
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.collectionView setFrame:CGRectMake(0, 0, kSelfW, kSelfH-kCBarH)];
    [self.controBar setFrame:CGRectMake(0, kSelfH-kCBarH, kSelfW, kCBarH)];
    
    [self.collectionView setCollectionViewLayout:self.layout];
    [self.collectionView reloadData];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWFilterGroup *group = self.dataSource[indexPath.section];
    for (XWFilter * model in group.items) {
        model.selected = NO;
    }
    XWFilter *model = group.items[indexPath.row];
    model.selected = YES;
    
    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    
}
#pragma mark --UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XWFilterGroup *group = self.dataSource[section];
    return group.items.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWFilterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filter" forIndexPath:indexPath];
    
    XWFilterGroup *group = self.dataSource[indexPath.section];
    BOOL slected = NO;
    for (XWFilter * model in group.items) {
        if (model.selected) {
            slected = model.selected;
        }
    }
    
    XWFilter *model = group.items[indexPath.row];
    if (slected==NO && indexPath.row==0) {
        model.selected = YES;
    }
    
    [cell refreshModel:model];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWFilterSectionHeader * header =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    XWFilterGroup *group = self.dataSource[indexPath.section];
    [header refreshModel:group];
    
    return header;
}


@end
