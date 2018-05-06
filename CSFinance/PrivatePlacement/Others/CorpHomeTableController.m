//
//  CorpHomeTableController.m
//  CSFinance
//
//  Created by csco on 2018/4/26.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "CorpHomeTableController.h"
#import "CropHomePageCollectionController.h"
#import "CropFundsTableController.h"
#import "CorpManagersTableController.h"
#import "CorpOpinionsViewController.h"
#import "XWSegmentedControl.h"

@interface CorpHomeTableController ()
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property (weak, nonatomic) IBOutlet UIView *sectionHeader;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic) XWSegmentedControl * segCtr;

@end

@implementation CorpHomeTableController

-(UIScrollView * )scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-150.0)];
        _scrollView.contentSize = CGSizeMake(kScreenW*4, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.delegate = self;
        
        CropHomePageCollectionController * homepage =[[CropHomePageCollectionController alloc]init];
        homepage.view.frame = CGRectMake(0, 0, kScreenW, self.view.bounds.size.height);
        [self addChildViewController:homepage];
        [_scrollView addSubview:homepage.view];
        
        CropFundsTableController * funds =[[CropFundsTableController alloc]init];
        funds.view.frame = CGRectMake(kScreenW, 0, kScreenW, self.view.bounds.size.height);
        [self addChildViewController:funds];
        [_scrollView addSubview:funds.view];
        
        CorpManagersTableController * manager =[[CorpManagersTableController alloc]init];
        manager.view.frame = CGRectMake(kScreenW*2, 0, kScreenW, self.view.bounds.size.height);
        [self addChildViewController:manager];
        [_scrollView addSubview:manager.view];
        
        CorpOpinionsViewController * opinion =[[CorpOpinionsViewController alloc]init];
        opinion.view.frame = CGRectMake(kScreenW*3, 0, kScreenW, self.view.bounds.size.height);
        [self addChildViewController:opinion];
        [_scrollView addSubview:opinion.view];
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.tableHeader;
    
    _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles: @[@"公司概览", @"旗下基金", @"基金经理", @"官方动态"]];
    _segCtr.frame = CGRectMake(0, 0, kSelfVB_W, 40.0);
    _segCtr.backgroundColor = [UIColor clearColor];
    _segCtr.indicatorLocation = XWSegIndicatorLocationDown;
    _segCtr.verticalDividerEnabled=YES;
    _segCtr.verticalDividerColor = UIColor.clearColor;
    _segCtr.indicatorColor = UIColor.orangeColor;
    _segCtr.indicatorHeight = 1.0;
    //    _segCtr.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor yellowColor]};
    [_segCtr addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segCtr.selectedIndex = 0;
    _segCtr.clipsToBounds = YES;
    _segCtr.layer.cornerRadius = 8.0;
    [self.sectionHeader addSubview:_segCtr];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)segmentAction:(XWSegmentedControl *)sender
{
    NSInteger index = sender.selectedIndex;
    
    [self.scrollView setContentOffset:CGPointMake(kScreenW*index, 0)];
    //    [self.scrollView scrollRectToVisible:CGRectMake(kScreenW*index, 0, kScreenW, kSelfVB_H) animated:YES];
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segCtr setSelectedSegmentIndex:page animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparence"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"crop" forIndexPath:indexPath];
    if (cell.contentView.subviews.count<1) {
        [cell.contentView addSubview:self.scrollView];
        self.scrollView.frame = cell.contentView.bounds;
    }
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenH-88.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
