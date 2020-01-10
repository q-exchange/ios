//
//  marketCell.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "marketCell.h"
#import "AppDelegate.h"
@implementation marketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configDataWithModel:(symbolModel*)model withtype:(int)type withIndex:(int)index{
    self.lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.nameLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.baseLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.moneyLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.tradeNumbel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.cnyLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    
    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
    NSDecimalNumber *baseUsdRate = [NSDecimalNumber decimalNumberWithDecimal:[model.baseUsdRate decimalValue]];
    self.nameLabel.text=[array firstObject];
    self.baseLabel.text=[NSString stringWithFormat:@"/%@",[array lastObject]];

    self.moneyLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil judgeStringForDecimalPlaces:[ToolUtil reviseString:[close stringValue]]]];
    
    if (((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate) {
        NSDecimalNumber *result = [[close decimalNumberByMultiplyingBy:baseUsdRate] decimalNumberByMultiplyingBy:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate];
        NSString *resultStr = [result stringValue];
        if ([resultStr containsString:@"."]) {
            NSArray *arr = [resultStr componentsSeparatedByString:@"."];
            if (arr.count > 1 && [arr[1] length] > 2) {
                resultStr = [NSString stringWithFormat:@"%@.%@",arr[0],[arr[1] substringWithRange:NSMakeRange(0, 2)]];
            }
        }
        self.cnyLabel.text=[NSString stringWithFormat:@"¥%@ CNY",resultStr];
        
    }else{
        self.cnyLabel.text = @"¥0.00 CNY";
    }
    self.tradeNumbel.text=[NSString stringWithFormat:@"%@ %.2f",LocalizationKey(@"hourvol"),model.volume];
   
    if (model.change <0) {
        self.moneyLabel.textColor=RedColor;
        self.changeLabel.backgroundColor=RedColor;
        self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];

    }else{
        self.moneyLabel.textColor=GreenColor;
        self.changeLabel.backgroundColor=GreenColor;
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(UIButton *)sender {
    
}

@end
