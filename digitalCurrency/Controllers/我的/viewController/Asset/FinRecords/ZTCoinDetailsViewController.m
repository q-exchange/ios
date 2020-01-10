//
//  ZTCoinDetailsViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/10/17.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTCoinDetailsViewController.h"
#import "WalletManageTableViewCell.h"
#import "ZTFinRecordModel.h"
#import "UIView+LLXAlertPop.h"
#import "ZTSearchCoinViewController.h"
#import "TurnOutViewController.h"

@interface ZTCoinDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation ZTCoinDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self getData];
    [self getRecordWithType:@""];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletManageTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.model = self.model;
    }else{
        ZTFinRecordModel *model = self.dataSourceArr[indexPath.row];
        if([model.type isEqualToString:@"0"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"top-up" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"1"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"withdrawal" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"2"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"transfer" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"3"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"coinCurrencyTrading" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"4"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"FiatMoneyBuy" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"5"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"FiatMoneySell" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"6"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"activitiesReward" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"7"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"promotionRewards" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"8"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"shareOutBonus" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"9"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"vote" value:nil table:@"English"];
         }else if([model.type isEqualToString:@"10"]){
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"ArtificialTop-up" value:nil table:@"English"];
         }else if ([model.type isEqualToString:@"11"]){
             cell.coinType.text = LocalizationKey(@"pairing");
         }else if ([model.type isEqualToString:@"12"]){
             cell.coinType.text = LocalizationKey(@"PaymentofBusinessMargin");
         }else if ([model.type isEqualToString:@"13"]){
             cell.coinType.text = LocalizationKey(@"ReturnedofBusinessMargin");
         }else if ([model.type isEqualToString:@"14"]){
             cell.coinType.text = LocalizationKey(@"C2CRecharge");
         }else if ([model.type isEqualToString:@"15"]){
             cell.coinType.text = LocalizationKey(@"Currencyexchange");
         }else if ([model.type isEqualToString:@"16"]){
             cell.coinType.text = LocalizationKey(@"Channelpromotion");
         }else if ([model.type isEqualToString:@"17"]){
             cell.coinType.text = LocalizationKey(@"CoinToLever");
         }else if ([model.type isEqualToString:@"18"]){
             cell.coinType.text = LocalizationKey(@"LeverToCoin");
         }else if ([model.type isEqualToString:@"19"]){
             cell.coinType.text = LocalizationKey(@"Walletairdrop");
         }else if ([model.type isEqualToString:@"20"]){
             cell.coinType.text = LocalizationKey(@"LockPosition");
         }else if ([model.type isEqualToString:@"21"]){
             cell.coinType.text = LocalizationKey(@"Unlock");
         }else if ([model.type isEqualToString:@"22"]){
             cell.coinType.text = LocalizationKey(@"ThirdPartyTransfer");
         }else if ([model.type isEqualToString:@"23"]){
             cell.coinType.text = LocalizationKey(@"Thirdpartyoutgoing");
         }else if ([model.type isEqualToString:@"24"]){
             cell.coinType.text = LocalizationKey(@"CoinToCurrency");
         }else if ([model.type isEqualToString:@"25"]){
             cell.coinType.text = LocalizationKey(@"CurrencyToCoin");
         }else if ([model.type isEqualToString:@"26"]){
             cell.coinType.text = LocalizationKey(@"BorrowingTurnover");
         }else if ([model.type isEqualToString:@"27"]){
             cell.coinType.text = LocalizationKey(@"Repaymentflow");
         }else{
             cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"other" value:nil table:@"English"];
         }
        cell.finModel = model;
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (section == 1) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 10)];
        sep.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
        [view addSubview:sep];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 45)];
        label.text = LocalizationKey(@"assert_financial_records");
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        [view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            if ([identifier isEqualToString:QDThemeIdentifierDark]) {
                return UIIMAGE(@"筛选黑");
            }
            return UIIMAGE(@"筛选白");
        }] forState:UIControlStateNormal];
        btn.frame = CGRectMake(kWindowW - 55, 10, 45, 45);
        [btn addTarget:self action:@selector(shaixuan) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    return view;
}

