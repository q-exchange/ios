//
//  SecondHeader.m
//  digitalCurrency
//
//  Created by sunliang on 2018/4/14.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "SecondHeader.h"

@implementation SecondHeader

+(SecondHeader *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SecondHeader" owner:nil options:nil];
    SecondHeader *headerView = [nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}

- (void)layoutUI{
    [self.btn1 setTitle:LocalizationKey(@"home_topGainers") forState:UIControlStateNormal];
    [self.btn2 setTitle:LocalizationKey(@"home_volLeaders") forState:UIControlStateNormal];
    [self.btn3 setTitle:LocalizationKey(@"home_newest") forState:UIControlStateNormal];
    
    [self.btn1 setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateSelected];
    [self.btn1 setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];

    [self.btn2 setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateSelected];
    [self.btn2 setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];
    
    [self.btn3 setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateSelected];
    [self.btn3 setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];

    self.label1.text = LocalizationKey(@"home_name");
    self.label2.text = LocalizationKey(@"home_price");
    self.label3.text = LocalizationKey(@"home_change");

    self.label1.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;
    self.label2.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;
    self.label3.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;

    self.lineView.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;
}

- (IBAction)clickAction:(UIButton *)sender {
    for (UIButton *btn in self.btns) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if (self.block) {
        self.block(sender);
    }
}


@end
