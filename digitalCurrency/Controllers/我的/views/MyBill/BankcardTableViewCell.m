//
//  BankcardTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/23.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "BankcardTableViewCell.h"

@implementation BankcardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.bankNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.banknumlabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.bankname.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.banknamelabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.bankaddress.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.bankaddresslabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showmorecontent:(id)sender {
   
    self.showbut.selected = !self.showbut.selected;
    self.showBankBlock(self.showbut.selected);
    

}

@end
