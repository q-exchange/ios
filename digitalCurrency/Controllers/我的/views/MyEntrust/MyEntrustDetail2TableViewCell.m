//
//  MyEntrustDetail2TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/23.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "MyEntrustDetail2TableViewCell.h"

@implementation MyEntrustDetail2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLabelTitleWidth.constant = (kWindowW-20)/4;
    self.timeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"time" value:nil table:@"English"];
    self.dealPriceLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"dealPrice" value:nil table:@"English"];
    self.dealNum.text = [[ChangeLanguage bundle] localizedStringForKey:@"dealNum" value:nil table:@"English"];
    self.feeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"poundage" value:nil table:@"English"];
    // Initialization code
    [self layoutUI];
}

- (void)layoutUI
{
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    self.timeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.dealNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.dealPriceLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.feeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    self.timeData.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.dealNumData.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.dealPriceData.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.feeData.textColor = QDThemeManager.currentTheme.themeMainTextColor;

}

@end
