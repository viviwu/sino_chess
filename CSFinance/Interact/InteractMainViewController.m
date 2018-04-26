//
//  InteractMainViewController.m
//  CSFinance
//
//  Created by csco on 2018/4/10.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "InteractMainViewController.h"
#import "XWSegmentedControl.h"
#import "CompositeTableController.h"
#import "PodcastCollectionController.h"
#import "XWConsultViewController.h"
#import "WBStatusTimelineViewController.h"
#import "SalonCenterViewController.h"

@interface InteractMainViewController ()

@property (nonatomic, assign) CGFloat safeTop;

@property (nonatomic) XWSegmentedControl * segCtr;
@property (nonatomic, copy) NSArray<NSString*>* sectionTitles;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation InteractMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTitles = @[@"推荐", @"播客", @"问答", @"观点", @"沙龙"];
     
    _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles:self.sectionTitles];
    _segCtr.frame = CGRectMake(0, 50.0, kSelfVB_W-100.0, 35.0);
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
    self.navigationItem.titleView = _segCtr;
    
    self.safeTop=0;
    if (kDevice_Is_iPhoneX) {
        self.safeTop=88.0;
    }else{
        self.safeTop=64.0;
    }
    
    //    [self.view addSubview:_segCtr];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.safeTop, kSelfVB_W, kSelfVB_H)];
    self.scrollView.contentSize = CGSizeMake(kScreenW*5, 0);
    [self.view addSubview:self.scrollView];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self addSubViewControllers];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self segmentAction:_segCtr];
    [super viewDidAppear:animated];
}

- (void)segmentAction:(XWSegmentedControl *)sender
{
    NSInteger index = sender.selectedIndex;
    
    [self transChildViewControllerWith:index];
    [self.scrollView setContentOffset:CGPointMake(kScreenW*index, 0)];
    //    [self.scrollView scrollRectToVisible:CGRectMake(kScreenW*index, 0, kScreenW, kSelfVB_H) animated:YES];
}

- (void)addSubViewControllers{
    
    CompositeTableController * interact = [[UIStoryboard storyboardWithName:@"Interact" bundle:nil] instantiateViewControllerWithIdentifier:@"CompositeTableController"];
    PodcastCollectionController * podcast = [[UIStoryboard storyboardWithName:@"Podcast" bundle:nil] instantiateViewControllerWithIdentifier:@"PodcastCollectionController"];
    XWConsultViewController * consult = [[UIStoryboard storyboardWithName:@"Interact" bundle:nil] instantiateViewControllerWithIdentifier:@"XWConsultViewController"];
    UIViewController * opinion = [WBStatusTimelineViewController new];
    SalonCenterViewController * salon = [[SalonCenterViewController alloc]init];
    
    [interact.view setFrame:CGRectMake(0, 0, kScreenW, kSelfVB_H)];
    [podcast.view setFrame:CGRectMake(kScreenW, 0, kScreenW, kSelfVB_H)];
    [consult.view setFrame:CGRectMake(kScreenW*2, 0, kScreenW, kSelfVB_H)]; 
    [opinion.view setFrame:CGRectMake(kScreenW*3, 0, kScreenW, kSelfVB_H)];
    [salon.view setFrame:CGRectMake(kScreenW*4, 0, kScreenW, kSelfVB_H)];
    
    [self addChildViewController:interact];
    [self addChildViewController:consult];
    [self addChildViewController:podcast];
    [self addChildViewController:opinion];
    [self addChildViewController:salon]; 
    
    [self.scrollView addSubview:interact.view];
    [self.scrollView addSubview:consult.view];
    [self.scrollView addSubview:podcast.view];
    [self.scrollView addSubview:opinion.view];
    [self.scrollView addSubview:salon.view];
    
    self.scrollView.delegate = (id)self;
}

- (void)transChildViewControllerWith:(NSInteger)index{
    /*
    id vc = self.childViewControllers[index];
    UIView * view = [vc valueForKey:@"view"];
    [self.scrollView addSubview: view];
     */
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segCtr setSelectedSegmentIndex:page animated:YES];
    [self transChildViewControllerWith:page];
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
