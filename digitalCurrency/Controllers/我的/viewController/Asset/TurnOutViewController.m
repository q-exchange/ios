//
//  TurnOutViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "TurnOutViewController.h"
#import "SelAccountViewController.h"
#import "AssetModel.h"
#import "MineNetManager.h"
#import "WalletManageModel.h"
#import "UIView+LLXAlertPop.h"
#import "LeverAccountModel.h"

@interface TurnOutViewController ()<SelAccountDelegate>
{
    BOOL _haveChange;
    NSString *_haveBalance;
    
    NSString *_baseSymbol;
    NSString *_coinSymbol;
}
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UILabel *line4;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *toBtn;

@property (weak, nonatomic) IBOutlet UILabel *coinTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet QMUITextField *amountTF;

@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UILabel *haveAmountLabel;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toViewMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toViewMarginBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueMarginBottomConstraint;

@property (nonatomic, strong) NSMutableArray *currencyArr;
@property (nonatomic, strong) NSMutableArray *leverArr;
@property (nonatomic, strong) NSMutableArray *coinArr;

@property (nonatomic, strong) LeverAccountModel *accountModel;
@end

@implementation TurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Transfer");
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self getData];
    [self layoutUI];
}

- (void)getData{
    [self getCurrency];
    [self getCoin];
    if (![NSString stringIsNull:self.symbol]) {
        [self getLever];
    }
}

- (void)initData{
//    self.upView.layer.cornerRadius = 1;
//    self.upView.layer.borderWidth = 0.5;
//    self.upView.layer.borderColor = RGBOF(0x253850).CGColor;
//    self.upView.layer.masksToBounds = YES;
    
    self.doneBtn.layer.cornerRadius = 3;
    self.doneBtn.layer.masksToBounds = YES;
    [self.doneBtn setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    
    self.fromLabel.text = LocalizationKey(@"From");
    self.toLabel.text = LocalizationKey(@"To");

    self.coinTypeLabel.text = LocalizationKey(@"Currency");
    self.amountLabel.text = LocalizationKey(@"TransferNumber");
    
    self.amountTF.placeholder = LocalizationKey(@"inputTransferNumber");
    [self.allBtn setTitle:LocalizationKey(@"all") forState:UIControlStateNormal];
    
    self.haveAmountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"usabel"),@"0.00", self.unit];
    
    self.coinValueLabel.text = self.unit;
    self.coinLabel.text = self.unit;
    
    if (self.from == AccountType_Coin) {
        self.fromValueLabel.text = LocalizationKey(@"AccountCoin");
    }else if (self.from == AccountType_Curreny){
        self.fromValueLabel.text = LocalizationKey(@"AccountCurrency");
    }else{
        self.fromValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.symbol, LocalizationKey(@"AccountLever")];
    }
    
    if (self.to == AccountType_Coin) {
        self.toValueLabel.text = LocalizationKey(@"AccountCoin");
    }else if (self.to == AccountType_Curreny){
        self.toValueLabel.text = LocalizationKey(@"AccountCurrency");
    }else{
        self.toValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.symbol, LocalizationKey(@"AccountLever")];
    }
    if (![NSString stringIsNull:self.symbol]) {
        NSArray *symbols = [self.symbol componentsSeparatedByString:@"/"];
        if (symbols.count == 2) {
            _baseSymbol = [symbols lastObject];
            _coinSymbol = [symbols firstObject];
        }
    }
}

