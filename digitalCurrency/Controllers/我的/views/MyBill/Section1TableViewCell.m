//
//  Section1TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/4.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "Section1TableViewCell.h"

@implementation Section1TableViewCell

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
