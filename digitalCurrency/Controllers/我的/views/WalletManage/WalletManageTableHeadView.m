//
//  WalletManageTableHeadView.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/12.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "WalletManageTableHeadView.h"

@implementation WalletManageTableHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutUI{
    self.selectBtnLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"hidden0Currency" value:nil table:@"English"];

    
    self.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    self.textField.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.textField.layer.cornerRadius = 5.0f;
    self.textField.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.masksToBounds = YES;
    self.textField.tintColor = [UIColor blueColor];
    self.textField.placeholder = LocalizationKey(@"searchAssets");
    self.textField.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.textField.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.textField.font = [UIFont systemFontOfSize:12];
    self.textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.selectBtnLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
}

-(WalletManageTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WalletManageTableHeadView" owner:nil options:nil];
    WalletManageTableHeadView *tableView=[nibView objectAtIndex:0];
    tableView.frame=Rect;
    return tableView;
}


@end
