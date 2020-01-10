//
//  Section3TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/4.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "Section3TableViewCell.h"

@implementation Section3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
