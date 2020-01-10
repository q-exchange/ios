//
//  MyBillTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "MyBillTableViewCell.h"

@implementation MyBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.billStatus.clipsToBounds = YES;
    self.billStatus.layer.cornerRadius = 4;
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    // Initialization code
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.userName.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.coinNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.payStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.priceNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
