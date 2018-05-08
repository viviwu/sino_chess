//
//  XWRankViewController.m
//  XWFundsRank
//
//  Created by vivi wu on 2018/5/5.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWRankViewController.h"
#import "XWFilterView.h"
#import "XWScrollBanner.h"
#import "XWTableViewCell.h"

#import "UIButton+Bootstrap.h"
#import "NSData+YYAdd.h"
#import "NSObject+YYModel.h"
#import "XWFund.h"
#import "XWManager.h"
#import "XWCompany.h"

#import "XWFundDetailViewController.h"
#import "XWManagerDetailViewController.h"
#import "PPCompanyOfficialPageController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define KSYRGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define reuseID @"reuseIdentifier"
#define kHeaderH 36.0
#define kMenuH 40.0
@interface XWRankViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _safeTopY;
    CGFloat _safeBottomY;
    CGFloat _insetY;
    NSArray * _sectionTitles;
    NSArray * _menuTitles;
    NSArray * _fundFitlerGroups;
}
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * topADboard;
@property (strong, nonatomic) XWScrollBanner *scrollBanner;
@property (nonatomic, strong) UIView * filterMenu;
@property (nonatomic, strong) UIView * sectionHeader;
@property (nonatomic, strong) XWFilterView * filterView;

@property (nonatomic, strong) NSMutableArray * funds;
@property (nonatomic, strong) NSMutableArray * managers;
@property (nonatomic, strong) NSMutableArray * companys;
@end

@implementation XWRankViewController

- (XWFilterView *)filterView{
  
    if (nil ==_filterView) {
        NSMutableArray * dataSource = [NSMutableArray array];
        for (int i=0; i<7; i++) {
            XWFilterGroup * group =[[XWFilterGroup alloc]init];
            group.sectionTitle = [NSString stringWithFormat:@"Section-%d", i];
            for (int k=0; k<arc4random()%4+3; k++) {
                XWFilter * filter = [[XWFilter alloc]init];
                filter.title = [NSString stringWithFormat:@"(%d,%d)", i, k];
                [group.items addObject:filter];
            }
            [dataSource addObject:group];
        }
        _filterView =[[XWFilterView alloc]initWithFrame:CGRectMake(0, _insetY, kScreenW, kScreenH - _insetY-83.0) dataSource:dataSource];
        _filterView.multiResulter = ^(NSArray * filters){
            NSLog(@"filters==%@", filters);
        };
    }
    return _filterView;
}

- (UIView *)topADboard{
    if (!_topADboard) {
        _topADboard = [[UIView alloc]init];
        _topADboard.backgroundColor = KSYRGBAlpha(181, 181, 181, 1.0);
    }
    return _topADboard;
}

- (UIView *)filterMenu{
    if (!_filterMenu) {
        _filterMenu = [[UIView alloc]initWithFrame:CGRectMake(0, _insetY, kScreenW, kScreenH-_insetY)];
        _filterMenu.backgroundColor = [UIColor whiteColor];
        CGFloat btnW = kScreenW/3;
        for (int k=0; k<3; k++) {
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"---" forState:UIControlStateNormal];
            [btn austerityStyle];
            [btn addAwesomeIcon:FAIconArrowDown beforeTitle:NO];
            btn.tag = 1000+k;
            [btn addTarget:self action:@selector(btnTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_filterMenu addSubview:btn];
            [btn setFrame:CGRectMake(k*btnW, 0, btnW, kMenuH)];
        }
    }
    return _filterMenu;
}

