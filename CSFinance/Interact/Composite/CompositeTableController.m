//
//  CompositeTableController.m
//  CSFinance
//
//  Created by csco on 2018/4/20.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "CompositeTableController.h"
#import "ICCollectCellA.h"
#import "ICCollectCellB.h"
#import "ICTableMoreHeader.h"

@interface CompositeTableController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray * _headers;
}
@property (weak, nonatomic) IBOutlet UIView * scrollHeader;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionView * collectionViewB;
@property (nonatomic, strong) NSMutableArray * hotItems;

@end

@implementation CompositeTableController
-(UICollectionView *) collectionView
{
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(1.0, 2.5, 1.0, 2.5);
        layout.itemSize = CGSizeMake(kScreenW*0.7, 195.0);
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.4) collectionViewLayout:layout];
        //        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collect_hot"];
        [_collectionView registerNib:[UINib nibWithNibName:@"ICCollectCellA" bundle:nil] forCellWithReuseIdentifier:@"hot_collect"];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.pagingEnabled = YES;
        //        _collectionView.allowsMultipleSelection = YES; //多选
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(UICollectionView *)collectionViewB
{
    if (nil == _collectionViewB) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(1.0, 2.5, 1.0, 2.5);
        layout.itemSize = CGSizeMake(kScreenW*0.45, 100.0);
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionViewB = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.4) collectionViewLayout:layout];
        //        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collect_hot"];
        [_collectionViewB registerNib:[UINib nibWithNibName:@"ICCollectCellB" bundle:nil] forCellWithReuseIdentifier:@"image_collect"];
        _collectionViewB.backgroundColor = [UIColor lightGrayColor];
        _collectionViewB.pagingEnabled = YES;
        //        _collectionView.allowsMultipleSelection = YES; //多选
        _collectionViewB.delegate = self;
        _collectionViewB.dataSource = self;
    }
    return _collectionViewB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hotItems = [NSMutableArray array];
    //    [_hotItems addObjectsFromArray:@[@""]];
    self.tableView.tableHeaderView = self.scrollHeader;
    [self.tableView registerNib:[UINib nibWithNibName:@"ICTableMoreHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ICTableMoreHeader"];
    
    _headers = @[@"证券头条", @"近期路演", @"热门直播", @"近期沙龙",@"热议观点", @"财经热门"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 5;
    }else if(section==1){
        return 3;
    }else if(section==2){
        return 1;
    }else if(section==3){
        return 1;
    }else{
        return 4;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString * reuseid = @"";
    if (indexPath.section==0) {
        reuseid = @"item";
    }else if(indexPath.section==1){
        reuseid = @"video";
    }else if(indexPath.section==2){
        reuseid = @"collect";
    }else if(indexPath.section==3){
        reuseid = @"collectB";
    }else{
        reuseid = @"item";
    }
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    if (indexPath.section==2) {
        if (cell.contentView.subviews.count<1) {
            [self.collectionView setFrame:cell.contentView.bounds];
            [cell.contentView addSubview:self.collectionView];
        }
    }else if(indexPath.section==3){
        if (cell.contentView.subviews.count<1) {
            [self.collectionViewB setFrame:cell.contentView.bounds];
            [cell.contentView addSubview:self.collectionViewB];
        }
    }else{
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 70.0;
    }else if (indexPath.section==1){
        return 150.0;
    }else if (indexPath.section==2){
        return 200.0;
    }else if (indexPath.section==3){
        return 100.0;
    }else{
        return 70.0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ICTableMoreHeader * header =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ICTableMoreHeader"];
    header.titleLabel.text = _headers[section];
    header.actionhandle= ^(){
        NSLog(@"XXXX");
    };
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark-- UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        ICCollectCellA * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"hot_collect" forIndexPath:indexPath];
        cell.contentView.backgroundColor =[UIColor whiteColor];
        return cell;
    }else{
        ICCollectCellB * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"image_collect" forIndexPath:indexPath];
        cell.contentView.backgroundColor =[UIColor whiteColor];
        return cell;
    } 
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        return CGSizeMake(kScreenW*0.7, 195.0);
    }else{
        return CGSizeMake(kScreenW*0.45, 90.0);
    }
   
}

/*
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
*/

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
