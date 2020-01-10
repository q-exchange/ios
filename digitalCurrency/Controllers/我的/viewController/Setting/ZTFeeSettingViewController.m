//
//  ZTFeeSettingViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/10/16.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTFeeSettingViewController.h"

@interface ZTFeeSettingViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation ZTFeeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"mine_Ratesetting");
    self.titleLabel.text = LocalizationKey(@"mine_myrate");
    self.exchangeLabel.text = LocalizationKey(@"mine_rateexchange");
    self.leverLabel.text = LocalizationKey(@"mine_ratelever");
    self.lilvLabel.text = LocalizationKey(@"mine_ratedaily");

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [QDThemeManager currentTheme].themeBackgroundDescriptionColor;
    self.upview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.bottomView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.line1.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;
    self.line2.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;

    self.exchangeLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.titleLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.makerFee.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.takerFee.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.maker.textColor = [QDThemeManager currentTheme].themeMainTextColor;
    self.taker.textColor = [QDThemeManager currentTheme].themeMainTextColor;
    
    self.leverLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.lilvValue.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.lilvLabel.textColor = [QDThemeManager currentTheme].themeMainTextColor;
    
    [self getData];
}

- (void)initData{
    if (self.data.count == 3) {
        self.makerFee.text = [NSString stringWithFormat:@"%@",self.data[0]];
        self.takerFee.text = [NSString stringWithFormat:@"%@",self.data[1]];
        self.lilvValue.text = [NSString stringWithFormat:@"%@",self.data[2]];
    }
}

- (void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/member/getFeeRate"];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"费率获取 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    self.data = responseResult[@"data"];
                    [self initData];
                }
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

@end