- (void)btnTouchEvent:(UIButton *)btn{
    NSArray * menus = _menuTitles[_segmentedControl.selectedSegmentIndex];
    NSInteger tag = btn.tag-1000;
    NSString * title = btn.titleLabel.text;
    if (tag<menus.count) {
        title = menus[tag];
    }else
        NSLog(@"%ld--%@", (long)tag, title);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.selected = ! btn.selected;
    if (btn.selected) {
        CGFloat filterNeedH = 0;
        NSArray * fitlerGroups = _fundFitlerGroups;//?=0
        NSArray * fitlerGroup = fitlerGroups[tag];
        
        NSMutableArray * dataSource = [NSMutableArray array];
        for (int i=0; i<fitlerGroup.count; i++)
        {
            filterNeedH += 35.0;
            NSDictionary * fiterDic = fitlerGroup[i];
            XWFilterGroup * group =[[XWFilterGroup alloc]init];
            group.sectionTitle = fiterDic[@"h"];
            NSArray * fiterTitles = fiterDic[@"ts"];
            
            NSUInteger uint = fiterTitles.count/3;
            NSInteger inx = fiterTitles.count%3>0?1:0;
            filterNeedH += 30.0 * (uint + inx);
            
            for (int k=0; k<fiterTitles.count; k++)
            {
                XWFilter * filter = [[XWFilter alloc]init];
                filter.title = fiterTitles[k];
                [group.items addObject:filter];
            }
            [dataSource addObject:group];
        }
        self.filterView.dataSource = dataSource;
        filterNeedH +=40.0;
        CGFloat safeH = kScreenH - _safeTopY - _safeBottomY - kScreenW/2 - _safeBottomY;
        if (filterNeedH > safeH) {
            filterNeedH = safeH;
        }
        [btn addAwesomeIcon:FAIconArrowUp beforeTitle:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view addSubview:self.filterView];
            self.filterView.hidden = NO;
            [self.filterView setFrame:CGRectMake(0, self->_insetY, kScreenW, filterNeedH+40.0)];
            [self.filterView layoutIfNeeded];
        }];
    }else{
        [btn austerityStyle];
        [btn addAwesomeIcon:FAIconArrowDown beforeTitle:NO];
        self.filterView.hidden = YES;
    }
}

- (UIView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kHeaderH)];
        _sectionHeader.backgroundColor = [UIColor lightGrayColor];
        CGFloat laW = kScreenW/3;
        for (int i=0; i<3; i++) {
            UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(laW * i, 0, laW-0.5, kHeaderH)];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.text = @"---";
            label.font =[UIFont systemFontOfSize:18.0];
            label.textAlignment = NSTextAlignmentCenter;
            [_sectionHeader addSubview:label];
        }
        _sectionHeader.autoresizesSubviews = YES;
    }
    return _sectionHeader;
}

- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl= [[UISegmentedControl alloc]initWithItems:@[@"私募基金", @"基金经理", @"私募公司"]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = [UIColor orangeColor];
        //KSYRGBAlpha(30, 144, 255, 1.0);
        NSDictionary *selAttri = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName,nil];
        
        [ _segmentedControl setTitleTextAttributes:selAttri forState:UIControlStateSelected];
        //默认字体颜色
        NSDictionary *normalAttri = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName,  [UIFont systemFontOfSize:12], NSFontAttributeName,nil];
        
        [ _segmentedControl setTitleTextAttributes:normalAttri forState:UIControlStateNormal];
    }
    return _segmentedControl;
}

