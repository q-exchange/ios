//
//  IntegralRecordTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/4/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IntegralRecordTableViewCell.h"

@implementation IntegralRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.typeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.countLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.timeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
