//
//  Adversiting3TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/24.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "Adversiting3TableViewCell.h"

@implementation Adversiting3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLabel.font = self.centerLabel.font = self.rightLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.centerLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
