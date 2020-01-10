//
//  ZTFrenchQuickViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/10/14.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTFrenchQuickViewController.h"
#import "AccountSettingInfoModel.h"
#import "MineNetManager.h"
#import "BuyCoinsChildViewController.h"
#import "SellCoinsChildViewController.h"

@interface ZTFrenchQuickViewController ()< UIScrollViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) UIView *upView;
@property (nonatomic,assign)NSInteger memberLevel;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;//用户状态
@property (nonatomic,copy)NSString *reasonstr;
@property (nonatomic,copy)NSString *businessBtnTitle;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *businessBtn;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic,assign)BOOL fundsVerified;
@property (nonatomic,assign)BOOL realVerified;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, strong) UIView *switchView;
@end

@implementation ZTFrenchQuickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.upView];
    [self.view addSubview:self.mainScrollView];
    [self setChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([YLUserInfo isLogIn]) {
        [self businessstatus];
        [self accountSettingData];
    }
}

//验证用户是否为验证商家
-(void)businessstatus{
    __weak typeof(self)weakself = self;
    [MineNetManager userbusinessstatus:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                weakself.memberLevel = [[[resPonseObj objectForKey:@"data"] objectForKey:@"certifiedBusinessStatus"] integerValue];
                weakself.reasonstr = [[resPonseObj objectForKey:@"data"] objectForKey:@"detail"];
            }else{
                [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    __weak typeof(self)weakself = self;
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                weakself.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                if ([weakself.accountInfo.fundsVerified isEqualToString:@"1"]) {
                    weakself.fundsVerified = YES;
                }else{
                    weakself.fundsVerified = NO;
                }
                
                if ([weakself.accountInfo.realVerified isEqualToString:@"1"]) {
                    //审核成功
                    weakself.realVerified = YES;
                }else{
                    weakself.realVerified = NO;
                }
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
            }else{
                [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [weakself.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.mainScrollView.frame.size.height);
}

#pragma mark - 加载试图控制器
- (void)setChildViewControllers{
    BuyCoinsChildViewController *indus = [[BuyCoinsChildViewController alloc] init];
    indus.view.frame = CGRectMake(0, 0, kWindowW, self.mainScrollView.frame.size.height);
    [self.mainScrollView addSubview:indus.view];
    [self addChildViewController:indus];
    
    SellCoinsChildViewController *market = [[SellCoinsChildViewController alloc] init];
    [self addChildViewController:market];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 1.添加子控制器view
    [self showVc:index];
    
    //    [self navTitleBtnSel:(UIButton *)[self.navTitleView viewWithTag:index + 10086]];
}

- (void)typeClick:(NSInteger)tag{

    // 1 计算滚动的位置
    CGFloat offsetX = tag * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);

    // 2.给对应位置添加对应子控制器
    [self showVc:tag];
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self typeClick:index];
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        // 创建底部滚动视图
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.upView.frame), kWindowW, kWindowH - Height_NavBar - self.upView.frame.size.height);
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.scrollEnabled = NO;
        // 开启分页
        _mainScrollView.pagingEnabled = YES;
        // 没有弹簧效果
        _mainScrollView.bounces = NO;
        // 隐藏水平滚动条
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _upView.backgroundColor = UIColorMake(10, 81, 195);
        JXCategoryTitleView *titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kWindowW / 2, 50)];
        titleCategoryView.titleColor = UIColorMake(124, 167, 235);
        titleCategoryView.titleSelectedColor = [UIColor whiteColor];
        titleCategoryView.delegate = self;
        titleCategoryView.titleColorGradientEnabled = YES;
        titleCategoryView.titleLabelZoomEnabled = YES;
        titleCategoryView.titleLabelZoomScale = 1.85;
        titleCategoryView.cellWidthZoomEnabled = YES;
        titleCategoryView.cellWidthZoomScale = 1.85;
        titleCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        titleCategoryView.selectedAnimationEnabled = YES;
        titleCategoryView.titleLabelZoomSelectedVerticalOffset = 3;
        titleCategoryView.titles = @[LocalizationKey(@"ICanBuy"), LocalizationKey(@"ICanSell")];
        [_upView addSubview:titleCategoryView];
        
        
    }
    return _upView;
}
@end