- (void)shaixuan{
    NSArray *titles = @[LocalizationKey(@"all"), LocalizationKey(@"mentionMoney"), LocalizationKey(@"chargeMoney"), LocalizationKey(@"TurnIn"), LocalizationKey(@"TurnOut")];
    NSArray *colors = @[QDThemeManager.currentTheme.themeTitleTextColor, QDThemeManager.currentTheme.themeTitleTextColor, QDThemeManager.currentTheme.themeTitleTextColor, QDThemeManager.currentTheme.themeTitleTextColor, QDThemeManager.currentTheme.themeTitleTextColor];
    [self.view createAlertViewTitleArray:titles textColor:colors font:[UIFont systemFontOfSize:16] type:1  actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        if (didRow == 0) {
            [self getRecordWithType:@""];
        }else if (didRow == 1){
            [self getRecordWithType:@"1"];
        }else if (didRow == 2){
            [self getRecordWithType:@"0"];
        }else if (didRow == 3){
            [self getRecordWithType:@"2"];
        }else if (didRow == 4){
            [self getRecordWithType:@"2"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001f;
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)getData{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",HOST, @"uc/asset/getAssetForCoinType", self.model.coin.unit];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"根据币种获取资产余额 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    
                }
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (void)getRecordWithType:(NSString *)type{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/asset/getAssetPage"];
    NSDictionary *param = @{@"pageNo":@"1", @"pageSize":@"10", @"symbol":self.model.coin.unit, @"type":type};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取资产详细 ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *data = responseResult[@"data"];
                    NSArray *content = data[@"content"];
                    [self.dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in content) {
                        ZTFinRecordModel *model = [ZTFinRecordModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    [self.tableView reloadData];
                }
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar - 80) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 68;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WalletManageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletManageTableViewCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH - 80 - Height_NavBar, kWindowW, 80)];
        _bottomView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        NSArray *titles = @[];
        NSArray *images = @[];
        if ([self.model.coin.canRecharge isEqualToString:@"1"] &&[self.model.coin.canWithdraw isEqualToString:@"1"]) {
            //可以充币，提币
            titles = @[LocalizationKey(@"chargeMoney") ,LocalizationKey(@"mentionMoney"),LocalizationKey(@"Transfer"), LocalizationKey(@"coinCurrencyTrading")];
            if ([[QMUIThemeManagerCenter defaultThemeManager].currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
                images = @[@"balance_detail_deposit_btn-1", @"balance_detail_withdraw_btn-1", @"balance_detail_transfer_btn-1", @"balance_detail_exchange_btn-1"];
            }else{
                images = @[@"balance_detail_deposit_btn", @"balance_detail_withdraw_btn", @"balance_detail_transfer_btn", @"balance_detail_exchange_btn"];
            }
        }else if ([self.model.coin.canRecharge isEqualToString:@"1"] && ![self.model.coin.canWithdraw isEqualToString:@"1"]){
            titles = @[LocalizationKey(@"chargeMoney"),LocalizationKey(@"Transfer"), LocalizationKey(@"coinCurrencyTrading")];
            if ([[QMUIThemeManagerCenter defaultThemeManager].currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
                images = @[@"balance_detail_deposit_btn-1", @"balance_detail_transfer_btn-1", @"balance_detail_exchange_btn-1"];
            }else{
                images = @[@"balance_detail_deposit_btn", @"balance_detail_transfer_btn", @"balance_detail_exchange_btn"];
            }
        }else if (![self.model.coin.canRecharge isEqualToString:@"1"] && [self.model.coin.canWithdraw isEqualToString:@"1"]){
            titles = @[LocalizationKey(@"mentionMoney"),LocalizationKey(@"Transfer"), LocalizationKey(@"coinCurrencyTrading")];
            if ([[QMUIThemeManagerCenter defaultThemeManager].currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
                images = @[@"balance_detail_withdraw_btn-1", @"balance_detail_transfer_btn-1", @"balance_detail_exchange_btn-1"];
            }else{
                images = @[@"balance_detail_withdraw_btn", @"balance_detail_transfer_btn", @"balance_detail_exchange_btn"];
            }
        }else{
            titles = @[LocalizationKey(@"Transfer"), LocalizationKey(@"coinCurrencyTrading")];
            if ([[QMUIThemeManagerCenter defaultThemeManager].currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
                images = @[@"balance_detail_transfer_btn-1", @"balance_detail_exchange_btn-1"];
            }else{
                images = @[@"balance_detail_transfer_btn", @"balance_detail_exchange_btn"];
            }
        }
        

        for (int i = 0; i < titles.count; i++) {
            QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * (kWindowW / titles.count), 0, kWindowW / titles.count, 80);
            [btn setImagePosition:QMUIButtonImagePositionTop];
            btn.spacingBetweenImageAndTitle = 5;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            if (i == titles.count - 1) {
                [btn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
            }
            if ([btn.currentTitle isEqualToString:LocalizationKey(@"chargeMoney")]) {
                [btn addTarget:self action:@selector(chargemoney:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([btn.currentTitle isEqualToString:LocalizationKey(@"mentionMoney")]){
                [btn addTarget:self action:@selector(mentionMoney:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([btn.currentTitle isEqualToString:LocalizationKey(@"Transfer")]){
                [btn addTarget:self action:@selector(Transfer:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([btn.currentTitle isEqualToString:LocalizationKey(@"coinCurrencyTrading")]){
                [btn addTarget:self action:@selector(coinCurrencyTrading:) forControlEvents:UIControlEventTouchUpInside];
            }
                
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [_bottomView addSubview:btn];
        }
    }
    return _bottomView;
}

- (void)chargemoney:(QMUIButton *)sender{
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_charge];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (void)mentionMoney:(QMUIButton *)sender{
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_withdraw];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (void)Transfer:(QMUIButton *)sender{
    TurnOutViewController *turn = [[TurnOutViewController alloc] init];
    turn.unit = self.model.coin.unit;
    turn.from = AccountType_Coin;
    turn.to = AccountType_Curreny;
    [[AppDelegate sharedAppDelegate] pushViewController:turn];
}

- (void)coinCurrencyTrading:(QMUIButton *)sender{
    [[AppDelegate sharedAppDelegate] popToRootViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CoinToTabbar" object:nil];
}

@end
