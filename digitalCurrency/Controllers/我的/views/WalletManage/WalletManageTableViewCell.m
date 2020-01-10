//
//  WalletManageTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "WalletManageTableViewCell.h"

@implementation WalletManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.availableLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"availableCoin" value:nil table:@"English"];
    self.freezeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"freezeCoin" value:nil table:@"English"];
    self.lockingLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Assetstoreleased" value:nil table:@"English"];
}

- (void)setFinModel:(ZTFinRecordModel *)finModel{
    _finModel = finModel;
    self.coinType.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.availableLabel.text = LocalizationKey(@"amount");
    self.freezeLabel.text = LocalizationKey(@"Status");
    self.lockingLabel.text = LocalizationKey(@"time");
    
    self.availableNum.text = finModel.amount;
    self.freezeNum.text = finModel.fee;
    self.lockingNum.text = finModel.createTime;
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    
    self.availableLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.freezeLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.lockingLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;

    self.availableNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.freezeNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.lockingNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
}

- (void)setModel:(WalletManageModel *)model{
    _model = model;
    self.coinType.text = model.coin.unit;
    
    self.availableLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"availableCoin" value:nil table:@"English"];
    self.freezeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"freezeCoin" value:nil table:@"English"];
    self.lockingLabel.text = [NSString stringWithFormat:@"%@(CNY)",LocalizationKey(@"assert_Conversion")];
    
    self.availableNum.text = [ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:model.balance]];
    self.freezeNum.text = [ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:model.frozenBalance]];
    
    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:model.balance];
    NSDecimalNumber *cnyRate = [[NSDecimalNumber alloc] initWithString:model.coin.cnyRate];
    
    self.lockingNum.text = [ToolUtil interceptTheTwoBitsAfterDecimalPoint:[ToolUtil reviseString:[[[balance decimalNumberByAdding:[[NSDecimalNumber alloc] initWithString:model.frozenBalance]] decimalNumberByMultiplyingBy:cnyRate withBehavior:handle] stringValue]]];
    
    
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    
    self.availableLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.freezeLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.lockingLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;

    self.availableNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.freezeNum.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.lockingNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
}

@end
