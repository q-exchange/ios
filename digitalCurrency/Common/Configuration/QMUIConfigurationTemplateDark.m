//
//  QMUIConfigurationTemplate.m
//  qmui
//
//  Created by QMUI Team on 15/3/29.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QMUIConfigurationTemplateDark.h"

@implementation QMUIConfigurationTemplateDark

#pragma mark - <QMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    [super applyConfigurationTemplate];
    
    QMUICMI.keyboardAppearance = UIKeyboardAppearanceDark;
    
    QMUICMI.toolBarStyle = UIBarStyleBlack;
    
    #pragma mark - NavBar
    QMUICMI.navBarBackgroundImage = [[UIImage qmui_imageWithColor:UIColorMake(18, 31, 48)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    QMUICMI.navBarTitleColor = UIColorMake(207, 211, 233);                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 QMUINavigationTitleView 的默认文字颜色
    
    #pragma mark - TabBar
    QMUICMI.tabBarBackgroundImage = [[UIImage qmui_imageWithColor:UIColorMake(23, 40, 65)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    QMUICMI.tabBarShadowImageColor = UIColorMake(13, 22, 34);                          // TabBarShadowImageColor : UITabBar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    QMUICMI.tabBarItemTitleColor = UIColorMake(109, 134, 167);             // TabBarItemTitleColor : 未选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemTitleColorSelected = UIColorMake(24, 129, 211);                // TabBarItemTitleColorSelected : 选中的 UITabBarItem 的标题颜色
    QMUICMI.tabBarItemTitleFont = [UIFont systemFontOfSize:10];                              // TabBarItemTitleFont : UITabBarItem 的标题字体
    
    QMUICMI.sizeNavBarBackIndicatorImageAutomatically = NO;                    // SizeNavBarBackIndicatorImageAutomatically : 是否要自动调整 NavBarBackIndicatorImage 的 size 为 (13, 21)
//    QMUICMI.navBarBackIndicatorImage = [UIImage imageNamed:@"返回黑"];
    
}

// QMUI 2.3.0 版本里，配置表新增这个方法，返回 YES 表示在 App 启动时要自动应用这份配置表。仅当你的 App 里存在多份配置表时，才需要把除默认配置表之外的其他配置表的返回值改为 NO。
- (BOOL)shouldApplyTemplateAutomatically {
    [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];
    
    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:QDSelectedThemeIdentifier];
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName];
    if (result) {
        QMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <QDThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return UIColorMake(18, 31, 48);
}

- (UIColor *)themeBackgroundDescriptionColor {
    return UIColorMake(8, 23, 37);
}

- (UIColor *)themeBackgroundColorLighten {
    return UIColorMake(18, 31, 48);
}

- (UIColor *)themeBackgroundColorHighlighted {
    return UIColorMake(48, 49, 51);
}

- (UIColor *)themeTintColor {
    return UIColorTheme10;
}

- (UIColor *)themeTitleTextColor {
    return UIColorMake(207, 211, 233);
}

- (UIColor *)themeMainTextColor {
    return UIColorMake(97, 116, 146);
}

- (UIColor *)themeDescriptionTextColor {
    return UIColorMake(62, 83, 108);
}

- (UIColor *)themeSelectedTitleColor{
    return UIColorMake(39, 127, 196);
}

- (UIColor *)themeBorderColor{
    return UIColorMake(45, 54, 71);
}

- (UIColor *)themePlaceholderColor {
    return UIColorMake(68, 82, 98);
}

- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeSeparatorColor {
    return UIColorMake(27, 42, 62);
}

- (NSString *)themeName {
    return QDThemeIdentifierDark;
}

@end
