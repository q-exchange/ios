//
//  FrenchCurrencyViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/2.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "FrenchCurrencyViewController.h"

#import "YBPopupMenu.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"
#import "MineNetManager.h"

#import "ApplyBusinessViewController.h"
#import "BeingauditedBusViewController.h"
#import "SuccessBusViewController.h"
#import "AccountSettingInfoModel.h"
#import "FailBusinessViewController.h"

#import "MyAdvertisingViewController.h"//我的广告
#import "MyBillViewController.h"//我的订单
#import "PaymentAccountViewController.h"//付款方式
#import "TurnOutViewController.h"

#import "ZTFrenchQuickViewController.h"
#import "ZTFrenchOptionalViewController.h"

@interface FrenchCurrencyViewController ()<YBPopupMenuDelegate, UIScrollViewDelegate, JXCategoryViewDelegate>
{
    UIView *_indView;
    UIView *_backView;
}
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

@implementation FrenchCurrencyViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:UIColorMake(10, 81, 195)] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.businessBtn setTitle:self.businessBtnTitle forState:UIControlStateNormal];
    if ([YLUserInfo isLogIn]) {
        [self businessstatus];
        [self accountSettingData];
    }
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:QDThemeManager.currentTheme.themeBackgroundColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.businessBtnTitle = [[ChangeLanguage bundle] localizedStringForKey:@"ICanBuy" value:nil table:@"English"];
    [self.view addSubview:self.mainScrollView];
    [self setChildViewControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchView];

}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    if ([self.businessBtnTitle isEqualToString:LocalizationKey(@"ICanSell")]) {
        self.businessBtnTitle = LocalizationKey(@"ICanSell");
        [self.businessBtn setTitle:LocalizationKey(@"ICanSell") forState:UIControlStateNormal];
    }else{
        self.businessBtnTitle = LocalizationKey(@"ICanBuy");
        [self.businessBtn setTitle:LocalizationKey(@"ICanBuy") forState:UIControlStateNormal];
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
    ZTFrenchQuickViewController *indus = [[ZTFrenchQuickViewController alloc] init];
    indus.view.frame = CGRectMake(0, 0, kWindowW, self.mainScrollView.frame.size.height);
    [self.mainScrollView addSubview:indus.view];
    [self addChildViewController:indus];
    
    ZTFrenchOptionalViewController *market = [[ZTFrenchOptionalViewController alloc] init];
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

- (void)btnselect:(UIButton *)sender{
    [self changeNavBarWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        _indView.centerX = sender.centerX;
    }];
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            sender.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    [self typeClick:sender.tag];
}

- (void)changeNavBarWithTag:(NSInteger)tag{
    if (tag == 1) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:QDThemeManager.currentTheme.themeBackgroundColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
        self.switchView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;;
        _backView.layer.borderColor = QDThemeManager.currentTheme.themeMainTextColor.CGColor;
        _indView.layer.borderColor = QDThemeManager.currentTheme.themeSelectedTitleColor.CGColor;
        for (UIButton *btn in self.btnsArr) {
            [btn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];
            [btn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];
        }
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:UIColorMake(10, 81, 195)] forBarMetrics:UIBarMetricsDefault];
        self.switchView.backgroundColor = UIColorMake(10, 81, 195);
        _backView.layer.borderColor = UIColorMake(124, 167, 235).CGColor;
        _indView.layer.borderColor = [UIColor whiteColor].CGColor;
        for (UIButton *btn in self.btnsArr) {
            [btn setTitleColor:UIColorMake(124, 167, 235) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
    }
}

#pragma mark - 买卖切换
- (void)businessAction:(UIButton *)sender{
    __weak typeof(self)weakself = self;
    [LEEAlert actionsheet].config
    .LeeHeaderColor([UIColor whiteColor])
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"ICanBuy" value:nil table:@"English"];
        action.backgroundColor = [UIColor whiteColor];
        action.titleColor = RGBOF(0x333333);
        action.borderColor = BackColor;
        action.backgroundHighlightColor = [UIColor whiteColor];
        action.clickBlock = ^{
            weakself.businessBtnTitle = LocalizationKey(@"ICanBuy");
            [weakself.businessBtn setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ICanBuy" value:nil table:@"English"] forState:UIControlStateNormal];
            [weakself typeClick:0];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"ICanSell" value:nil table:@"English"];
        action.backgroundColor = [UIColor whiteColor];
        action.titleColor = RGBOF(0x333333);
        action.borderColor = BackColor;
        action.backgroundHighlightColor = [UIColor whiteColor];
        action.clickBlock = ^{
            weakself.businessBtnTitle = LocalizationKey(@"ICanSell");
            [weakself.businessBtn setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ICanSell" value:nil table:@"English"] forState:UIControlStateNormal];
            [weakself typeClick:1];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeCancel;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"];
        action.titleColor = RGBOF(0x333333);
        action.backgroundColor = [UIColor whiteColor];
        action.backgroundHighlightColor = [UIColor whiteColor];
    })
    .LeeShow();
}
#pragma mark - 更多
- (void)moreAction:(UIButton *)sender{
    NSArray *namearray = @[LocalizationKey(@"postPurchaseAdvertising"),LocalizationKey(@"sellAdvertising"), LocalizationKey(@"myAdvertising"), LocalizationKey(@"myBill"), LocalizationKey(@"payMethods"), LocalizationKey(@"Transfer")];
    
    [YBPopupMenu showRelyOnView:sender titles:namearray icons:nil menuWidth:130 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.arrowDirection = YBPopupMenuArrowDirectionNone;
        popupMenu.delegate = self;
        popupMenu.textColor = RGBOF(0x333333);
        popupMenu.backColor = [UIColor whiteColor];
        
    }];
