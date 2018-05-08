//
//  XWTableCollectCell.m
//  CSPP
//
//  Created by csco on 2018/3/30.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWTableCollectCell.h"
#import "NSString+YYAdd.h"

@interface XWTableCollectCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation XWTableCollectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        
    }
    return self;
}
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
        //        layout.itemSize = CGSizeMake(kScreenW/6, 50.0);
        _layout.minimumLineSpacing = 2.5;
        _layout.minimumInteritemSpacing = 5.0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}
-(UICollectionView *) collectionView
{
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = (id)self;
        _collectionView.dataSource = (id)self;
        //_collectionView.allowsMultipleSelection = YES; //多选
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCTCellReuseId];
    }
    return _collectionView;
}

- (void)setCellType:(XWTableCollectCellType)cellType
{
    _cellType = cellType;
    if (_cellType == XWTableCollectCellType10Menu) {
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self.collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:kCTCellReuseIdMenu];
        
    }else if(_cellType == XWTableCollectCellTypeUserLine){
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:kCTCellReuseIdUser];
        
    }else if(_cellType == XWTableCollectCellTypeDynTags){
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self.collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:kCTCellReuseIdTags];
    }else{
        
    }
    [self.contentView addSubview:self.collectionView];
    [self.collectionView setFrame:self.bounds];
    //  [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.collectionView reloadData];
}

- (void)refreshWithLayoutModel:(NSArray<XWItemLayout*>*) sectionItems
{
    _sectionItems = sectionItems;
    [self.collectionView reloadData];
}

#pragma mark--UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath:(%ld, %ld)", (long)indexPath.section, (long)indexPath.row);
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWItemLayout * item = _sectionItems[indexPath.row];
    if (_cellType == XWTableCollectCellType10Menu) {
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTCellReuseIdMenu forIndexPath:indexPath];
 
        [cell refreshWithLayoutModel:item];
        return cell;
    }else if (_cellType == XWTableCollectCellTypeUserLine) {
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTCellReuseIdUser forIndexPath:indexPath];
        
        [cell refreshWithLayoutModel:item];
        return cell;
    }else if(_cellType == XWTableCollectCellTypeDynTags){
        XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTCellReuseIdTags forIndexPath:indexPath];
        cell.cellStyle =XWCollectionCellStyleTag;
        [cell refreshWithLayoutModel:item];
        return cell;
    }else{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCTCellReuseId forIndexPath:indexPath];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }  
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sectionItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == XWTableCollectCellType10Menu) {
        return CGSizeMake(kSelfW/5-8.0, kSelfH/2-5.0);
    }else if(_cellType == XWTableCollectCellTypeDynTags){
        XWItemLayout * item = _sectionItems[indexPath.row];
//        NSLog(@"item.width==>%f", item.size.width);
        return item.size;
    }else{
        return CGSizeMake(kSelfW/5-8.0, kSelfH-5.0);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
