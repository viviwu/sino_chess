//
//  PPFundsRankTableViewController.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PPFundsRankTableViewController.h"
#import "XWScrollBanner.h"
#import "XWFilterView.h"
#import "XWTableViewCell.h"

#import "NSData+YYAdd.h"
#import "NSObject+YYModel.h"
#import "XWFund.h"

@interface PPFundsRankTableViewController ()
@property (strong, nonatomic) XWFilterView * filterView;
@property (strong, nonatomic)  XWScrollBanner *scrollBanner;
@property (strong, nonatomic) NSMutableArray * funds;
@end

@implementation PPFundsRankTableViewController

- (instancetype)init{
    self =[super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (XWFilterView *)filterView{
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    CGFloat startY = 230.0-self.tableView.contentOffset.y;
    
    if (nil ==_filterView) {
        NSMutableArray * dataSource = [NSMutableArray array];
        for (int i=0; i<7; i++) {
            NSMutableArray * sectionSource = [NSMutableArray array];
            for (int k=0; k<arc4random()%4+3; k++) {
                XWFilter * filter = [[XWFilter alloc]init];
                filter.title = [NSString stringWithFormat:@"(%d,%d)", i, k];
                filter.sectionTitle = [NSString stringWithFormat:@"Section-%d", i];
                [sectionSource addObject:filter];
            }
            [dataSource addObject:sectionSource];
        }
        _filterView =[[XWFilterView alloc]initWithFrame:CGRectMake(0, startY, self.view.frame.size.width, self.view.frame.size.height - startY- safeBottom) dataSource:dataSource];
    }
    return _filterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _funds = [NSMutableArray array];
    [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:@"fund"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_funds.count<1) {
        NSData *data = [NSData dataNamed:@"fundRankList.json"];
        XWFundResponse * response = [XWFundResponse modelWithJSON:data];
        XWFundData * dataJson = response.data;
        [_funds addObjectsFromArray:dataJson.list];
        if (_funds.count) {
            [self.tableView reloadData];
        }
    }
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
    return _funds.count;
}

- (XWTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fund" forIndexPath:indexPath];
    cell.cellStyle = XWTableViewCellStyleThreeTitle;
    
    XWFund * fund = _funds[indexPath.row];
    // Configure the cell...
//    NSLog(@"%@--%@", fund.nav, fund.income);
    cell.textLabel.text = fund.fund_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", fund.nav];
    cell.exTextLabel.text = [NSString stringWithFormat:@"+%@", fund.income]; 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _sectionHeader;
//}


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
