//
//  PaymentAccountViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "PaymentAccountViewController.h"
#import "BindBankViewController.h"
#import "MineNetManager.h"
#import "PayAccountInfoModel.h"
#import "BindAliPayViewController.h"
#import "BindWeChatViewController.h"
@interface PaymentAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bankStatus;
@property (weak, nonatomic) IBOutlet UILabel *alipayStatus;
@property (weak, nonatomic) IBOutlet UILabel *weChatStatus;
@property(nonatomic,strong)PayAccountInfoModel *infoModel;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliPayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation PaymentAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
    
    self.title = LocalizationKey(@"paymentAccount");
    self.tipsLabel.text = LocalizationKey(@"payTypeTips");
    self.bankNameLabel.text = LocalizationKey(@"bankCardAccount");
    self.aliPayNameLabel.text = LocalizationKey(@"alipayAccount");
    self.weChatNameLabel.text = LocalizationKey(@"WeChatAccount");
    self.bankNameLabel.font =  self.aliPayNameLabel.font = self.weChatNameLabel.font =  self.bankStatus.font = self.alipayStatus.font = self.weChatStatus.font = [UIFont systemFontOfSize:15 * kWindowWHOne];
    [self layoutUI];
}

- (void)layoutUI{
    self.view1.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view2.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.view3.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;

    self.bankNameLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.aliPayNameLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.weChatNameLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    self.bankStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.alipayStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.weChatStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.tipsLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
//MARK:--获取收款账户信息
-(void)getData{
     [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
    [MineNetManager getPayAccountInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.infoModel = [PayAccountInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                //整理数据
                [self arrageData];
            
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//MARK:--整理获取的数据
-(void)arrageData{
    if ([self.infoModel.bankVerified isEqualToString:@"1"]) {
        //已绑定
        self.bankStatus.text = LocalizationKey(@"toModify");
        self.bankStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    }else{
        self.bankStatus.text = LocalizationKey(@"unbounded");
        self.bankStatus.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    }
    if ([self.infoModel.aliVerified isEqualToString:@"1"]) {
        self.alipayStatus.text = LocalizationKey(@"toModify");
        self.alipayStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    }else{
        self.alipayStatus.text = LocalizationKey(@"unbounded");
        self.alipayStatus.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    }
    if ([self.infoModel.wechatVerified isEqualToString:@"1"]) {
        self.weChatStatus.text = LocalizationKey(@"toModify");
        self.weChatStatus.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    }else{
        self.weChatStatus.text = LocalizationKey(@"unbounded");
        self.weChatStatus.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //银行卡账号
        BindBankViewController *bankVC = [[BindBankViewController alloc] init];
        bankVC.model = self.infoModel;
        [[AppDelegate sharedAppDelegate] pushViewController:bankVC];
    }else if (sender.tag == 2){
        //支付宝账号
        BindAliPayViewController *aliPayVC = [[BindAliPayViewController alloc] init];
        aliPayVC.hidesBottomBarWhenPushed = YES;
        aliPayVC.model = self.infoModel;
        [[AppDelegate sharedAppDelegate] pushViewController:aliPayVC];
    }else if (sender.tag == 3){
        //微信账号
        BindWeChatViewController *chatVC = [[BindWeChatViewController alloc] init];
        chatVC.model = self.infoModel;
        [[AppDelegate sharedAppDelegate] pushViewController:chatVC];
    }else{
        //其他
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
