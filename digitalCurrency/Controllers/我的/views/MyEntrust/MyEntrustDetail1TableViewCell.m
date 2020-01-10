//
//  MyEntrustDetail1TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/23.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "MyEntrustDetail1TableViewCell.h"

@implementation MyEntrustDetail1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLabelTitleWidth.constant = (kWindowW - 20)/3;
    self.dealDetailLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"dealDetail" value:nil table:@"English"];
    // Initialization code
    [self layoutUI];
}

- (void)layoutUI
{
    self.dealDetailLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.coinType.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    self.dealNumTitle.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.dealPerPriceTitle.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.dealTotalNumTitle.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.dealNumData.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.dealPerPriceData.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.dealTotalNumData.textColor = QDThemeManager.currentTheme.themeMainTextColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