- (void)segmentedControlValueChanged{
    self.filterView.hidden = YES;
    NSArray * menus = _menuTitles[_segmentedControl.selectedSegmentIndex];
    CGFloat menuW = kScreenW/menus.count;
    NSArray * titles = _sectionTitles[_segmentedControl.selectedSegmentIndex];
    [UIView animateWithDuration:1.0 animations:^{
        self.topADboard.hidden = NO;
        [self.tableView setFrame:CGRectMake(0, self->_insetY, kScreenW, kScreenH)];
        [self.tableView reloadData];
    } completion:^(BOOL finished){
        
        for (int k=0; k<3; k++) {
            UILabel * label = self->_sectionHeader.subviews[k];
            label.text = titles[k];
            
            UIButton * btn = self->_filterMenu.subviews[k];
            if (k<menus.count) {
                [btn setTitle:menus[k] forState:UIControlStateNormal];
                [btn addAwesomeIcon:FAIconArrowDown beforeTitle:NO];
                [btn setFrame:CGRectMake(menuW*k, 0, menuW, kMenuH)];
            }else{
                [btn setFrame:CGRectMake(menuW*k, 0, 0, kMenuH)];
            }
        }
        if (0 == self->_segmentedControl.selectedSegmentIndex && self->_funds.count>0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if(0 == self->_segmentedControl.selectedSegmentIndex && self->_managers.count>0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if(0 == self->_segmentedControl.selectedSegmentIndex && self->_companys.count>0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{}
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _funds = [NSMutableArray array];
    _managers = [NSMutableArray array];
    _companys = [NSMutableArray array];
    
    _sectionTitles = @[@[@"基金名称", @"最新净值", @"区间收益"],
                       @[@"基金经理", @"所在公司", @"任期收益"],
                       @[@"公司简称", @"最新净值", @"区间收益"]];
    
    _menuTitles = @[@[@"投资策略", @"近一个月", @"筛选"],
                    @[@"全部背景", @"所在公司"],
                    @[@"所在年份", @"全部地区"]];
    
    _fundFitlerGroups = @[
  @[@{@"h": @"投资策略", @"ts": @[@"股票策略", @"管理期货", @"相对价值" ,@"事件驱动", @"固定收益", @"宏观策略", @"组合策略", @"复合策略"]}],
  @[@{@"h": @"排名周期", @"ts": @[@"近一个月", @"近三个月", @"最近半年" ,@"最近一年", @"最近三年", @"最近五年", @"今年以来", @"2017年", @"2016年", @"2015年", @"2014年", @"2013年", @"2012年", @"2011年", @"2010年"]}],
  @[@{@"h": @"投资策略", @"ts": @[@"按区间收益", @"按夏普比率"]},
    @{@"h": @"产品类型", @"ts": @[@"不限", @"自主发行", @"公募专户", @"券商资管", @"期货资管", @"有限合伙", @"信托产品"]},
    @{@"h": @"公司类型", @"ts": @[@"私募公司", @"其它"]},
    @{@"h": @"所在地区", @"ts": @[@"不限", @"北京", @"上海", @"深圳", @"广州", @"其它"]},
    @{@"h": @"是否分级", @"ts": @[@"不分级", @"分级"]},
    @{@"h": @"是否伞型", @"ts": @[@"非伞型", @"伞型"]}]  ];
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:reuseID];
    [self.view addSubview:self.tableView];

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.estimatedSectionHeaderHeight = 30.0;
    self.tableView.estimatedSectionFooterHeight = 1.0;
    
    //    self.tableView.tableHeaderView = self.topADboard;
    [self.view addSubview:self.topADboard];
    [self.topADboard addSubview:self.scrollBanner];
    [self.topADboard addSubview:self.filterMenu];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        _safeTopY = self.view.safeAreaInsets.top;  //iphone X 88.0
        _safeBottomY = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
        _safeTopY = 64.0;
        _safeBottomY = 49.0;
    }
    [self.topADboard setFrame:CGRectMake(0, _safeTopY, kScreenW, kScreenW/2)];
    [self.filterMenu setFrame:CGRectMake(0, kScreenW/2-kMenuH, kScreenW, kMenuH)];
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector: @selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    _insetY = _safeTopY;
    _insetY = CGRectGetMaxY(self.topADboard.frame);
//    self.tableView.contentInset = UIEdgeInsetsMake(_insetY, 0, 0, 0);
    [self.tableView setFrame:CGRectMake(0, _insetY, kScreenW, kScreenH)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_funds.count<1) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            NSData *data = [NSData dataNamed:@"fundRankList.json"];
            XWFundResponse * response = [XWFundResponse modelWithJSON:data];
            XWFundData * dataJson = response.data;
            [self->_funds addObjectsFromArray:dataJson.list];
            //通知主线程刷新（防止主线程堵塞）
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                if (self->_funds.count) {
                    [self.tableView reloadData];
                }
            });
        }); 
    }
    if (_managers.count<1) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            NSData *data = [NSData dataNamed:@"managerRankList.json"];
            XWManagerResponse * response = [XWManagerResponse modelWithJSON:data];
            XWManagerData * dataJson = response.data;
            [self->_managers addObjectsFromArray:dataJson.list];
            //通知主线程刷新（防止主线程堵塞）
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                if (self->_managers.count) {
                    [self.tableView reloadData];
                }
            });
        });
    }
    if (_companys.count<1) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            NSData *data = [NSData dataNamed:@"companyRankList.json"];
            XWCompanyResponse * response = [XWCompanyResponse modelWithJSON:data];
            XWCompanyData * dataJson = response.data;
            [self->_companys  addObjectsFromArray:dataJson.list];
            //通知主线程刷新（防止主线程堵塞）
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                if (self->_companys.count) {
                    [self.tableView reloadData];
                }
            });
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self segmentedControlValueChanged];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
//    self.tableView.contentInset = UIEdgeInsetsMake(_insetY, 0, 0, 0);
    [UIView animateWithDuration:0.5 animations:^{
        if (scrollView.contentOffset.y>self->_safeTopY) {
            self.topADboard.hidden = YES;
            [self.tableView setFrame:CGRectMake(0, self->_safeTopY, kScreenW, kScreenH)];
        }else{
            self.topADboard.hidden = NO;
            [self.tableView setFrame:CGRectMake(0, self->_insetY, kScreenW, kScreenH)];
        }
    }];
}

