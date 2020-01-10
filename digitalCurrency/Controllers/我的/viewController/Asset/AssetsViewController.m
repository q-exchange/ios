//
//  AssetsViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsCoinViewController.h"
#import "AssetsCurrencyViewController.h"
#import "YBPopupMenu.h"
#import "CurrencyrecordViewController.h"
#import "ChargerecordViewController.h"
#import "WalletManageDetailViewController.h"
#import "IntegralRecordViewController.h"
#import "ZTAssetHeaderView.h"
#import "LTScrollView-Swift.h"
#import "AssetsContractViewController.h"


@interface AssetsViewController ()<UIScrollViewDelegate, YBPopupMenuDelegate,LTAdvancedScrollViewDelegate>
{
    NSArray *_titles;
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) ZTAssetHeaderView *headerView;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTAdvancedManager *managerView;
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) UIView *naviView;

@end

@implementation AssetsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [[ChangeLanguage bundle] localizedStringForKey:@"Myassets" value:nil table:@"English"];
    self.navigationController.delegate = self;

    _titles = @[LocalizationKey(@"assert_Exchange"), LocalizationKey(@"assert_Contract"), LocalizationKey(@"assert_C2C")];

    [self.view addSubview:self.managerView];
    [self.view addSubview:self.naviView];
    [self.view bringSubviewToFront:self.naviView];
    
    [self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toTabbar) name:@"CoinToTabbar" object:nil];
}

- (void)toTabbar{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabBarController setSelectedIndex:2];
    });
}

#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    [self.managerView removeFromSuperview];
    self.managerView = nil;
    [self.view addSubview:self.managerView];
    [self.naviView removeFromSuperview];
    [self.view addSubview:self.naviView];
    [self.view bringSubviewToFront:self.naviView];
    
    [self.headerView layoutUI];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    _titles = @[LocalizationKey(@"assert_Exchange"), LocalizationKey(@"assert_Contract"), LocalizationKey(@"assert_C2C")];

    [self.managerView removeFromSuperview];
    self.managerView = nil;
    [self.view addSubview:self.managerView];
    [self.naviView removeFromSuperview];
    [self.view addSubview:self.naviView];
    [self.view bringSubviewToFront:self.naviView];
    
    [self.headerView layoutUI];
}

-(void)glt_scrollViewOffsetY:(CGFloat)offsetY {
    self.naviView.alpha = offsetY / Height_NavBar;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

//MARK:--明细的点击事件
-(void)RighttouchEvent{
    NSArray *namearray = @[LocalizationKey(@"Currencyrecord"),LocalizationKey(@"Chargerecord"),LocalizationKey(@"Assetflow"),LocalizationKey(@"Integralrecord")];
    
    [YBPopupMenu showAtPoint:CGPointMake(kWindowW - 32, NEW_NavHeight - 15) titles:namearray icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.arrowDirection = YBPopupMenuArrowDirectionNone;
        popupMenu.delegate = self;
        popupMenu.textColor = RGBOF(0x333333);
        popupMenu.backColor = MainBackColor;
        
    }];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        //提币记录
        CurrencyrecordViewController *detailVC = [[CurrencyrecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 1) {
        //冲币记录
        ChargerecordViewController *detailVC = [[ChargerecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 2) {
        //资产流水
        WalletManageDetailViewController *detailVC = [[WalletManageDetailViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
    
    if (index == 3) {
        //积分记录
        IntegralRecordViewController *detailVC = [[IntegralRecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }
}


- (void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/getTotalAssets"];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"查询总资产 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *arr = responseResult[@"data"];
                    self.headerView.dataArr = arr;
                }
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

-(LTAdvancedManager *)managerView {
    if (!_managerView) {
        
        _managerView = [[LTAdvancedManager alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kWindowH - Height_TabBar) viewControllers:self.viewControllers titles:_titles currentViewController:self layout:self.layout titleView:nil headerViewHandle:^UIView * _Nonnull{
            return self.headerView;
        }];
        
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        
        /* 设置悬停位置 */
        _managerView.hoverY = Height_NavBar;
        
        /* 点击切换滚动过程动画 */
//        _managerView.isClickScrollAnimation = YES;
        
        /* 代码设置滚动到第几个位置 */
//        [_managerView scrollToIndexWithIndex:self.viewControllers.count - 1];
    }
    return _managerView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.isAverage = YES;
        _layout.isNeedScale = NO;
        _layout.titleFont = [UIFont systemFontOfSize:14];
        _layout.titleViewBgColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _layout.titleSelectColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
        _layout.titleColor = QDThemeManager.currentTheme.themeMainTextColor;
        _layout.bottomLineColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
        _layout.pageBottomLineColor = QDThemeManager.currentTheme.themeSeparatorColor;
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
    }
    return _layout;
}

- (ZTAssetHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [ZTAssetHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 114 + Height_NavBar)];
        [_headerView layoutUI];
    }
    return _headerView;
}

-(NSArray <UIViewController *> *)viewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    AssetsCoinViewController *coin = [[AssetsCoinViewController alloc] init];
    [testVCS addObject:coin];
    
    AssetsContractViewController *contract = [[AssetsContractViewController alloc] init];
    [testVCS addObject:contract];
    
    AssetsCurrencyViewController *currency = [[AssetsCurrencyViewController alloc] init];
    [testVCS addObject:currency];
    
    return testVCS.copy;
}

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, Height_NavBar)];
        _naviView.backgroundColor = UIColorMake(10, 81, 195);
        _naviView.alpha = 0;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, Height_StatusBar, kWindowW, 44)];
        label.text = LocalizationKey(@"tabbar5");
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [_naviView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar - 1, kWindowW, 1)];
        [_naviView addSubview:lineView];
    }
    return _naviView;
}
@end
