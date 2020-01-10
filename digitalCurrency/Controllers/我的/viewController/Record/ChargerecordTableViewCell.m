//
//  ChargerecordTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/7.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "ChargerecordTableViewCell.h"

@implementation ChargerecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Paymentdate.text = LocalizationKey(@"Paymenttime");
    self.Chargeaddress.text = LocalizationKey(@"Address");
    self.Amountrecharge.text = LocalizationKey(@"Amountrecharge");
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.typelabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.Paymentdate.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Chargeaddress.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Amountrecharge.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.timelabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.addresslabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.numlabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
