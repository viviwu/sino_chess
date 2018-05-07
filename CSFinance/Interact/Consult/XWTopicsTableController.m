//
//  XWTopicsTableController.m
//  CSFinance
//
//  Created by csco on 2018/5/7.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWTopicsTableController.h"
#import "YYKit.h"
#import "XWOpinionComposeViewController.h"

@interface XWTopicsTableController ()

@end

@implementation XWTopicsTableController
- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        self.tableView.estimatedRowHeight = kNormalRowH;//
//
//        [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];     //XWTableViewCellStyleNormal
//        [self.tableView registerClass:[XWTableChartCell class] forCellReuseIdentifier:kReuseIdChart];//
        //        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"opinion"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"主题XXX";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topic"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topic"];
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.numberOfLines =2;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = @"如何看待 巴菲特2018年股东大会总结，涉及世界贸易，接班人及中国投资机会";
    cell.detailTextLabel.text = @"回复/添加评论";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
