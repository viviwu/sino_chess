//
//  PPManagerViewController.m
//  XDemo
//
//  Created by csco on 2018/4/20.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "PPManagerViewController.h"
#import "XWSegmentedControl.h"

#import "ShopOverviewTableController.h"
#import "FundRackTableController.h"
#import "FundManagersTableController.h"
#import "OfficialStatusViewController.h"
#import "WBStatusTimelineViewController.h"

@interface PPManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sectionHeader;

@property (nonatomic, copy) NSArray<NSString*>* sectionTitles;
@property (nonatomic) XWSegmentedControl * segCtr;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation PPManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if 0
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
#endif
    self.sectionTitles = @[@"概览", @"产品", @"经理", @"动态"];
    _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles:self.sectionTitles];
    _segCtr.frame = CGRectMake(0, 0, kSelfVB_W, 40.0);
    _segCtr.backgroundColor = [UIColor whiteColor];
    _segCtr.indicatorLocation = XWSegIndicatorLocationDown;
    _segCtr.verticalDividerEnabled=YES;
    _segCtr.verticalDividerColor = UIColor.clearColor;
    _segCtr.indicatorColor = UIColor.orangeColor;
    _segCtr.indicatorHeight = 1.0;
    //    _segCtr.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor yellowColor]};
    [_segCtr addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segCtr.selectedIndex = 0;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kSelfVB_H)];
    self.scrollView.contentSize = CGSizeMake(kScreenW*4, 0);
    [self.view addSubview:self.scrollView];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubViewControllers];
    // Do any additional setup after loading the view.
}

- (void)segmentAction:(XWSegmentedControl *)sender
{
    NSInteger index = sender.selectedIndex;
    [self.scrollView setContentOffset:CGPointMake(kScreenW*index, 0)];
}

- (void)addSubViewControllers{
    
    ShopOverviewTableController * overview = [[UIStoryboard storyboardWithName:@"PPRank" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopOverviewTableController"];
    FundRackTableController * product = [[UIStoryboard storyboardWithName:@"PPRank" bundle:nil] instantiateViewControllerWithIdentifier:@"FundRackTableController"];
    FundManagersTableController* manager = [[UIStoryboard storyboardWithName:@"PPRank" bundle:nil] instantiateViewControllerWithIdentifier:@"FundManagersTableController"];
    WBStatusTimelineViewController * opinion = [WBStatusTimelineViewController new];
    
    [overview.view setFrame:CGRectMake(0, 0, kScreenW, kSelfVB_H)];
    [product.view setFrame:CGRectMake(kScreenW, 0, kScreenW, kSelfVB_H)];
    [manager.view setFrame:CGRectMake(kScreenW*2, 0, kScreenW, kSelfVB_H)];
    [opinion.view setFrame:CGRectMake(kScreenW*3, 0, kScreenW, kSelfVB_H)];
    
    [self addChildViewController:overview];
    [self addChildViewController:manager];
    [self addChildViewController:product];
    [self addChildViewController:opinion];
    
    [self.scrollView addSubview:overview.view];
    [self.scrollView addSubview:manager.view];
    [self.scrollView addSubview:product.view];
    [self.scrollView addSubview:opinion.view];
    
    self.scrollView.delegate = (id)self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"offsetX==%f", offsetX);
    _segCtr.selectedIndex =(NSInteger)(offsetX/kScreenW);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparence"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.scrollView];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _segCtr;
}

@end
