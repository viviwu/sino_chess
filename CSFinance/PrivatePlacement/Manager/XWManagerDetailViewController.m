//
//  XWManagerDetailViewController.m
//  CSFinance
//
//  Created by vivi wu on 2018/5/6.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWManagerDetailViewController.h"
#import "XWFundDetailViewController.h"
#import "PPCompanyOfficialPageController.h"

#import "XWTableHeader.h"
#import "XWTableViewCell.h"
#import "XWTableChartCell.h"

#define kReuseIdentifier @"XWTableViewCell"
#define kReuseIdChart @"kReuseIdChart"

#define kNormalRowH 50.0
@interface XWManagerDetailViewController (){
    NSArray * _dossierTitles;
}
@property(nonatomic, strong)XWTableHeader * header;
@end

@implementation XWManagerDetailViewController
- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.estimatedRowHeight = kNormalRowH;//
        
        [self.tableView registerClass:[XWTableViewCell class] forCellReuseIdentifier:kReuseIdentifier];     //XWTableViewCellStyleNormal
        [self.tableView registerClass:[XWTableChartCell class] forCellReuseIdentifier:kReuseIdChart];//
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"opinion"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _header = [[XWTableHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160.0) headerStyle:XWTableHeaderStyleManager];
    self.tableView.tableHeaderView = _header;
    
    _dossierTitles = @[@[@"所属公司", @"上海银保投资管理有限公司"],
                       @[@"公司职位", @"主席兼首席投资官"],
                       @[@"从业年限", @"28年"],
                       @[@"职业背景", @"券商"]    ];
    // Uncomment t""he following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    self.title = self.manager.manager_name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            //    XWManager * manager = _managers[indexPath.row];
            PPCompanyOfficialPageController * managerDetail = [[PPCompanyOfficialPageController alloc]init];
            //    managerDetail.manager = manager;
            managerDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerDetail animated:NO];
            managerDetail.hidesBottomBarWhenPushed = NO;
        }
        
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
        return 1;   //简介
    }else if(section ==1){
        return 1;   //综合评价
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resume"];
        }
        // Configure the cell...
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = @"1989年于上海大学毕业，获本科学位，曾任职于中国航天信托投资公司、国泰君安公司、吉林证券有限公司,担任资产管理、自营投资等职位。其超过20年的股票及期货管理经验并取得优异成绩。1999年创立Pinpoint公司，担任Pinpoint China Fund基金经理，带领基金研究团队取得七年636.84%的收益回报。现任公司投资总监 基金经理。";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        return cell;
    }else if (1 ==indexPath.section) {
        XWTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdChart forIndexPath:indexPath];
        cell.chartStyle = 1;
        // Configure the cell...
        AAChartModel *chartModel = [self configureAAChartModel];
        chartModel.chartType = AAChartTypePie;
        //        NSString *chartType = chartModel.chartType;
        [cell.aaChartView aa_drawChartWithChartModel:chartModel];
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
        if (0==indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
            cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
//        _dossierTitles
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
    }else if (indexPath.section==4) {
        return 80.0;
    }else{
        return kNormalRowH;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"| 简介";
            break;
        case 1:
            return @"| 综合评价";
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
            return @"-";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}


- (AAChartModel *)configureAAChartModel {
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeAreaspline)//图表类型AAChartTypeColumn
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisVisibleSet(true)//设置 Y 轴是否可见
    .colorsThemeSet(@[@"#9b43b4",@"#ef476f",@"#ffd066",@"#04d69f",@"#25547c",])//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"%")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .yAxisGridLineWidthSet(@0)//y轴横向分割线宽度为0(即是隐藏分割线)
    .stackingSet(AAChartStackingTypeNormal)
    .borderRadiusSet(@1)
    .markerRadiusSet(@2)//设置折线连接点宽度为0,即是隐藏连接点
    .yAxisGridLineWidthSet(@0)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"本基金")
                 .dataSet(@[@17.0, @16.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3, @18.3, @13.9, @9.6]),
                 AAObject(AASeriesElement)
                 .nameSet(@"沪深300")
                 .dataSet(@[@1.2, @3.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @7.5])
                 ]);
    return aaChartModel;
}

- (NSArray *)configureTheConstraintArrayWithItem:(UIView *)view1 toItem:(UIView *)view2 {
    return  @[[NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeLeft
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeLeft
                                          multiplier:1.0
                                            constant:0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeRight
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeRight
                                          multiplier:1.0
                                            constant:0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                            constant:0],
              
              ];
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
