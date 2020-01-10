//
//  BindBankViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "BindBankViewController.h"
#import "MineNetManager.h"
#import "HQPickerView.h"
@interface BindBankViewController ()<HQPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet QMUITextField *branchName;
@property (weak, nonatomic) IBOutlet QMUITextField *bankNum;
@property (weak, nonatomic) IBOutlet QMUITextField *certainBankNum;
@property (weak, nonatomic) IBOutlet QMUITextField *moneyPassword;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainBankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;

@end

@implementation BindBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightItem];
    self.view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
    self.realName.text = self.model.realName;
    if ([self.model.bankVerified isEqualToString:@"1"]) {
        //已绑定 ，可修改
        self.title = LocalizationKey(@"modifyBankNum");
        self.bankName.text = self.model.bankInfo.bank;
        self.branchName.text = self.model.bankInfo.branch;
        self.bankNum.text = self.model.bankInfo.cardNo;
    }else{
        self.title = LocalizationKey(@"setBankNum");
    }
    
    self.name.text = LocalizationKey(@"name");
    self.bankLabel.text = LocalizationKey(@"bankName");
    self.branchLabel.text = LocalizationKey(@"branchName");
    self.bankNumLabel.text = LocalizationKey(@"bankNum");
    self.certainBankNumLabel.text = LocalizationKey(@"certainBankNum");
    self.moneyPasswordLabel.text = LocalizationKey(@"moneyPassword");
    
    self.branchName.placeholder = LocalizationKey(@"inputBranchInfo");
    self.bankNum.placeholder = LocalizationKey(@"inputBankNum");
    self.certainBankNum.placeholder = LocalizationKey(@"inputCertainBankNum");
     self.moneyPassword.placeholder = LocalizationKey(@"inputMoneyPassword");
    self.moneyPassword.secureTextEntry = YES;
    
    [self layoutUI];
}

- (void)layoutUI{
    self.view1.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view2.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view3.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view4.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view5.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view6.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;

    self.name.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.bankLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.branchLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.bankNumLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.certainBankNumLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.moneyPasswordLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    self.realName.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.bankName.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.branchName.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.bankNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.certainBankNum.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.moneyPassword.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.branchName.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.bankNum.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.certainBankNum.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.moneyPassword.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;

}

- (void)setRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    [btn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

//MARK:--点击保存按钮点击事件
- (void)RighttouchEvent{
    if ([self.bankName.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputBankName") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.branchName.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputBranchInfo") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.bankNum.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputBankNum") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.certainBankNum.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputCertainBankNum") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (![self.certainBankNum.text isEqualToString:self.bankNum.text]) {
        [self.view makeToast:LocalizationKey(@"judgeBankNumAndCertainBankNum") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"inputMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    NSString *urlStr = @"";
    if ([self.model.bankVerified isEqualToString:@"1"]) {
        //已绑定，可修改
        urlStr = @"uc/approve/update/bank";
    }else{
        urlStr = @"uc/approve/bind/bank";
    }
    [MineNetManager setBankNumForUrlString:urlStr withBank:self.bankName.text withBranch:self.branchName.text withJyPassword:self.moneyPassword.text withRealName:self.realName.text withCardNo:self.bankNum.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[AppDelegate sharedAppDelegate] popViewController];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--选择开户银行的点击事件
- (IBAction)selectBankName:(id)sender {
    [self selectCoinTypeView];
}
//MARK:--点击购买弹出的提示框
-(void)selectCoinTypeView{
    NSArray *zhBankName = @[@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国邮政储蓄银行",@"招商银行",@"中国银行",@"交通银行",@"中信银行",@"华夏银行",@"中国民生银行",@"广发银行",@"平安银行",@"兴业银行",@"上海浦东发展银行",@"浙商银行",@"渤海银行",@"恒丰银行",@"花旗银行",@"渣打银行",@"汇丰银行",@"中国光大银行",@"上海银行",@"江苏银行",@"重庆银行",@"天津银行",@"厦门银行",@"城市商业银行",@"农村商业银行",@"徽商银行"];
    NSArray *enBankName = @[@"ICBC",@"ABC",@"CCB",@"PSBC",@"CMB",@"BOC",@"BOCOM",@"ECITIC",@"HXB",@"CMBC",@"Guangdong development bank",@"PAB",@"CIB",@"SPDB",@"CZB",@"CBB",@"Hengfeng bank",@"citibank",@"SCB",@"HSBC",@"CEB",@"Bank of Shanghai",@"Bank of jiangsu",@"Chongqing bank",@"Bank of tianjin",@"Xiamen bank",@"City commercial bank",@"Rural commercial bank",@"Huishang Bank"];
    
    HQPickerView *picker = [[HQPickerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    picker.delegate = self ;
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        picker.customArr = enBankName;
    }else{
        picker.customArr = zhBankName;
    }
    [self.view addSubview:picker];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text {
    self.bankName.text = text;
}



@end
