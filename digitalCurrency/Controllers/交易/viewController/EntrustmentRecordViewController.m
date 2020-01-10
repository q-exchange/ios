//
//  EntrustmentRecordViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/6.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "EntrustmentRecordViewController.h"
#import "commissionViewController.h"
#import "HistoryTransactionEntrustViewController.h"
#import "DownTheTabs.h"
#import "HomeNetManager.h"
@interface EntrustmentRecordViewController ()<UIScrollViewDelegate, JXCategoryViewDelegate>
{
    NSArray *_titles;
    NSInteger _currentIndex;
    DownTheTabs *_tabs;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *symbols;

@property (nonatomic, strong) UIView *upView;

@end

@implementation EntrustmentRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[LocalizationKey(@"Current"), LocalizationKey(@"HistoricalCurrent")];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.upView];
    [self.view addSubview:self.scrollView];
    [self setChildController];
    
    if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
        [self RightsetupNavgationItemWithpictureName:@"筛选黑"];
    }else{
        [self RightsetupNavgationItemWithpictureName:@"筛选白"];
    }

}

- (void)RighttouchEvent{
    if (_tabs) {
        [_tabs removeFromSuperview];
        _tabs = nil;
        return;
    }
    if (self.symbols.count == 0) {
        [self getData];
        return;
    }

//    self.navigationItem.rightBarButtonItem.enabled = NO;

    DownTheTabs *tabs = [[DownTheTabs alloc] initEntrustTabsWithContainerView:self.view Symbols:self.symbols];
    _tabs = tabs;
    tabs.dismissBlock = ^{
//        self.navigationItem.rightBarButtonItem.enabled = YES;
    };
    tabs.entrustBlock = ^(NSString *symbol, NSString *type, NSString *direction, NSString *startTime, NSString *endTime) {
        if (_currentIndex == 1) {
            NSDictionary *param = @{@"symbol":symbol, @"type":type, @"direction":direction, @"startTime":startTime, @"endTime":endTime, @"pageNo":@"1", @"pageSize":@"10"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"historyEntrust" object:param];
        }else{
            NSDictionary *param = @{@"symbol":symbol, @"type":type, @"direction":direction, @"startTime":startTime, @"endTime":endTime, @"pageNo":@"1", @"pageSize":@"10"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Querythecurrent" object:param];

        }
//        self.navigationItem.rightBarButtonItem.enabled = YES;
    };

}

- (void)setChildController
{
    //添加子控制器
    commissionViewController *comVC = [[commissionViewController alloc] init];
    comVC.view.frame = CGRectMake(0, 0, kWindowW, self.scrollView.frame.size.height);
    comVC.symbol = self.symbol;
    [self addChildViewController:comVC];
    [self.scrollView addSubview:comVC.view];

    HistoryTransactionEntrustViewController *histiroVC = [[HistoryTransactionEntrustViewController alloc] init];
    histiroVC.view.frame = CGRectMake(kWindowW, 0, kWindowW, self.scrollView.frame.size.height);
    histiroVC.symbol = self.symbol;
    [self addChildViewController:histiroVC];
    [self.scrollView addSubview:histiroVC.view];
}

- (void)recordAction:(NSInteger)tag{
    
    
    // 1 计算滚动的位置
    CGFloat offsetX = tag * self.view.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:tag];
}

#pragma mark - UIScrollViewDelegate
- (void)showVc:(NSInteger)index {
    _currentIndex = index;
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 1.添加子控制器view
    [self recordAction:index];
}
#pragma mark - 获取所有缩略详情
-(void)getData{
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        [self.symbols removeAllObjects];
        NSLog(@"获取所有缩略详情 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)resPonseObj;
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    [self.symbols addObject:dic[@"symbol"]];
                }];
            }else{
                
            }
        }else{

        }
    }];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self recordAction:index];

}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(kWindowW * _titles.count, 0);
        _scrollView.frame=CGRectMake(0, 40, kWindowW, kWindowH-NEW_NavHeight - 40);
        _scrollView.scrollEnabled = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (NSMutableArray *)symbols{
    if (!_symbols) {
        _symbols = [NSMutableArray arrayWithCapacity:0];
    }
    return _symbols;
}

- (UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 40)];
        _upView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        JXCategoryTitleView *titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
//        titleCategoryView.contentEdgeInsetLeft = 15;
        titleCategoryView.titleColor = QDThemeManager.currentTheme.themeMainTextColor;
        titleCategoryView.titleSelectedColor = QDThemeManager.currentTheme.themeTitleTextColor;
        titleCategoryView.delegate = self;
        titleCategoryView.titleColorGradientEnabled = YES;
        titleCategoryView.titleLabelZoomEnabled = YES;
        titleCategoryView.titleLabelZoomScale = 1.45;
        titleCategoryView.cellWidthZoomEnabled = YES;
        titleCategoryView.cellWidthZoomScale = 1.45;
        titleCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        titleCategoryView.selectedAnimationEnabled = YES;
        titleCategoryView.titleLabelVerticalOffset = 1;
        titleCategoryView.titleLabelZoomSelectedVerticalOffset = 3;
        titleCategoryView.titles = @[LocalizationKey(@"Alldelegate"), LocalizationKey(@"historyrecord")];
        [_upView addSubview:titleCategoryView];
    }
    return _upView;
}


@end
