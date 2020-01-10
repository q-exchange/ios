//
//  HomeRecommendCollectionViewCell.m
//  digitalCurrency
//
//  Created by chu on 2018/7/20.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "HomeRecommendCollectionViewCell.h"
#import "AppDelegate.h"

@implementation HomeRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
}

- (void)setModel:(symbolModel *)model{
    _model = model;
    
    self.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.backView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.symbolLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.cnyLabel.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;
    
    self.symbolLabel.text = model.symbol;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.close doubleValue]];
    
    
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
    NSDecimalNumber *baseUsdRate = [NSDecimalNumber decimalNumberWithDecimal:[model.baseUsdRate decimalValue]];
    self.cnyLabel.text = [NSString stringWithFormat:@"≈%.2f CNY",[[[close decimalNumberByMultiplyingBy:baseUsdRate] decimalNumberByMultiplyingBy:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate] doubleValue]];
    
    if (self.model.change < 0) {
        self.chgLabel.textColor = RedColor;
        self.priceLabel.textColor = RedColor;

        self.chgLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];

    }else{
        self.chgLabel.textColor = GreenColor;
        self.priceLabel.textColor = GreenColor;
        self.chgLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];
    }
}



@end
