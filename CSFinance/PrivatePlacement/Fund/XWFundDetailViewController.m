//
//  XWFundDetailViewController.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWFundDetailViewController.h"
#import "XWTableHeader.h"
#import "XWTableViewCell.h"
#import "XWTableChartCell.h"
#import "PPManagerInfoCell.h"

#import "XWManagerDetailViewController.h"
#import "PPCompanyOfficialPageController.h"

#define kReuseIdentifier @"XWTableViewCell"
#define kReuseIdTrend @"XWTableChartCell"
#define kReuseIdManager @"PPManagerInfoCell"
//#define kReuseIDUITVCell @"UITableViewCell"

#define kNormalRowH 50.0
@interface XWFundDetailViewController (){
    NSArray * _dossierTitles;
}
@property(nonatomic, strong)XWTableHeader * header;

@end

@implementation XWFundDetailViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.estimatedRowHeight = kNormalRowH;
 
        [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];//XWTableViewCellStyleNormal
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIDUITVCell];
        [self.tableView registerClass:[XWTableChartCell class] forCellReuseIdentifier:kReuseIdTrend];//
         [self.tableView registerClass:[PPManagerInfoCell class] forCellReuseIdentifier:kReuseIdManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dossierTitles = @[@[@"所属公司", @"上海银保投资管理有限公司"],
                       @[@"产品基本要素", @"备案号、成立日期、投资顾问等"],
                       @[@"认购信息", @"28年"],
                       @[@"职业背景", @"券商"]    ];
    
    _header = [[XWTableHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160.0) headerStyle:XWTableHeaderStyleFund]; 
    self.tableView.tableHeaderView = _header;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    self.title = self.fund.fund_name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        //    XWManager * manager = _managers[indexPath.row];
        XWManagerDetailViewController * managerDetail = [[XWManagerDetailViewController alloc]init];
        //    managerDetail.manager = manager;
        managerDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:managerDetail animated:NO];
        managerDetail.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section==4){
        if (indexPath.row==0) {
            //    XWManager * manager = _managers[indexPath.row];
            PPCompanyOfficialPageController * managerDetail = [[PPCompanyOfficialPageController alloc]init];
            //    managerDetail.manager = manager;
            managerDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerDetail animated:NO];
            managerDetail.hidesBottomBarWhenPushed = NO;
        }
        
    }else{
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section==0) {
        return 1;
    }else if(section ==1){
        return 5;
    }else if(section ==2){
        return 6;
    }else if(section ==3){
        return 5;
    }else if(section ==4){
        return _dossierTitles.count;
    }else
        return 2;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 ==indexPath.section) {
        XWTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdTrend forIndexPath:indexPath];
        cell.chartStyle = 0;
        // Configure the cell...
        
        return cell;
    }else if(1 ==indexPath.section){
        XWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
        cell.cellStyle = XWTableViewCellStyleFourTitle;
        // Configure the cell...
        if (0==indexPath.row) {
            cell.textLabel.text = @"时间";
            cell.detailTextLabel.text = @"区间收益";
            cell.exTextLabel.text = @"同类平均";
            cell.eyTextLabel.text = @"沪深300";
        }else{
            cell.textLabel.text = @"---";
            cell.detailTextLabel.text = @"---";
            cell.exTextLabel.text = @"--";
            cell.eyTextLabel.text = @"--";
        }
        return cell;
    }else if(2 ==indexPath.section){
        XWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
        cell.cellStyle = XWTableViewCellStyleFourTitle;
        // Configure the cell...
        if (0==indexPath.row) {
            cell.textLabel.text = @"统计日期";
            cell.detailTextLabel.text = @"单位净值";
            cell.exTextLabel.text = @"累计净值";
            cell.eyTextLabel.text = @"净值变动";
        }else{
            cell.textLabel.text = @"---";
            cell.detailTextLabel.text = @"---";
            cell.exTextLabel.text = @"--";
            cell.eyTextLabel.text = @"--";
        }
        return cell;
    }else if(3 ==indexPath.section){
        PPManagerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdManager forIndexPath:indexPath];
        //        cell.cellStyle = XWTableViewCellStyleDuoDetail;
        //        // Configure the cell...
        //        cell.textLabel.text = @"基金经理人X";
        //        cell.detailTextLabel.text = @"276.60%";
        //        cell.exTextLabel.text = @"-0.95%";
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dossier"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"dossier"];
        }
        // Configure the cell...
        NSArray * dossierRow = _dossierTitles[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = dossierRow[0];
        cell.detailTextLabel.text = dossierRow[1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 300.0;
    }else if (indexPath.section==3) {
        return 100.0;
    }else{
        return kNormalRowH;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"| 业绩走势";
            break;
        case 1:
            return @"| 区间收益";
            break;
        case 2:
            return @"| 历史净值";
            break;
        case 3:
            return @"| 基金经理";
            break;
        case 4:
            return @"| 产品档案";
            break;
        case 5:
            return @"| 交易规则";
            break;
        default:
            return @"-";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
