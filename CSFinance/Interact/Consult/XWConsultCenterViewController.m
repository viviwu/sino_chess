//
//  XWConsultCenterViewController.m
//  CSFinance
//
//  Created by csco on 2018/5/8.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWConsultCenterViewController.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionGroupHeader.h"
#import "MastersTableViewController.h"

#import "YYSimpleWebViewController.h"
#import "XWOpinionComposeViewController.h"

#import "YYKit.h"
#import "NSString+YYAdd.h"
#import "YYTableView.h"
#import "YYPhotoGroupView.h"
#import "XWOpinionLayout.h"
#import "XWOpinionCell.h"

#import "XWImageTitleCell.h"
#import "XWTableCollectCell.h"

#import "XWOpinionComposeViewController.h"
#import "MyQnATableViewController.h"
#import "XWTopicsTableController.h"

@interface XWConsultCenterViewController ()<UITableViewDelegate, UITableViewDataSource, XWOpinionCellDelegate /*, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout*/>
{
    NSArray * _cellReuseIDs;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *layouts;

@property (nonatomic, strong) UIView * topicBoard;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray<XWItemLayoutGroup*>* groupLayouts;

@end

@implementation XWConsultCenterViewController

- (UIView *)topicBoard
{
    if(nil == _topicBoard){
        _topicBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120.0)];
        _topicBoard.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120.0)];
        imgView.image = [UIImage imageNamed:@"LibertyStatue.jpg"];
        [_topicBoard addSubview:imgView];
//        [_topicBoard addSubview:self.collectionView];
    }
    return _topicBoard;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [YYTableView new];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#define kTCRID @"XWTableCollectCell"
- (void)viewDidLoad {
    [super viewDidLoad];
    _layouts = [NSMutableArray new];
    
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
    
    //ios11默认开启self-sizing：heightForHeaderInSection设置高度无效 所以加上这个
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView setFrame:self.view.bounds];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = _tableView.contentInset;
    [self.tableView registerClass:[XWOpinionCell class] forCellReuseIdentifier:@"question"];
    
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    
    self.tableView.tableHeaderView = self.topicBoard;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.groupLayouts = [self defaultgroupLayouts];
    // Do any additional setup after loading the view.
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSData *data = [NSData dataNamed:@"question_list.json"];
         WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
         for (XWOpinion *status in item.statuses) {
             XWOpinionLayout *layout = [[XWOpinionLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
             //                [layout layout];
             [self->_layouts addObject:layout];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [indicator removeFromSuperview];
             self.navigationController.view.userInteractionEnabled = YES;
             [self->_tableView reloadData];
         });
     });
