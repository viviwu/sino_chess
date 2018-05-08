//
//  YYWeiboFeedListController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "XWOpinionTimelineViewController.h"
#import "YYKit.h"
#import "WBModel.h"
#import "XWOpinionLayout.h"
#import "XWOpinionCell.h"
#import "YYTableView.h"
#import "YYSimpleWebViewController.h"
#import "XWOpinionComposeViewController.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"

#import "XWImageTitleCell.h"

@interface XWOpinionTimelineViewController () <UITableViewDelegate, UITableViewDataSource, XWOpinionCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) UIView * topicBoard;
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation XWOpinionTimelineViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializationSetUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializationSetUp];
    }
    return self;
}

- (void)initializationSetUp{
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
}
//[XWOpinionHelper imageNamed:@"toolbar_compose_highlighted"]//UIColorHex(fd8224)
- (UIView *)topicBoard
{
    if(nil == _topicBoard){
        _topicBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100.0)];
        _topicBoard.backgroundColor = [UIColor whiteColor];
    }
    return _topicBoard;
}

- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl= [[UISegmentedControl alloc]initWithItems:@[@"关注", @"热门", @"我的"]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = [UIColor orangeColor];
        //KSYRGBAlpha(30, 144, 255, 1.0);
        NSDictionary *selAttri = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName,nil];
        [ _segmentedControl setTitleTextAttributes:selAttri forState:UIControlStateSelected];
        
        NSDictionary *normalAttri = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName,  [UIFont systemFontOfSize:12], NSFontAttributeName,nil];
        [ _segmentedControl setTitleTextAttributes:normalAttri forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

-(UICollectionView *) collectionView
{
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
//        layout.itemSize = CGSizeMake(kScreenW/6, 50.0);
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80.0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
//        _collectionView.allowsMultipleSelection = YES; //多选
        _collectionView.delegate = (id)self;
        _collectionView.dataSource = (id)self;
        
        [_collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:@"XWImageTitleCell"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segmentedControl setFrame:CGRectMake(0, 0, kScreenW, 30.0)];
    [self.view addSubview:self.segmentedControl];
    
    //#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        // Fallback on earlier versions
        if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    _tableView.frame = CGRectMake(0, 30.0, kScreenW, kScreenH-88.0);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    self.tableView.tableHeaderView = self.topicBoard;
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - kWBCellPadding- 100.0;
    _fpsLabel.left = kWBCellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64;
        _tableView.height += 20;
    }
    
    //    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         for (int i = 0; i <= 7; i++) {
         NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_%d.json",i]];
         WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
         for (XWOpinion *status in item.statuses) {
         XWOpinionLayout *layout = [[XWOpinionLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
         //                [layout layout];
         [self->_layouts addObject:layout];
         }
         }
         */
        NSData *data = [NSData dataNamed:@"weibo_0.json"];
        WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
        for (XWOpinion *status in item.statuses) {
            XWOpinionLayout *layout = [[XWOpinionLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
            //                [layout layout];
            [self->_layouts addObject:layout];
        }
        
        // 复制一下，让列表长一些，不至于滑两下就到底了
        //        [self->_layouts addObjectsFromArray:self->_layouts];
        dispatch_async(dispatch_get_main_queue(), ^{
            //   self.title = [NSString stringWithFormat:@"Weibo (loaded:%d)", (int)_layouts.count];
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [self->_tableView reloadData];
        });
    });
    
    [self segmentedControlValueChanged];
}

- (void)segmentedControlValueChanged{
    NSLog(@"%s", __func__);
    if (_segmentedControl.selectedSegmentIndex ==0) {
        self.tableView.tableHeaderView = nil;
    }else if(_segmentedControl.selectedSegmentIndex ==1){
        self.tableView.tableHeaderView = self.collectionView;
    }else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)sendStatus {
    
    XWOpinionComposeViewController *vc = [XWOpinionComposeViewController new];
    vc.type = XWOpinionComposeViewTypeStatus;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self->_fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self->_fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self->_fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self->_fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cell";
    XWOpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XWOpinionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ((XWOpinionLayout *)_layouts[indexPath.row]).height;
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 return self.topicBoard;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 44.0;
 }
 */

#pragma mark - XWOpinionCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(XWOpinionCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了 Card
- (void)cellDidClickCard:(XWOpinionCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = pageInfo.pageTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了转发内容
- (void)cellDidClickRetweet:(XWOpinionCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(XWOpinionCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(XWOpinionCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = tag.tagName;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了关注
- (void)cellDidClickFollow:(XWOpinionCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了转发
- (void)cellDidClickRepost:(XWOpinionCell *)cell {
    XWOpinionComposeViewController *vc = [XWOpinionComposeViewController new];
    vc.type = XWOpinionComposeViewTypeRetweet;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了评论
- (void)cellDidClickComment:(XWOpinionCell *)cell {
    XWOpinionComposeViewController *vc = [XWOpinionComposeViewController new];
    vc.type = XWOpinionComposeViewTypeComment;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(XWOpinionCell *)cell {
    XWOpinion *status = cell.statusView.layout.status;
    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// 点击了用户
- (void)cell:(XWOpinionCell *)cell didClickUser:(WBUser *)user {
    if (user.userID == 0) return;
    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了图片
- (void)cell:(XWOpinionCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    XWOpinion *status = cell.statusView.layout.status;
    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPicture *pic = pics[i];
        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;NSLog(@"item.largeImageURL==%@", item.largeImageURL);
        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(XWOpinionCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    if (info[kWBLinkHrefName]) {
        NSString *url = info[kWBLinkHrefName];
        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (info[kWBLinkURLName]) {
        WBURL *url = info[kWBLinkURLName];
        WBPicture *pic = url.pics.firstObject;
        if (pic) {
            // 点击了文本中的 "图片链接"
            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
            if ([attachment.content isKindOfClass:[UIView class]]) {
                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
                info.largeImageURL = pic.large.url;
                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
                
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
            }
            
        } else if (url.oriURL.length){
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    if (info[kWBLinkTagName]) {
        WBTag *tag = info[kWBLinkTagName];
        NSLog(@"tag:%@",tag.tagScheme);
        return;
    }
    
    if (info[kWBLinkTopicName]) {
        WBTopic *topic = info[kWBLinkTopicName];
        NSString *topicStr = topic.topicTitle;
        topicStr = [topicStr stringByURLEncode];
        if (topicStr.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    if (info[kWBLinkAtName]) {
        NSString *name = info[kWBLinkAtName];
        name = [name stringByURLEncode];
        if (name.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:(%ld, %ld)", (long)indexPath.section, (long)indexPath.row);
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    /*
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"user_ico" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
     */
    XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XWImageTitleCell" forIndexPath:indexPath];
    cell.cellStyle  = XWImageTitleCellStyleUser;
    XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
    itemLayout.title = @"User";
    itemLayout.image = [UIImage imageNamed:@"online_support"];
    [cell refreshWithLayoutModel:itemLayout];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenW/5-10.0, 75.0);
}




@end
