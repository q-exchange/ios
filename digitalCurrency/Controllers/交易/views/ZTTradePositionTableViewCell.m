//
//  ZTTradePositionTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/10/14.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTTradePositionTableViewCell.h"

@implementation ZTTradePositionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)buyAction:(UIButton *)sender {
}

- (IBAction)sellAction:(UIButton *)sender {
}

- (IBAction)triggerAddAction:(UIButton *)sender {
}
- (IBAction)triggerSubAction:(UIButton *)sender {
}

- (IBAction)priceAddAction:(UIButton *)sender {
}
- (IBAction)priceSubAction:(id)sender {
}

- (IBAction)commitAction:(UIButton *)sender {
}
- (IBAction)bottomAction:(UIButton *)sender {
}

- (void)initLayer{
    self.tradeTypeView.layer.cornerRadius = 2;
    self.tradeTypeView.layer.borderWidth = 1;
    self.tradeTypeView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.tradeValueLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.trigger_view.layer.cornerRadius = 2;
    self.trigger_view.layer.borderWidth = 1;
    self.trigger_view.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.trigger_view_lineview1.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.trigger_view_lineview2.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.triggerTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.triggerTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.triggerTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.priceView.layer.cornerRadius = 2;
    self.priceView.layer.borderWidth = 1;
    self.priceView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.priceView_lineView1.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.priceView_lineView2.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.priceTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.priceTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.priceTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.amountView.layer.cornerRadius = 2;
    self.amountView.layer.borderWidth = 1;
    self.amountView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.amountTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.amountTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.amountTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
}

@end