- (void)layoutUI
{
    self.upView.layer.cornerRadius = 3;
    self.upView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.upView.layer.borderWidth = 1;
    
    [self.changeBtn setBackgroundColor:QDThemeManager.currentTheme.themeBackgroundDescriptionColor];
    
    self.fromLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.toLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.fromValueLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.toValueLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    self.line1.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.line2.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.line3.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.line4.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    self.coinTypeLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.coinValueLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.amountLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.coinLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.haveAmountLabel.textColor = QDThemeManager.currentTheme.themePlaceholderColor;
    
    [self.allBtn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    self.amountTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.amountTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
}

#pragma mark - 切换
- (IBAction)changeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.highlighted = NO;
    if (_haveChange) {
        self.fromValueMarginTopConstraint.constant = 0;
        self.fromValueMarginBottomConstraint.constant = 0;
        self.toViewMarginTopConstraint.constant = 0;
        self.toViewMarginBottomConstraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.upView layoutIfNeeded];
        }];
    }else{
        self.fromValueMarginTopConstraint.constant = 45;
        self.fromValueMarginBottomConstraint.constant = -45;
        self.toViewMarginTopConstraint.constant = -45;
        self.toViewMarginBottomConstraint.constant = 45;
        [UIView animateWithDuration:0.3 animations:^{
            [self.upView layoutIfNeeded];

        }];
    }
    _haveChange = !_haveChange;
    [self getData];
    [self setHaveAmount];
}


- (IBAction)toAction:(UIButton *)sender {
    SelAccountViewController *sel = [[SelAccountViewController alloc] init];
    sel.delegate = self;
    [[AppDelegate sharedAppDelegate] pushViewController:sel];
}

- (void)selAccountFinishWithSymbol:(NSString *_Nullable)symbol baseSymbol:(NSString *_Nullable)baseSymbol changeSymbol:(NSString *_Nullable)changeSymbol{
    if (self.from == AccountType_Coin) {
        if (![NSString stringIsNull:symbol]) {
            self.symbol = symbol;
            _baseSymbol = baseSymbol;
            _coinSymbol = changeSymbol;
            //杠杆账户
            self.toValueLabel.text = [NSString stringWithFormat:@"%@ %@",symbol, LocalizationKey(@"AccountLever")];
            self.coinValueLabel.text = baseSymbol;
            self.coinLabel.text = baseSymbol;
            self.unit = baseSymbol;
        }else{
            self.symbol = @"";
            self.toValueLabel.text = LocalizationKey(@"AccountCurrency");
            self.coinValueLabel.text = self.unit;
            self.coinLabel.text = self.unit;
        }
    }else{
        if (![NSString stringIsNull:symbol]) {
            self.symbol = symbol;
            _baseSymbol = baseSymbol;
            _coinSymbol = changeSymbol;
            //杠杆账户
            self.fromValueLabel.text = [NSString stringWithFormat:@"%@ %@",symbol, LocalizationKey(@"AccountLever")];
            self.coinValueLabel.text = baseSymbol;
            self.coinLabel.text = baseSymbol;
        }else{
            self.symbol = @"";
            self.fromValueLabel.text = LocalizationKey(@"AccountCurrency");
            self.coinValueLabel.text = self.unit;
            self.coinLabel.text = self.unit;
        }
    }
    [self getData];
//    [self setHaveAmount];
}

#pragma mark - 选择币种
- (IBAction)selCoinAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableArray *arratTitle = [NSMutableArray arrayWithCapacity:0];

    //要选择法币或杠杆账户可选币种
    if (![NSString stringIsNull:self.symbol]) {
        //杠杆账户
        [arratTitle addObject:_baseSymbol];
        [arratTitle addObject:_coinSymbol];
    }else{
        if (_haveChange) {
            //法币账户
            if (self.currencyArr.count == 0) {
                return;
            }
            for (WalletManageModel *model in self.currencyArr) {
                [arratTitle addObject:model.coin.unit];
            }
        }else{
            if (self.coinArr.count == 0) {
                return;
            }
            for (WalletManageModel *model in self.coinArr) {
                [arratTitle addObject:model.coin.unit];
            }
        }
    }
    __weak typeof(self)weakself = self;
    [self.view createAlertViewTitleArray:arratTitle textColor:nil font:[UIFont systemFontOfSize:16] type:1  actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        if (![button.currentTitle isEqualToString:[[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"]]) {
            weakself.unit = arratTitle[didRow];
            [weakself getData];
        }
    }];
}

- (IBAction)allAction:(UIButton *)sender {
    sender.highlighted = NO;
    self.amountTF.text = _haveBalance;
}

- (IBAction)doneAction:(UIButton *)sender {
    if (![NSString stringIsNull:self.symbol]) {
        [self coinToLever];
    }else{
        [self coinToCurrency];
    }
}

#pragma mark - 获取法币账户
-(void)getCurrency{
    __weak typeof(self)weakself = self;
//    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/otc/wallet/get"];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:nil contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
//        [EasyShowLodingView hidenLoding];
        NSLog(@"获取法币所有可选币种 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [self.currencyArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                [self.currencyArr addObjectsFromArray:dataArr];
                [weakself setHaveAmount];
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}
#pragma mark - 获取币币账户
-(void)getCoin{
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取币币账户 --- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.coinArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.coinArr addObjectsFromArray:dataArr];
                [self setHaveAmount];
            }else{
            }
        }else{
        }
    }];
}
#pragma mark - 获取杠杆账户
- (void)getLever{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/list"];
    NSDictionary *param = @{@"symbol":self.symbol};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取杠杆账户 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    [self.leverArr removeAllObjects];
                    NSArray *dataArr = [LeverAccountModel mj_objectArrayWithKeyValuesArray:data];
                    [self.leverArr addObjectsFromArray:dataArr];
                    [weakself setHaveAmount];
                }
            }else{

            }
        }
    }];
}

