//
//  Adversiting2TableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "Adversiting2TableViewCell.h"

@implementation Adversiting2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    // Initialization code
    self.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.textView.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.textView.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;    
}
-(void)textViewDidEndEditing:(QMUITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewIndex:TextViewString:)]) {
        [self.delegate textViewIndex:self.index TextViewString:textView.text];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