//+++++++++++++++++++++++++++++++++++++++++
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==_segmentedControl.selectedSegmentIndex) {
        XWFund * fund = _funds[indexPath.row];
        XWFundDetailViewController * fundDetail = [[XWFundDetailViewController  alloc]init];
        fundDetail.fund = fund;
        fundDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fundDetail animated:NO];
        fundDetail.hidesBottomBarWhenPushed = NO;
    }else if(1==_segmentedControl.selectedSegmentIndex){
        XWManager * manager = _managers[indexPath.row];
        XWManagerDetailViewController * managerDetail = [[XWManagerDetailViewController alloc]init];
        managerDetail.manager = manager;
        managerDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:managerDetail animated:NO];
        managerDetail.hidesBottomBarWhenPushed = NO;
    }else{
        XWCompany * company = _companys[indexPath.row];
        PPCompanyOfficialPageController * companyPage = [[PPCompanyOfficialPageController alloc]init];
        companyPage.company=company;
        companyPage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyPage animated:NO];
        companyPage.hidesBottomBarWhenPushed = NO;
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
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0==_segmentedControl.selectedSegmentIndex) {
        return _funds.count;
    }else if(1==_segmentedControl.selectedSegmentIndex){
        return _managers.count;
    }else{
        return _companys.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.cellStyle = XWTableViewCellStyleThreeTitle;
    
    // Configure the cell...
    if (0 == self.segmentedControl.selectedSegmentIndex) {
        XWFund * fund = _funds[indexPath.row];
        cell.textLabel.text = fund.fund_name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", fund.nav];
        cell.exTextLabel.text = [NSString stringWithFormat:@"+%.2f%%", [fund.income floatValue]];
    }else if (1 == self.segmentedControl.selectedSegmentIndex) {
        XWManager * manager = _managers[indexPath.row];
        cell.textLabel.text = manager.manager_name;
        cell.detailTextLabel.text = manager.company_name;
        cell.exTextLabel.text = [NSString stringWithFormat:@"+%.2f%%", [manager.income floatValue]];
    }else{
        XWCompany * company = _companys[indexPath.row];
        cell.textLabel.text = company.company_name;
        cell.detailTextLabel.text = company.fund_managers;
        cell.exTextLabel.text = [NSString stringWithFormat:@"+%.2f%%", [company.income floatValue]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderH;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (XWScrollBanner *)scrollBanner
{
    if (!_scrollBanner) {
        NSArray * models = [self fakeModels];
        NSMutableArray * sources = [NSMutableArray array];
        for (int i=0; i<models.count; i++) {
            NSDictionary * model = models[i];
            XWBannerModel *bannerModel = [[XWBannerModel alloc]init];
            bannerModel.title = model[@"rank"];
            bannerModel.imgURL = [NSURL URLWithString:model[@"image"]];
            bannerModel.link = model[@"url"];
            [sources addObject:bannerModel];
        }
        _scrollBanner = [[XWScrollBanner alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2 -kMenuH) dataSource:sources];
//        _scrollBanner.dataSource = sources;
        _scrollBanner.bannerClickHandle = ^(NSInteger currentPage, XWBannerModel * model){
            NSLog(@"currentPage is: %ld", currentPage);
        };
    }
    return _scrollBanner;
}

- (NSArray*)fakeModels{
    return @[
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/1049db96aaf99f3f92fc225c006648a6.jpg",
                 @"url" : @"https://h5.jinfuzi.com/app/community/communityDetail?articleId=6816",
                 @"rank" : @"202"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/f601d614da6a1a56f30da4fe5fd5e501.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pevc/tg-34",
                 @"rank" : @"201"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/e0ffc289900db4adb9060df0cedf056b.jpg",
                 @"url" : @"https://h5.jinfuzi.com/vueApp/community/communityDetail/5650",
                 @"rank" : @"200"
                 },
             @{
                 @"image" : @"https://jfz-static2.oss-cn-hangzhou.aliyuncs.com/main/img/92a7d6f5a9d2996342becbaaf6391fde.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pof/tg-135",
                 @"rank" : @"194"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/89f6c1a5a9ebf5e15277087502388800.jpg",
                 @"url" : @"https://h5.jinfuzi.com/activity/other/tg20",
                 @"rank" : @"190"
                 },
             @{
                 @"image" : @"https://jfz-static2.oss-cn-hangzhou.aliyuncs.com/main/img/96de6f1a5cb64f9f99ace06b8e04bffe.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pevc/tg-30",
                 @"rank" : @"162"
                 }
             ];
}

@end
