//
//  IEOViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/6.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEOViewController.h"
#import "ZJScrollPageView.h"
#import "IEOChildViewController.h"
#import "IEORecordViewController.h"

@interface IEOViewController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation IEOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"IEO");
    self.titles = @[LocalizationKey(@"IEOStatus_all"), LocalizationKey(@"IEOStatus_Preheating"), LocalizationKey(@"IEOStatus_Ongoing"), LocalizationKey(@"IEOStatus_Completed")];
    [self loadSegMent];
    [self rightBarItemWithTitle:LocalizationKey(@"IEORecord")];
}

- (void)RighttouchEvent{
    IEORecordViewController *record = [[IEORecordViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:record];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            childVc = [[IEOChildViewController alloc] initWithStatus:IEOStatus_All];
        }else if (index == 1){
            childVc = [[IEOChildViewController alloc] initWithStatus:IEOStatus_Preheating];
        }else if (index == 2){
            childVc = [[IEOChildViewController alloc] initWithStatus:IEOStatus_Ongoing];
        }else{
            childVc = [[IEOChildViewController alloc] initWithStatus:IEOStatus_Completed];
        }
    }
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)loadSegMent{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    //颜色渐变
    style.gradualChangeTitleColor = YES;
    //背景色
    style.segBackgroundColor = MainBackColor;
    //字体默认颜色
    style.normalTitleColor = AppTextColor_333333;
    //字体选中颜色
    style.selectedTitleColor = NavColor;
    //线条颜色
    style.scrollLineColor = NavColor;
    style.contentViewBounces = NO;
    style.autoAdjustTitlesWidth = YES;

    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kWindowH - Height_NavBar) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:_scrollPageView];
}

@end
