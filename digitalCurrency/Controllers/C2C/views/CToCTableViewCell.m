//
//  CToCTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2018/8/2.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "CToCTableViewCell.h"

@implementation CToCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buyBtn.layer.cornerRadius = 5;
    self.headLabel.layer.cornerRadius = self.headLabel.frame.size.height / 2;
    self.headLabel.layer.masksToBounds = YES;
    self.headLabel.backgroundColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    self.headLabel.textColor = [UIColor whiteColor];
    
    [self layoutUI];
}
- (IBAction)buyAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

- (void)setCoinUserInfoModel:(CoinUserInfoModel *)coinUserInfoModel{
    _coinUserInfoModel = coinUserInfoModel;
    [self layoutUI];
    
    self.headLabel.text = [_coinUserInfoModel.memberName substringToIndex:1];
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@**",[_coinUserInfoModel.memberName substringToIndex:1]];
    self.tradeNum.text = [NSString stringWithFormat:@"%@",_coinUserInfoModel.transactions];
    self.limitNum.text = [NSString stringWithFormat:@"%@ %@-%@CNY",[[ChangeLanguage bundle] localizedStringForKey:@"limit" value:nil table:@"English"],_coinUserInfoModel.minLimit,_coinUserInfoModel.maxLimit];

    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:_coinUserInfoModel.price];
    NSLog(@"%@", [decNumber stringValue]);
    self.priceLabel.text = [NSString stringWithFormat:@"%@CNY",[decNumber stringValue]];
    NSArray  *array = [_coinUserInfoModel.payMode componentsSeparatedByString:@","];
    [self cellForArray:array];
    self.coinNum.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"amount"),[ToolUtil judgeStringForDecimalPlaces:_coinUserInfoModel.remainAmount]];
    self.danjiaPriceLabel.text = LocalizationKey(@"UnitPrice");
}

-(void)cellForArray:(NSArray *)payArr{
    if (payArr.count == 1) {
        if ([payArr[0] isEqualToString:@"支付宝"]) {
            self.payImageView1WidthConstraint.constant = 16;
            self.leftConstraint1.constant = 0;
            self.payImageView2WidthCOnstraint.constant = 0;
            self.left2Constraint.constant = 0;
            self.payImageView3WidthConstraint.constant = 0;
        }else if ([payArr[0] isEqualToString:@"微信"]){
            self.payImageView1WidthConstraint.constant = 0;
            self.leftConstraint1.constant = 0;
            self.payImageView2WidthCOnstraint.constant = 16;
            self.left2Constraint.constant = 0;
            self.payImageView3WidthConstraint.constant = 0;
        }else{
            self.payImageView1WidthConstraint.constant = 0;
            self.leftConstraint1.constant = 0;
            self.payImageView2WidthCOnstraint.constant = 0;
            self.left2Constraint.constant = 0;
            self.payImageView3WidthConstraint.constant = 16;
        }
    }else if (payArr.count == 2){
        if ([payArr[0] isEqualToString:@"支付宝"]) {
            self.payImageView1WidthConstraint.constant = 16;
            if ([payArr[1] isEqualToString:@"微信"] ) {
                self.payImageView2WidthCOnstraint.constant = 16;
                self.leftConstraint1.constant = 5;
                self.payImageView3WidthConstraint.constant = 0;
                self.left2Constraint.constant = 0;
            }else {
                self.payImageView2WidthCOnstraint.constant = 0;
                self.leftConstraint1.constant = 0;
                self.payImageView3WidthConstraint.constant = 16;
                self.left2Constraint.constant = 5;
            }
        }else if ([payArr[0] isEqualToString:@"微信"]){
            self.payImageView2WidthCOnstraint.constant = 16;
            if ([payArr[1] isEqualToString:@"支付宝"]) {
                self.payImageView1WidthConstraint.constant = 16;
                self.payImageView3WidthConstraint.constant = 0;
                self.left2Constraint.constant = 0;
                self.leftConstraint1.constant = 5;

            }else{
                self.payImageView1WidthConstraint.constant = 0;
                self.payImageView3WidthConstraint.constant = 16;
                self.left2Constraint.constant = 5;
                self.leftConstraint1.constant = 0;
            }
        }else{
            self.payImageView3WidthConstraint.constant = 16;
            self.left2Constraint.constant = 5;
            if ([payArr[1] isEqualToString:@"支付宝"]) {
                self.payImageView1WidthConstraint.constant = 16;
                self.payImageView2WidthCOnstraint.constant = 0;
                self.leftConstraint1.constant = 0;
            }else{
                self.payImageView1WidthConstraint.constant = 0;
                self.payImageView2WidthCOnstraint.constant = 16;
                self.leftConstraint1.constant = 0;
            }
        }
    }else if (payArr.count == 3){
        self.payImageView1WidthConstraint.constant = 16;
        self.leftConstraint1.constant = 5;
        self.payImageView2WidthCOnstraint.constant = 16;
        self.left2Constraint.constant = 5;
        self.payImageView3WidthConstraint.constant = 16;
        
    }else{
        self.payImageView1WidthConstraint.constant = 0;
        self.leftConstraint1.constant = 0;
        self.payImageView2WidthCOnstraint.constant = 0;
        self.left2Constraint.constant = 0;
        self.payImageView3WidthConstraint.constant = 0;
    }
}

- (void)layoutUI{
    self.lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;

    self.nicknameLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    
    self.tradeNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.coinNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.limitNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.danjiaPriceLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.priceLabel.textColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    [self.buyBtn setBackgroundColor:QDThemeManager.currentTheme.themeSelectedTitleColor];
}

@end