//    [self.collectionView reloadData];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat wbOffSetH = 49.0 + 64.0;
    if (@available(iOS 11.0, *)) {
        wbOffSetH = self.view.safeAreaInsets.top+ self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    NSLog(@"wbOffSetH==%f", wbOffSetH);
    [_tableView setFrame:CGRectMake(0, 0, kSelfVB_W, kSelfVB_H-wbOffSetH)];
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
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0 || section==1 || section==2) {
        return 1;
    }else
        return _layouts.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section<3) { //        kTCRID
        XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
        NSArray * sectionItems = groupLayout.itemGroup;
        if (indexPath.section == 0) {
            
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XWTableCollectCellType10Menu"];
            if (!cell) {
                cell = [[XWTableCollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XWTableCollectCellType10Menu"];
            }
            cell.cellType = XWTableCollectCellType10Menu;
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }else if(indexPath.section == 1){
            
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XWTableCollectCellTypeDynTags"];
            if (!cell) {
                cell = [[XWTableCollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XWTableCollectCellTypeDynTags"];
            }
            cell.cellType = XWTableCollectCellTypeDynTags;
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }else{// if(indexPath.section == 2)
            XWTableCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XWTableCollectCellTypeUserLine"];
            if (!cell) {
                cell = [[XWTableCollectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XWTableCollectCellTypeUserLine"];
            }
            cell.cellType = XWTableCollectCellTypeUserLine;
            [cell refreshWithLayoutModel:sectionItems];
            return cell;
        }
    }else{
        NSString *cellID = @"question";
        XWOpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[XWOpinionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.delegate = (id)self;
        }
        [cell setLayout:_layouts[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 135.0;
    }else if(indexPath.section == 1 ){
        return 70.0;
    }else if(indexPath.section == 2 ){
        return 64.0;
    }else{
        CGFloat height = ((XWOpinionLayout *)_layouts[indexPath.row]).height;
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 1.0;
    }else
        return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

//====================================================================
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

//====================================================================

- (NSArray<XWItemLayoutGroup*>*)defaultgroupLayouts{
    NSArray * domains = @[@"IPO", @"PE", @"VC", @"MSCI", @"FOF", @"阳光私募", @"ETF", @"QDII", @"个股期权", @"更多"];
    NSArray * labels = @[@"小米IPO", @"MSCI", @"区块链", @"粤港澳大湾区", @"混改", @"深圳国企改革", @"大数据", @"云计算"];
    NSArray * userList = @[@"郎咸平", @"吴敬琏", @"许小年", @"厉以宁", @"谢国忠", @"任志强", @"薛蛮子", @"雷军"];
    
    NSMutableArray * layouts = [NSMutableArray array];
    for (int k=0; k<3; k++) {
        XWItemLayoutGroup * groupLayout =[[XWItemLayoutGroup alloc]init];
//        groupLayout.cellReuseID = _cellReuseIDs[k];
        groupLayout.size = CGSizeMake(kScreenW, 1.0);
        NSMutableArray * itemGroup = [NSMutableArray array];
        if (k==0) {
//            groupLayout.groupStyle = 0 ;
//            groupLayout.title = @"热门细分领域";
//            groupLayout.detail = @"查看更多";
            groupLayout.size = CGSizeMake(kScreenW, 2.0);
            for (int i=0; i<domains.count; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/5-15.0, 60.0);
                itemLayout.title = domains[i];
                [itemGroup addObject:itemLayout];
            }
        }else if(k==1){
//            groupLayout.groupStyle = 6 ;
            groupLayout.size = CGSizeMake(kScreenW, 2.0);
//            groupLayout.title = @"热门话题";
            for (NSString * label in labels) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                NSString * topic = [NSString stringWithFormat:@"#%@#", label];
                CGFloat labelLength = [topic widthForFont:[UIFont systemFontOfSize:14.0]]+8.0;
                itemLayout.size = CGSizeMake(labelLength, 28.0);
                itemLayout.title = topic;
                [itemGroup addObject:itemLayout];
            }
        }else{
            groupLayout.groupStyle = 4 ;
//            groupLayout.title = @"热门答主";
            for (int i=0; i<userList.count; i++) {
                XWItemLayout * itemLayout = [[XWItemLayout alloc]init];
                itemLayout.size = CGSizeMake(kScreenW/5-15.0, 60.0);
                itemLayout.title = userList[i];
                [itemGroup addObject:itemLayout];
            }
        }
        groupLayout.itemGroup = [itemGroup copy];
        [layouts addObject:groupLayout];
    }
    return layouts;
}

/**
 NSArray * arr = @[@"如何解读人社部：划转国有资本充实社保基金试点顺利启动？",
 @"如何看待 2017 年 6 月 21 日中国 A 股纳入 MSCI？意味着什么？",
 @"乐视网目前共涉198项诉讼仲裁 涉案金额超36亿元, 前途何在？",
 @"如何看待一线城市重排座次：从“北上广深”到“上北深广”？",
 @"曾经拒绝马云巨额投资的张一鸣, 可能要联姻阿里?",
 @"如何解读人社部：划转国有资本充实社保基金试点顺利启动？",
 @"如何看待 2017 年 6 月 21 日中国 A 股纳入 MSCI？意味着什么？",
 @"乐视网目前共涉198项诉讼仲裁 涉案金额超36亿元, 前途何在？",
 @"如何看待一线城市重排座次：从“北上广深”到“上北深广”？",
 @"曾经拒绝马云巨额投资的张一鸣, 可能要联姻阿里?"];

-(UICollectionView *) collectionView
{
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
        //        layout.itemSize = CGSizeMake(kScreenW/6, 50.0);
        layout.minimumLineSpacing = 2.5;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 120.0, kScreenW, 260.0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        //_collectionView.allowsMultipleSelection = YES; //多选
        _collectionView.delegate = (id)self;
        _collectionView.dataSource = (id)self;
        
        [_collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:@"domain"];
        [_collectionView registerClass:[XWImageTitleCell class] forCellWithReuseIdentifier:@"userico"];
        [_collectionView registerClass:[XWCollectionViewCell class] forCellWithReuseIdentifier:@"topic"];
        
        //        [self.collectionView registerClass:[XWCollectionGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
    }
    return _collectionView;
}


#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        XWTopicsTableController * topic = [[XWTopicsTableController alloc]init];
        topic.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topic animated:NO];
        topic.hidesBottomBarWhenPushed = NO;
    }else{
        
    }
    //        [self performSegueWithIdentifier:@"MasterList" sender:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groupLayouts.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    return groupLayout.itemGroup.count;
}

- (nonnull id)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    
    if (indexPath.section == 0) {
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"domain" forIndexPath:indexPath];
        cell.cellStyle  = XWImageTitleCellStyleMenu;
        [cell refreshWithLayoutModel:item];
        return cell;
    }else if (indexPath.section == 1) {
        //        XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:groupLayout.cellReuseID forIndexPath:indexPath];
        //        cell.cellStyle = groupLayout.groupStyle;
        XWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topic" forIndexPath:indexPath];
        cell.cellStyle =XWCollectionCellStyleTag;
        [cell refreshWithLayoutModel:item];
        return cell;
    }else{
        XWImageTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userico" forIndexPath:indexPath];
        cell.cellStyle  = XWImageTitleCellStyleUser;
        [cell refreshWithLayoutModel:item];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[indexPath.section];
    XWItemLayout * item = groupLayout.itemGroup[indexPath.row];
    return item.size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XWItemLayoutGroup * groupLayout = self.groupLayouts[section];
    return groupLayout.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return UIEdgeInsetsMake(2.5, 10.0, 2.5, 10.0);
    }else{
        return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    }
}
 
  */

@end
