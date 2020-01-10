//
//  BorrowMoneyRecordTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BorrowMoneyRecordTableViewCell.h"
#import "MoneyReturnViewController.h"

@implementation BorrowMoneyRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.returBtn setTitle:LocalizationKey(@"return") forState:UIControlStateNormal];
    self.coinLabel.text = LocalizationKey(@"Currency");
    self.amountLabel.text = LocalizationKey(@"amount");
    self.timeLabel.text = LocalizationKey(@"ApplyTime");
    self.rateLabel.text = LocalizationKey(@"moneyRate");
    self.interestLabel.text = LocalizationKey(@"Unpaidinterest");
    self.noreturnLabel.text = LocalizationKey(@"UnreturnedQuantity");
}

- (void)setModel:(LeverWalletModel *)model{
    _model = model;
    [self layoutUI];
    self.symbolLabel.text = model.LeverCoin.symbol;
    self.accountTypeLabel.text = [NSString stringWithFormat:@"(%@)",LocalizationKey(@"AccountLever")];
    self.coinValueLabel.text = model.coin.unit;
    self.amountValueLabel.text = [ToolUtil reviseString:model.loanBalance];
    self.timeValueLabel.text = model.createTime;
    self.rateValueLabel.text = [NSString stringWithFormat:@"%@",[ToolUtil reviseString:model.interestRate]];
    self.interestValueLabel.text = [ToolUtil reviseString:model.accumulative];
    self.noreturnValueLabel.text = [ToolUtil reviseString:model.amount];
    //0未归还 1已归还
    if ([model.repayment isEqualToString:@"0"]) {
        [self.returBtn setTitle:LocalizationKey(@"return") forState:UIControlStateNormal];
    }else{
        [self.returBtn setTitle:LocalizationKey(@"Returned") forState:UIControlStateNormal];
    }
}

- (void)layoutUI{
    self.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    self.symbolLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.accountTypeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    

    self.coinLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.amountLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.timeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.coinValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.amountValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.timeValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.interestLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.rateLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.noreturnLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.interestValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.rateValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.noreturnValueLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
}

- (IBAction)returAction:(UIButton *)sender {
    if ([self.model.repayment isEqualToString:@"0"]) {
        MoneyReturnViewController *retu = [[MoneyReturnViewController alloc] init];
        retu.model = self.model;
        [[AppDelegate sharedAppDelegate] pushViewController:retu];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
