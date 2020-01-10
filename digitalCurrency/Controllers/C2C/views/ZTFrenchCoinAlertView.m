//
//  ZTFrenchCoinAlertView.m
//  digitalCurrency
//
//  Created by chu on 2019/10/16.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTFrenchCoinAlertView.h"

@implementation ZTFrenchCoinAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.upView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
    self.bottomView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    
    self.tradeTypeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.danjiaLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.danjiaValueLabel.textColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    
    [self.moneyBtn setTitleColor:QDThemeManager.currentTheme.themeDescriptionTextColor forState:UIControlStateNormal];
    [self.moneyBtn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];

    [self.amountBtn setTitleColor:QDThemeManager.currentTheme.themeDescriptionTextColor forState:UIControlStateNormal];
    [self.amountBtn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];

    
}

- (IBAction)money:(QMUIFillButton *)sender {
    
}

- (IBAction)amount:(QMUIFillButton *)sender {
    
}

- (IBAction)allAction:(UIButton *)sender {
    
}

- (IBAction)cancle:(UIButton *)sender {
    
}

- (IBAction)doneAction:(UIButton *)sender {
    
}

@end
