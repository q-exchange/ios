//
//  ReturnHistoryTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ReturnHistoryTableViewCell.h"

@implementation ReturnHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.statusBtn setTitle:LocalizationKey(@"Returned") forState:UIControlStateNormal];
    self.amountLabel.text = LocalizationKey(@"amount");
    self.timeLabel.text = LocalizationKey(@"time");
    self.rateLabel.text = LocalizationKey(@"Interest");
}

- (void)setModel:(LeverWalletModel *)model{
    _model = model;
    [self layoutUI];
    self.coinLabel.text = model.LeverCoin.symbol;
    self.amountValueLabel.text = [ToolUtil reviseString:model.amount];
    self.timeValueLabel.text = model.createTime;
    self.rateValueLabel.text = [ToolUtil reviseString:model.interest];
}

- (void)layoutUI{
    self.upView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    self.coinLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    [self.statusBtn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateNormal];

    self.rateLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.amountLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.timeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.rateValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.amountValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.timeValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
