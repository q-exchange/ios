//
//  NoticeTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/7/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
#import "ZTFrenchOptionalViewController.h"
#import "YLTabBarController.h"
@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 37);
        }
        return UIColorMake(247, 247, 247);
    }];
    
    self.transactionview.userInteractionEnabled = YES;
    self.helpView.userInteractionEnabled = YES;
    self.Noticeview.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transactionaction)];
    [self.transactionview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpaction)];
    [self.helpView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeaction)];
    [self.Noticeview addGestureRecognizer:tap5];
}

- (void)layoutUI{
    self.contentView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 37);
        }
        return UIColorMake(247, 247, 247);
    }];
    
    self.transactionlabel.text = LocalizationKey(@"home_quickbuy");
    self.safelabel.text = LocalizationKey(@"buyingandsellingmoney");
    self.helplebel.text = LocalizationKey(@"Helpcenter");
    self.noticelabel.text = LocalizationKey(@"home_contract");
    
    self.transactionview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.helpView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.Noticeview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    
    self.transactionlabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.safelabel.textColor = [QDThemeManager currentTheme].themeDescriptionTextColor;

    self.noticelabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.helplebel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    
    self.rightImageView1.image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"合约");
        }
        return UIIMAGE(@"合约白");
    }];
    self.rightImageView2.image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"帮助中心");
        }
        return UIIMAGE(@"帮助中心白");
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//法币交易
-(void)transactionaction{
    ZTFrenchOptionalViewController *opti = [[ZTFrenchOptionalViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:opti];
}

//帮助中心
-(void)helpaction{
    HelpeCenterViewController *help = [[HelpeCenterViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

//公告中心
-(void)noticeaction{
    self.ContractBlock();
}

@end
