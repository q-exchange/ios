//
//  listCell.m
//  digitalCurrency
//
//  Created by sunliang on 2018/4/14.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "listCell.h"
#import "AppDelegate.h"
@implementation listCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self LayoutUI];
}

-(void)configModel:(NSArray*)modelArray withIndex:(int)index{
    symbolModel*model = [modelArray objectAtIndex:index];
    
    NSArray *coins = [model.symbol componentsSeparatedByString:@"/"];
    
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
    
    self.titleLabel.text = [coins firstObject];
    self.currencyLabel.text = [NSString stringWithFormat:@"/%@",[coins lastObject]];
    
    self.pricelabel.text = [NSString stringWithFormat:@"%@",[ToolUtil judgeStringForDecimalPlaces:[ToolUtil reviseString:[close stringValue]]]];

    if (model.change <0) {
        self.pricelabel.textColor=RedColor;
        self.rateLabel.backgroundColor=RedColor;
        self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];
    }else{
        self.pricelabel.textColor=GreenColor;
        self.rateLabel.backgroundColor=GreenColor;
        self.rateLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];
    }
    [self LayoutUI];
}

- (void)LayoutUI{
    self.titleLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.currencyLabel.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;
    self.pricelabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.lineView.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;
}

@end
