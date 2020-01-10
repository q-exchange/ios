//
//  ZTContractViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/10/14.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTContractViewController.h"

@interface ZTContractViewController ()

@end

@implementation ZTContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LocalizationKey(@"tabbar4");
    self.view.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    [self showEmptyViewWithText:LocalizationKey(@"not_yet_open") detailText:@"" buttonTitle:@"" buttonAction:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];

}

#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    self.view.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.emptyView.textLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
}

@end
