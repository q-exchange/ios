//
//  CurrencyrecordTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/7.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "CurrencyrecordTableViewCell.h"

@implementation CurrencyrecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Presenttime.text = LocalizationKey(@"Presenttime");
    self.Presentmoney.text = LocalizationKey(@"poundage");
    self.Presentaddress.text = LocalizationKey(@"PresentAdd");
    self.PresentNum.text = LocalizationKey(@"PresentNum");

    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.typelabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.statuelabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.PresentNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Presenttime.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Presentmoney.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Presentaddress.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.timelabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.addresslabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.numlabel.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.freelabel.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