//    menu.maxVisibleCount = 6;
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
        return;
    }
    
    if (index == 3) {
        //我的订单
        MyBillViewController *billVC = [[MyBillViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:billVC];
    }
    if (index == 4) {
        //收款方式
        if (self.accountInfo == nil) {
            return;
        }
        //收款方式
        if (!self.realVerified) {
            [self.view makeToast:LocalizationKey(@"validateYourID") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if (!self.fundsVerified) {
            [self.view makeToast:LocalizationKey(@"bindingPwd") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        PaymentAccountViewController *payVC = [[PaymentAccountViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:payVC];
    }
    if (index == 5) {
        TurnOutViewController *turn = [[TurnOutViewController alloc] init];
        turn.unit = @"USDT";
        turn.from = AccountType_Coin;
        turn.to = AccountType_Curreny;
        [[AppDelegate sharedAppDelegate] pushViewController:turn];
        return;
    }
    if (index == 2) {
        //我的广告
        if (self.memberLevel == 2 || self.memberLevel == 4 || self.memberLevel == 5 || self.memberLevel == 6) {
            //我的广告
            MyAdvertisingViewController *advertisingVC = [[MyAdvertisingViewController alloc] init];
            advertisingVC.avatar=self.accountInfo.avatar;
            [[AppDelegate sharedAppDelegate] pushViewController:advertisingVC];
        }else{
            [self.view makeToast:LocalizationKey(@"Uncertifiedbusinesses") duration:1.5 position:CSToastPositionCenter];
            return;
        }
    }
    
    if (self.memberLevel != 2) {
        [self.view makeToast:LocalizationKey(@"Uncertifiedbusinesses") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (index == 0) {
        //购买
        AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:buyVC];
    }
    
    if (index == 1) {
        //出售
        AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:sellVC];
        
    }
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 40)];
        _headerView.backgroundColor = RGBOF(0xF5F5F5);
        
        UIButton *btn = [UIButton new];
        self.businessBtn = btn;
        [_headerView addSubview:btn];
        [btn addTarget:self action:@selector(businessAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:AppTextColor_666666 forState:UIControlStateNormal];
        [btn setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ICanBuy" value:nil table:@"English"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerView).with.offset(15);
            make.top.mas_equalTo(_headerView).with.offset(5);
            make.bottom.mas_equalTo(_headerView).with.offset(-5);
        }];
        
        UIButton *btn1 = [UIButton new];
        [_headerView addSubview:btn1];
        [btn1 setImage:[UIImage imageNamed:@"三角下标"] forState:UIControlStateNormal];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_right).with.offset(3);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(_headerView);
        }];
        
        UIButton *more = [UIButton new];
        [more addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:more];
        [more setImage:[UIImage imageNamed:@"三点"] forState:UIControlStateNormal];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headerView).with.offset(-15);
            make.top.mas_equalTo(_headerView).with.offset(5);
            make.bottom.mas_equalTo(_headerView).with.offset(-5);
        }];
    }
    return _headerView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        // 创建底部滚动视图
        self.mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar);
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

- (UIView *)switchView{
    if (!_switchView) {
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
        _switchView.backgroundColor = UIColorMake(10, 81, 195);
        
        UIView *backView = [[UIView alloc] initWithFrame:_switchView.bounds];
        _backView = backView;
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.cornerRadius = 15;
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = UIColorMake(124, 167, 235).CGColor;
        [_switchView addSubview:backView];
        
        NSArray *titles = @[LocalizationKey(@"fast"), LocalizationKey(@"C2C")];
        
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((110 / titles.count) * i, 0, 110 / titles.count, 30);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.adjustsImageWhenHighlighted = NO;
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorMake(124, 167, 235) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.tag = i;
            if (i == 0){
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(btnselect:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];

            [self.btnsArr addObject:btn];
        }
        
        UIView *indView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110/2, 30)];
        indView.backgroundColor = [UIColor clearColor];
        _indView = indView;
        indView.layer.cornerRadius = 15;
        indView.layer.borderWidth = 1;
        indView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_switchView addSubview:indView];
        [_switchView bringSubviewToFront:indView];
    }
    return _switchView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

@end
