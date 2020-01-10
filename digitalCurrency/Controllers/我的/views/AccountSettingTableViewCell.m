//
//  AccountSettingTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "AccountSettingTableViewCell.h"

@implementation AccountSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
