//
//  OfficialStatusViewController.m
//  CSFinance
//
//  Created by csco on 2018/4/23.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "OfficialStatusViewController.h"
#import "YYKit.h"
#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"
#import "YYTableView.h"
#import "YYSimpleWebViewController.h"
#import "WBStatusComposeViewController.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"

@interface OfficialStatusViewController ()<UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) UIToolbar * compositeBar;

@end

@implementation OfficialStatusViewController

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

- (UIToolbar *)compositeView{
    if(nil == _compositeBar){
        UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *compositeItem = [[UIBarButtonItem alloc] initWithImage:[WBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
        compositeItem.tintColor = UIColorHex(fd8224);
        _compositeBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44.0)];
        _compositeBar.backgroundColor = [UIColor whiteColor];
        [_compositeBar setItems:@[space, compositeItem] animated:YES];
    }
    return _compositeBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //#ifdef __IPHONE_11_0
    //#else
    //#endif
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
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - kWBCellPadding;
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
        for (int i = 0; i <= 7; i++) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_%d.json",i]];
            WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
            for (WBStatus *status in item.statuses) {
                WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                //                [layout layout];
                [self->_layouts addObject:layout];
            }
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
}


- (void)sendStatus {
    
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeStatus;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ((WBStatusLayout *)_layouts[indexPath.row]).height;
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.compositeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

#pragma mark - WBStatusCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = pageInfo.pageTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = tag.tagName;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell {
    NSLog(@"%s", __func__);
}

/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeRetweet;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeComment;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
    WBStatus *status = cell.statusView.layout.status;
    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user {
    if (user.userID == 0) return;
    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBStatus *status = cell.statusView.layout.status;
    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPicture *pic = pics[i];
        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;
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
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
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
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
