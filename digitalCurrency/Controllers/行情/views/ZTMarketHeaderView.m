//
//  ZTMarketHeaderView.m
//  digitalCurrency
//
//  Created by chu on 2019/10/11.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTMarketHeaderView.h"

@implementation ZTMarketHeaderView

+(ZTMarketHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZTMarketHeaderView" owner:nil options:nil];
    ZTMarketHeaderView *headerView = [nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}

- (void)layoutUI{
    self.leftLabel.text = LocalizationKey(@"home_name");
    self.midLabel.text = LocalizationKey(@"home_price");
    self.rightLabel.text = LocalizationKey(@"home_change");
    
    self.leftLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.midLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
}

- (IBAction)clickAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}

@end
