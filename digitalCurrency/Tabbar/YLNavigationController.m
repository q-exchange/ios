//
//  YLNavigationController.m
//  BaseProject
//
//  Created by YLCai on 16/11/23.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import "YLNavigationController.h"
#import "AnimationContoller.h"
@interface YLNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@property (nonatomic, strong) UIButton *backBtn;

@property(strong,nonatomic)UIImageView * screenshotImgView;
@property(strong,nonatomic)UIView * coverView;
@property(strong,nonatomic)NSMutableArray * screenshotImgs;


@property(nonatomic,strong)UIImage * nextVCScreenShotImg;

@property(nonatomic,strong)AnimationContoller * animationController;
@end

@implementation YLNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            if ([identifier isEqualToString:QDThemeIdentifierDark]) {
                return UIIMAGE(@"返回白");
            }
            return UIIMAGE(@"返回黑");
        }] forState:UIControlStateNormal];
        viewController.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)popAction{
    [self popViewControllerAnimated:YES];
}

- (void)didInitialize NS_REQUIRES_SUPER{
    [super didInitialize];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;//默认为YES
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
