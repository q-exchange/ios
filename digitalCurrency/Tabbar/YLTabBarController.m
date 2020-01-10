//
//  YLTabBarController.m
//  BaseProject
//
//  Created by YLCai on 16/11/23.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import "YLTabBarController.h"
#import "YLNavigationController.h"
#import "HomeViewController.h"
#import "MarketViewController.h"
#import "TransactionViewController.h"
#import "AssetsViewController.h"
#import "ZTContractViewController.h"

@interface YLTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation YLTabBarController

+(YLTabBarController *)defaultTabBarContrller{
    static YLTabBarController *tabBar = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[YLTabBarController alloc] init];
    });
    return tabBar;
}

- (void)didInitialize NS_REQUIRES_SUPER{
    [super didInitialize];
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.translucent = NO;

    [self dropShadowWithOffset:CGSizeMake(0, 0)
                        radius:5
                         color:[UIColor blackColor]
                       opacity:0.14];
    //添加子控制器
    [self initTabbar];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.viewControllers[4]) {
        if (![YLUserInfo isLogIn]) {
            [self showLoginViewController];
            return NO;
        }
        return YES;
    }
    if (viewController == self.viewControllers[3]) {
        [[UIApplication sharedApplication].keyWindow makeToast:LocalizationKey(@"not_yet_open") duration:1.5 position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    self.tabBar.clipsToBounds = NO;
}

-(void)initTabbar{
    HomeViewController   *Section1VC = [[HomeViewController alloc] init];
    Section1VC.tabBarItem = [QDUIHelper tabBarItemWithTitle:LocalizationKey(@"tabbar1") image:UIImageMake(@"shouye_un") selectedImage:UIImageMake(@"shouye_checked") tag:0];
    MarketViewController *Section2VC = [[MarketViewController alloc] init];
    Section2VC.tabBarItem = [QDUIHelper tabBarItemWithTitle:LocalizationKey(@"tabbar2") image:UIImageMake(@"hangqiang_un") selectedImage:UIImageMake(@"hangqiang_checked") tag:1];
    TransactionViewController  *Section3VC = [[TransactionViewController alloc] init];
    Section3VC.tabBarItem = [QDUIHelper tabBarItemWithTitle:LocalizationKey(@"tabbar3") image:UIImageMake(@"bibi_un") selectedImage:UIImageMake(@"bibi_checked") tag:2];
    ZTContractViewController   *Section4VC = [[ZTContractViewController alloc] init];
    Section4VC.tabBarItem = [QDUIHelper tabBarItemWithTitle:LocalizationKey(@"tabbar4") image:UIImageMake(@"fabi_un") selectedImage:UIImageMake(@"fabi_checked") tag:4];
    
    AssetsViewController   *Section5VC = [[AssetsViewController alloc] init];
    Section5VC.tabBarItem = [QDUIHelper tabBarItemWithTitle:LocalizationKey(@"tabbar5") image:UIImageMake(@"wode_un") selectedImage:UIImageMake(@"wode_checked") tag:3];

    YLNavigationController *Section1Navi = [[YLNavigationController alloc] initWithRootViewController:Section1VC];
    YLNavigationController *Section2Navi = [[YLNavigationController alloc] initWithRootViewController:Section2VC];
    YLNavigationController *Section3Navi = [[YLNavigationController alloc] initWithRootViewController:Section3VC];
    YLNavigationController *Section4Navi = [[YLNavigationController alloc] initWithRootViewController:Section4VC];
    YLNavigationController *Section5Navi = [[YLNavigationController alloc] initWithRootViewController:Section5VC];
    self.viewControllers = @[Section1Navi,Section2Navi,Section3Navi,Section4Navi,Section5Navi];
}


-(void)showLoginViewController{
    LoginViewController*loginVC=[[LoginViewController alloc]init];
    YLNavigationController *nav = [[YLNavigationController alloc]initWithRootViewController:loginVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
//重置tabar标题
-(void)resettabarItemsTitle{
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    item1.title=LocalizationKey(@"tabbar1");
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    item2.title=LocalizationKey(@"tabbar2");
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    item3.title=LocalizationKey(@"tabbar3");
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    item4.title=LocalizationKey(@"tabbar4");
    UITabBarItem *item5 = [tabBar.items objectAtIndex:4];
    item5.title=LocalizationKey(@"tabbar5");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
