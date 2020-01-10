//
//  AssetsLeverTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsLeverTableViewCell.h"

@implementation AssetsLeverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.coinType.text = LocalizationKey(@"currency");
    self.canUseLabel.text = LocalizationKey(@"usabel");
    self.borrowLabel.text = LocalizationKey(@"Borrowed");

}

- (void)setModel:(LeverAccountModel *)model{
    _model = model;
    self.symbolLabel.text = model.symbol;
    
    NSArray *list = model.leverWalletList;
    if (list.count == 2) {
        LeverWalletModel *coin = [list lastObject];
        LeverWalletModel *baseCoin = [list firstObject];
        self.coinSymbol.text = coin.coin.unit;
        NSDecimalNumber *coinBalance = [NSDecimalNumber decimalNumberWithString:coin.balance];
        NSDecimalNumber *coinLoanCount = [NSDecimalNumber decimalNumberWithString:model.coinLoanCount];
        self.coinSymbolUseLabel.text = model.isHidden?@"******":[ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:[coinBalance stringValue]]];
        self.coinSymbolBorrowLabel.text = model.isHidden?@"******":[ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:[coinLoanCount stringValue]]];
      
        self.baseSymbol.text = baseCoin.coin.unit;
        
        NSDecimalNumber *baseCoinBalance = [NSDecimalNumber decimalNumberWithString:baseCoin.balance];
        NSDecimalNumber *baseLoanCount = [NSDecimalNumber decimalNumberWithString:model.baseLoanCount];
        self.baseSymbolUseLabel.text = model.isHidden?@"******":[ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:[baseCoinBalance stringValue]]];
        self.baseSymbolBorrowLabel.text = model.isHidden?@"******":[ToolUtil interceptTheEightBitsAfterDecimalPoint:[ToolUtil reviseString:[baseLoanCount stringValue]]];
    }
    
    self.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    self.symbolLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.coinType.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.canUseLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.borrowLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;

    self.coinSymbol.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.baseSymbol.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.coinSymbolUseLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.baseSymbolUseLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.coinSymbolBorrowLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.baseSymbolBorrowLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
