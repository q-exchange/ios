//
//  PayWaysTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/23.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "PayWaysTableViewCell.h"

@implementation PayWaysTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
