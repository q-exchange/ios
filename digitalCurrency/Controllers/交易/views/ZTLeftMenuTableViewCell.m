//
//  ZTLeftMenuTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/10/19.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTLeftMenuTableViewCell.h"

@implementation ZTLeftMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)configDataWithModel:(symbolModel*)model withtype:(int)type withIndex:(int)index{
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    self.currencyLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.baseLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    
    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
    self.currencyLabel.text=[array firstObject];
    self.baseLabel.text=[NSString stringWithFormat:@"/%@",[array lastObject]];

    self.priceLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil judgeStringForDecimalPlaces:[ToolUtil reviseString:[close stringValue]]]];
    
    if (model.change <0) {
        self.priceLabel.textColor = RedColor;
    }else{
        self.priceLabel.textColor=GreenColor;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
