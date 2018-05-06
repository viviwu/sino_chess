//
//  MyQnATableViewController.m
//  CSFinance
//
//  Created by vivi wu on 2018/5/7.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "MyQnATableViewController.h"
#import "NSDate+YYAdd.h"

@interface MyQnATableViewController ()
{
    NSArray * _questions;
    NSArray * _answers;
}
@property (nonatomic, strong)UISegmentedControl * segCtr;
@end

@implementation MyQnATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segCtr = [[UISegmentedControl alloc]initWithItems:@[@"我的提问", @"我的回答"]];
    _segCtr.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segCtr;
    [_segCtr addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
    _questions = @[
                   @" @Stevevai1983[¥6.00] 我配有8%左右的再生元仓位，作为医药股的长期配置（恒瑞实在太贵了，下不去手），也不想短期获利。想请问，您对再生元最近两年的经营有什么预测，在哪些时间节点需要特别注意公司的经营变化，出现什么情况，不管赔赚，就是该卖出的时候了。多谢！ ",
                   @"@释老毛[¥88.00] 毛巨师，今年价投真难，年初到现在浮盈只剩一个点，压力巨大，目前满融90的仓位在招商银行，浮亏半个点，格力吃了个跌停，希望给点建议整个银行板块感觉趋势在往下走，历史pe在中位数区间上方，最近招行又吃了罚单，不知对股价影响几何。"
                   ];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)valueChanged{
    [self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete implementation, return the number of rows
    if (_segCtr.selectedSegmentIndex ==0) {
        return _questions.count;
    }else
        return _answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    // Configure the cell...
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = _questions[indexPath.row];
    cell.detailTextLabel.text = [[[NSDate date] dateByAddingDays:indexPath.row] stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
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