- (void)setHaveAmount{
    self.coinLabel.text = self.unit;
//    self.coinTypeLabel.text = self.unit;
    self.coinValueLabel.text = self.unit;
    self.amountTF.text = @"";
    _haveBalance = @"0.00";
    self.haveAmountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"usabel"), @"0.00", self.unit];

    if (_haveChange) {
        //toValueLabel为转出账户
        //判断assetModel是否存在 不存在法币账户
        if (![NSString stringIsNull:self.symbol]) {
            for (LeverAccountModel *model in self.leverArr) {
                NSArray *leverWalletList = model.leverWalletList;
                for (LeverWalletModel *wallet in leverWalletList) {
                    if ([wallet.coin.unit isEqualToString:self.unit]) {
                        self.haveAmountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"usabel"), wallet.balance, wallet.coin.unit];
                        _haveBalance = wallet.balance;
                        break;
                    }
                }
            }
        }else{
            for (WalletManageModel *model in self.currencyArr) {
                if ([model.coin.unit isEqualToString:self.unit]) {
                    self.haveAmountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"usabel"), model.balance, model.coin.unit];
                    _haveBalance = model.balance;
                    break;
                }
            }
        }
    }else{
        //fromValueLabel为转出账户
        for (WalletManageModel *model in self.coinArr) {
            if ([model.coin.unit isEqualToString:self.unit]) {
                self.haveAmountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"usabel"), model.balance, model.coin.unit];
                _haveBalance = model.balance;
                break;
            }
        }
    }
}

#pragma mark - 币币法币互转
- (void)coinToCurrency{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/otc/wallet/transfer"];
    NSString *direction = @"0";
    if (_haveChange) {
        direction = @"1";
    }else{
        direction = @"0";
    }
    NSDictionary *param = @{@"coinName":self.unit, @"amount":self.amountTF.text, @"direction":direction};
    [EasyShowLodingView showLoding];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"币币法币互转 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
                [self getData];
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

#pragma mark - 币币和杠杆互转
- (void)coinToLever{
    __weak typeof(self)weakself = self;
    NSString *url = @"";
    if (_haveChange) {
        url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/turn_out"];
    }else{
        url = [NSString stringWithFormat:@"%@%@",HOST, @"margin-trade/lever_wallet/change_into"];
    }
    NSDictionary *param = @{@"coinUnit":self.unit, @"amount":self.amountTF.text, @"leverCoinSymbol":self.symbol};
    [EasyShowLodingView showLoding];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"币币和杠杆互转 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
                [self getData];
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

- (NSMutableArray *)currencyArr{
    if (!_currencyArr) {
        _currencyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _currencyArr;
}

- (NSMutableArray *)leverArr{
    if (!_leverArr) {
        _leverArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _leverArr;
}

- (NSMutableArray *)coinArr{
    if (!_coinArr) {
        _coinArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _coinArr;
}

@end
