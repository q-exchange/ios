//
//  TransactionViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/4/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "TransactionViewController.h"
#import "TradeViewController.h"
#import "FrenchCurrencyViewController.h"
#import "ZTFrenchOptionalViewController.h"

@interface TransactionViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate>
{
    UIView *_indView;
    UIView *_backView;
}
@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation TransactionViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *titles = @[LocalizationKey(@"AssetsCoin"), LocalizationKey(@"AssetsCurrency")];

    for (int i = 0; i < self.btnsArr.count; i++) {
        UIButton *btn = self.btnsArr[i];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData:)name:CURRENTSELECTED_SYMBOL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutNavFrame:) name:@"TradeScrollViewDrag" object:nil];


    self.navigationController.delegate = self;
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.mainScrollView];
//    [self layoutFrame];
    [self setChildViewControllers];
    [self layoutUI];
}


- (void)layoutNavFrame:(NSNotification *)notifi{
    NSString *dire = notifi.userInfo[@"direct"];
    if ([dire isEqualToString:@"up"]) {
        [UIView animateWithDuration:.3 animations:^{
            self.naviView.mj_y = -Height_NavBar;
            self.mainScrollView.mj_y = Height_StatusBar;
            self.mainScrollView.height = kWindowH - Height_StatusBar - Height_TabBar;
        } completion:^(BOOL finished) {

        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.naviView.mj_y = 0;
            self.mainScrollView.mj_y = Height_NavBar;
            self.mainScrollView.height = kWindowH - Height_NavBar - Height_TabBar;
        }];
    }
}

#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    [self layoutUI];
}


-(void)reloadShowData:(NSNotification *)notif{
    [self typeClick:self.btnsArr[0]];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    if ([vc isKindOfClass:NSClassFromString(@"TradeViewController")]) {
        TradeViewController *trade = (TradeViewController *)vc;
        [trade getPersonAllCollection];
    }
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.mainScrollView.frame.size.height);
}

#pragma mark - 加载试图控制器
- (void)setChildViewControllers{
    TradeViewController *indus = [[TradeViewController alloc] init];
    indus.view.frame = CGRectMake(0, 0, kWindowW, self.mainScrollView.frame.size.height);

    [self.mainScrollView addSubview:indus.view];
    [self addChildViewController:indus];
    
    FrenchCurrencyViewController *market = [[FrenchCurrencyViewController alloc] init];
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

- (void)layoutUI{
    self.naviView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    UIColor *color = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(43, 52, 69);
        }
        return UIColorMake(235, 235, 235);
    }];
    _backView.layer.borderColor = color.CGColor;
    for (int i = 0; i < self.btnsArr.count; i++) {
        UIButton *btn = self.btnsArr[i];
        [btn setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];
    }
    
}

- (void)typeClick:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if (tag == 1) {
        ZTFrenchOptionalViewController *cur = [[ZTFrenchOptionalViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:cur];
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        _indView.mj_x = 15 + (kWindowW * 3 / 2) * tag;
    } completion:^(BOOL finished) {
        
    }];
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    // 1 计算滚动的位置
    CGFloat offsetX = sender.tag * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:sender.tag];

}

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, Height_NavBar)];
        _naviView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kWindowW * 2) / 3, 30)];
        _backView = backView;
        backView.center = CGPointMake(kWindowW / 2, Height_StatusBar + 44 / 2);
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.cornerRadius = 5;
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = UIColorMake(43, 52, 69).CGColor;
        [_naviView addSubview:backView];
        
        NSArray *titles = @[LocalizationKey(@"AssetsCoin"), LocalizationKey(@"AssetsCurrency")];
        
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((backView.frame.size.width / titles.count) * i, 0, backView.frame.size.width / titles.count, 30);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.adjustsImageWhenHighlighted = NO;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];
            [btn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateSelected];
            btn.tag = i;
            [btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];

            [self.btnsArr addObject:btn];
        }
        
        UIView *indView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(backView.frame), CGRectGetMinY(backView.frame), backView.frame.size.width / titles.count, 30)];
        indView.backgroundColor = [UIColor clearColor];
        _indView = indView;
        indView.layer.cornerRadius = 5;
        indView.layer.borderWidth = 1;
        indView.layer.borderColor = QDThemeManager.currentTheme.themeSelectedTitleColor.CGColor;
        [_naviView addSubview:indView];
        [_naviView bringSubviewToFront:indView];
    }
    return _naviView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        // 创建底部滚动视图
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, Height_NavBar, kWindowW, kWindowH - Height_NavBar - Height_TabBar);
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
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

@end
