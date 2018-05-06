//
//  PPCompanyOfficialPageController.m
//  CSFinance
//
//  Created by vivi wu on 2018/5/6.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PPCompanyOfficialPageController.h"
#import "XWManagerDetailViewController.h"
#import "XWFundDetailViewController.h"
#import "XWTableHeader.h"
#import "XWTableViewCell.h"
#import "XWTableChartCell.h"
#import "PPManagerInfoCell.h"

#define kReuseIdentifier @"XWTableViewCell"
#define kReuseIdChart @"kReuseIdChart"
#define kReuseIdManager @"PPManagerInfoCell"

#define kNormalRowH 50.0

@interface PPCompanyOfficialPageController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)XWTableHeader * header;
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation PPCompanyOfficialPageController
- (instancetype)init
{
    self =[super init];
    if (self) {
        
    }
    return self;
}

- (UITableView * )tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = kNormalRowH;//
  
    [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];     //XWTableViewCellStyleNormal
    [self.tableView registerClass:[XWTableChartCell class] forCellReuseIdentifier:kReuseIdChart];//
    [self.tableView registerClass:[PPManagerInfoCell class] forCellReuseIdentifier:kReuseIdManager];
    
    _header = [[XWTableHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160.0) headerStyle:XWTableHeaderStyleCompany];
    self.tableView.tableHeaderView = _header;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    self.title = self.company.company_name;
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
    }else if (indexPath.section==3) {
        
    }else{
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete implementation, return the number of rows
    if (section==0) {
        return 2;   //简介 投资理念
    }else if(section ==1){
        return 1;   //收益
    }else if(section ==2){
        return 4;   //旗下基金
    }else if(section ==3){
        return 4;   //
    }else{
        return 3;   //相关观点
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 ==indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resume"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"resume"];
        }
        // Configure the cell...
        if(indexPath.row==0){
            cell.textLabel.text = @"简介";
            cell.detailTextLabel.text = @"上海景林资产管理公司（“上海景林”）是一家以投资境内、外上市公司股票为主的资产管理公司，是在中国证券投资基金业协会登记注册的私募基金管理公司。上海景林从2006年开始管理专注于投资Ａ股的景林稳健、景林丰收等A股信托投资计划，以优秀的业绩和专业的管理赢得了来自大型机构投资者和高净值个人客户的信任，国内机构客户包括几大银行的总行在内的多家银行和知名企业。";
        }else{
            cell.textLabel.text = @"投资理念";
            cell.detailTextLabel.text = @"秉承“价值投资”的投资理念，上海景林的投资常常采用PE股权基金的研究方法。基金经理的投资决定大多基于对公司的基本面分析和股票估值。对公司进行估值的时候，上海景林注重的是其行业结构和公司在产业价值链中的地位，偏好进入门槛较高、与供应商和客户谈判能力强, 并且管理层积极向上且富有能力的公司。这些考虑是上海景林做投资决定和估值过程中的核心。";
        }
        cell.detailTextLabel.numberOfLines = 6;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }else if (1 ==indexPath.section) {
        XWTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdChart forIndexPath:indexPath];
        cell.chartStyle = 1;
        // Configure the cell...
        
        return cell;
    }else if (2 ==indexPath.section) {
        XWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
        cell.cellStyle = XWTableViewCellStyleThreeTitle;
        // Configure the cell...
        if (0==indexPath.row) {
            cell.textLabel.text = @"基金名称";
            cell.detailTextLabel.text = @"累计收益";
            cell.exTextLabel.text = @"年化收益";
        }else{
            cell.textLabel.text = @"---";
            cell.detailTextLabel.text = @"---";
            cell.exTextLabel.text = @"--";
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
    } else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"opinion"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"opinion"];
        }
        // Configure the cell...
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.numberOfLines =2;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = @"巴菲特2018年股东大会总结，涉及世界贸易，接班人及中国投资机会";
        cell.detailTextLabel.text = @"雪球网";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 160.0;
    }else if (indexPath.section==1) {
        return 300.0;
    }else if (indexPath.section==3) {
        return 100.0;
    }else if (indexPath.section==4) {
        return 80.0;
    }else{
        return kNormalRowH;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"| 旗下所有基金收益";
            break;
        case 2:
            return @"| 旗下基金";
            break;
        case 3:
            return @"| 从业档案";
            break;
        case 4:
            return @"| 相关观点";
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
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

@end
