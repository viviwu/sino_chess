//
//  PodcastCollectionController.m
//  CSFinance
//
//  Created by csco on 2018/4/23.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PodcastCollectionController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionGroupHeader.h"

#import "XWImageSubtitleCell.h"

#import "YYKit.h"
#import "ZFJVideo.h"

#import "TOWebViewController.h"
#import "TOWebViewController+1Password.h"

#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

/* Detect if we're running iOS 7.0 or higher */
#define MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

@interface PodcastCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray<XWItemLayoutGroup*>* groupLayouts;

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
        _layout.minimumLineSpacing = 10.0;
        _layout.minimumInteritemSpacing = 2.5;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    _cellReuseIDs = @[@"videoCellA", @"videoCellB", @"videoCellC"];
    for (NSString * cellid in _cellReuseIDs) {
        [self.collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:cellid];
//        [self.collectionView registerNib:[UINib nibWithNibName:@"XWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellid];
    }
    [self.collectionView registerClass:[XWCollectionGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    
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
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    return groupLayout.itemGroup.count;
}

- (nonnull __kindof XWCollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    
    XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
    cell.cellStyle = groupLayout.groupStyle;
    [cell refreshWithLayoutModel:item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWCollectionGroupHeader * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    cell.actionHandle = ^(XWItemLayoutGroup *groupModel){
        NSLog(@"-------->itemGroup: %lu", (unsigned long)groupModel.itemGroup.count);
    };
    
    [cell refreshWithGroupLayoutModel:groupLayout];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    if (item.size.height) {
        return item.size;
    }else
        return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    if (!CGSizeEqualToSize(groupLayout.size, CGSizeZero)) {
        return groupLayout.size;
    }else
        return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    
    NSURL *url = item.url;
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.showOnePasswordButton = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.hidesBottomBarWhenPushed = NO;
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self readJsonFile];
}

- (NSArray<XWItemLayoutGroup*>*)defaultgroupLayouts{
    NSData *data = [NSData dataNamed:@"jfz_roadshows.json"];
    ZFJVideoList * list = [ZFJVideoList modelWithJSON:data];
    NSArray * roadShows = list.videoItems;
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWItemLayoutGroup * groupLayout =[[XWItemLayoutGroup alloc]init];
        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.groupStyle = 2;
//        groupLayout.groupModel = roadShows;
        groupLayout.size = CGSizeMake(kScreenW, 40.0);
        groupLayout.detail = @"查看更多";
        
        NSMutableArray * itemGroup = [NSMutableArray array];
        if (k==0) {
            groupLayout.title = @"近期路演";
            for (ZFJVideo *item in roadShows) {
//                groupLayout.size = CGSizeZero;
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW-10, kScreenW/2);
                itemLayout.title = item.title;
                itemLayout.imgUrl = [NSURL URLWithString:item.thumb];
                itemLayout.url = [NSURL URLWithString:[item.url stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
                itemLayout.model = item;
                [itemGroup addObject:itemLayout];
            }
        }else if (k==1) {
            groupLayout.title = @"热门直播";
            for (int i=0; i<4; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/2+50.0);
                itemLayout.title = @"XXX直播";
                [itemGroup addObject:itemLayout];
            }
        }else{
            groupLayout.title = @"Live课堂"; 
            for (int i=0; i<6; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/2-7.5, kScreenW/3);
                itemLayout.title = @"XXX课堂";
                [itemGroup addObject:itemLayout];
            }
        }
        groupLayout.itemGroup = itemGroup; 
        [layouts addObject:groupLayout];
    }
    return layouts;
}


- (void)readJsonFile{
    
    /*
    for (ZFJVideo * item in list.videoItems) {
//        ZFJVideo * video = [ZFJVideo modelWithJSON:item];
        NSLog(@"video:%@", item.title);
    }
     */
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
