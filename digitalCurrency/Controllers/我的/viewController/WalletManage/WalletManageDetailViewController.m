//
//  WalletManageDetailViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "WalletManageDetailViewController.h"
#import "WalletManageDetailTableViewCell.h"
#import "MineNetManager.h"
#import "TradeHistoryModel.h"
#import "DownTheTabs.h"
#import "MentionCoinInfoModel.h"
@interface WalletManageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    DownTheTabs *_tabs;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,strong)NSMutableArray *tradeHistoryArr;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,strong)NSMutableArray *mentionCoinArr;
@property(nonatomic,strong)NSMutableArray *transactionTypeArr;

@property (nonatomic,copy)NSString *startime;
@property (nonatomic,copy)NSString *endtime;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *symbol;

@end

@implementation WalletManageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Assetflow" value:nil table:@"English"];
//    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 44;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletManageDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletManageDetailTableViewCell class])];
    [self RightsetupNavgationItemWithpictureName:@"zicanliushui"];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshHeaderAction];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshFooterAction];
    }];
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"detailTableViewTip" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
    
    self.pageNo = 1;
    [self getData];
    [self getTransactionType];
}
//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self getData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    self.startime = @"";
    self.endtime = @"";
    self.type = @"";
    [self getData];
}
//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];

    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:self.startime forKey:@"startTime"];
    [bodydic setValue:self.endtime forKey:@"endTime"];
    [bodydic setValue:self.type forKey:@"type"];
    [MineNetManager assettransactionParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        NSLog(@"获取资产流水 -  %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_tradeHistoryArr removeAllObjects];
                }
                
                NSArray *dataArr = [assetsourcemodel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                [self.tradeHistoryArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 获取所有交易明细类型
- (void)getTransactionType{
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/asset/transaction_type"];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取所有交易明细类型 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [self.transactionTypeArr removeAllObjects];
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    [self.transactionTypeArr addObjectsFromArray:data];
                }
            }else{
                
            }
        }
    }];
}

- (NSMutableArray *)mentionCoinArr {
    if (!_mentionCoinArr) {
        _mentionCoinArr = [NSMutableArray array];
    }
    return _mentionCoinArr;
}
//MARK:--获取币种信息
-(void)mentionCoinInfo{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //[self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.mentionCoinArr addObjectsFromArray:dataArr];
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

- (NSMutableArray *)tradeHistoryArr {
    if (!_tradeHistoryArr) {
        _tradeHistoryArr = [NSMutableArray array];
    }
    return _tradeHistoryArr;
}
-(void)RighttouchEvent{
    if (_tabs) {
        [_tabs removeFromSuperview];
        _tabs = nil;
        return;
    }
    self.startime = @"";
    self.endtime = @"";
    self.type = @"";
    
    NSMutableArray *tabsarray = [NSMutableArray arrayWithCapacity:0];
    if (self.transactionTypeArr) {
        for (NSDictionary *dic in self.transactionTypeArr) {
            [tabsarray addObject:dic[@"name"]];
        }
    }
    DownTheTabs *tabs = [[DownTheTabs alloc] initAssetFlowTabsWithContainerView:self.view Types:tabsarray];
    _tabs = tabs;
    tabs.dismissBlock = ^{
//            self.navigationItem.rightBarButtonItem.enabled = YES;
        };
    tabs.assetFlowBlock = ^(NSString *type, NSString *startTime, NSString *endTime) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
        for (int i = 0; i < tabsarray.count; i ++) {
            if ([type isEqualToString:tabsarray[i]]) {
                NSDictionary *dic = self.transactionTypeArr[i];
                self.type = [NSString stringWithFormat:@"%@",dic[@"key"]];
            }
        }
        if (startTime.length > 0) {
            self.startime = [ToolUtil timeIntervalToTimeString:startTime WithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        if (endTime.length > 0) {
            self.endtime = [ToolUtil timeIntervalToTimeString:endTime WithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        self.pageNo = 1;
        
        [self getData];
    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tradeHistoryArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletManageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletManageDetailTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    assetsourcemodel *model = _tradeHistoryArr[indexPath.row];
    cell.dateLabel.text = model.createTime;
    cell.mentionMoneyNum.text = [ToolUtil judgeStringForDecimalPlaces:model.amount];
//    if ([model.amount doubleValue]>=0) {
//        cell.mentionMoneyNum.textColor=GreenColor;
//    }else{
//         cell.mentionMoneyNum.textColor=RedColor;
//    }
    cell.mentionMoneyType.text = model.symbol;
    if([model.type isEqualToString:@"0"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"top-up" value:nil table:@"English"];
    }
    else if([model.type isEqualToString:@"1"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"withdrawal" value:nil table:@"English"];
    }
    else if([model.type isEqualToString:@"2"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"transfer" value:nil table:@"English"];
    }
    else if([model.type isEqualToString:@"3"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"coinCurrencyTrading" value:nil table:@"English"];
    }
   else if([model.type isEqualToString:@"4"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"FiatMoneyBuy" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"5"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"FiatMoneySell" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"6"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"activitiesReward" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"7"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"promotionRewards" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"8"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"shareOutBonus" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"9"]){
        cell.coinType.text = [[ChangeLanguage bundle] localizedStringForKey:@"vote" value:nil table:@"English"];
    }
    else  if([model.type isEqualToString:@"10"]){
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
    cell.statusLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"completed" value:nil table:@"English"];
    cell.feeLabel.text = [ToolUtil formartScientificNotationWithString:model.fee];
    cell.deductiblelabel.text = [ToolUtil formartScientificNotationWithString:model.discountFee == nil ? @"0":model.discountFee];
    cell.Actuallabel.text = [ToolUtil formartScientificNotationWithString:model.realFee== nil ? @"0":model.realFee];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 153;
}

- (NSMutableArray *)transactionTypeArr{
    if (!_transactionTypeArr) {
        _transactionTypeArr = [NSMutableArray arrayWithCapacity:0];
//        [_transactionTypeArr addObject:@{@"key":@"0", @"name":LocalizationKey(@"top-up")}];
//        [_transactionTypeArr addObject:@{@"key":@"1", @"name":LocalizationKey(@"withdrawal")}];
//        [_transactionTypeArr addObject:@{@"key":@"2", @"name":LocalizationKey(@"transfer")}];
//        [_transactionTypeArr addObject:@{@"key":@"3", @"name":LocalizationKey(@"coinCurrencyTrading")}];
//        [_transactionTypeArr addObject:@{@"key":@"4", @"name":LocalizationKey(@"FiatMoneyBuy")}];
//        [_transactionTypeArr addObject:@{@"key":@"5", @"name":LocalizationKey(@"FiatMoneySell")}];
//        [_transactionTypeArr addObject:@{@"key":@"6", @"name":LocalizationKey(@"activitiesReward")}];
//        [_transactionTypeArr addObject:@{@"key":@"7", @"name":LocalizationKey(@"promotionRewards")}];
//        [_transactionTypeArr addObject:@{@"key":@"8", @"name":LocalizationKey(@"shareOutBonus")}];
//        [_transactionTypeArr addObject:@{@"key":@"9", @"name":LocalizationKey(@"vote")}];
//        [_transactionTypeArr addObject:@{@"key":@"10", @"name":LocalizationKey(@"ArtificialTop-up")}];
//        [_transactionTypeArr addObject:@{@"key":@"11", @"name":LocalizationKey(@"pairing")}];
//        [_transactionTypeArr addObject:@{@"key":@"12", @"name":LocalizationKey(@"PaymentofBusinessMargin")}];
//        [_transactionTypeArr addObject:@{@"key":@"13", @"name":LocalizationKey(@"ReturnedofBusinessMargin")}];
//        [_transactionTypeArr addObject:@{@"key":@"14", @"name":LocalizationKey(@"C2CRecharge")}];
//        [_transactionTypeArr addObject:@{@"key":@"15", @"name":LocalizationKey(@"Currencyexchange")}];
//        [_transactionTypeArr addObject:@{@"key":@"16", @"name":LocalizationKey(@"Channelpromotion")}];
//        [_transactionTypeArr addObject:@{@"key":@"17", @"name":LocalizationKey(@"CoinToLever")}];
//        [_transactionTypeArr addObject:@{@"key":@"18", @"name":LocalizationKey(@"LeverToCoin")}];
//        [_transactionTypeArr addObject:@{@"key":@"19", @"name":LocalizationKey(@"Walletairdrop")}];
//        [_transactionTypeArr addObject:@{@"key":@"20", @"name":LocalizationKey(@"LockPosition")}];
//        [_transactionTypeArr addObject:@{@"key":@"21", @"name":LocalizationKey(@"Unlock")}];
//        [_transactionTypeArr addObject:@{@"key":@"22", @"name":LocalizationKey(@"ThirdPartyTransfer")}];
//        [_transactionTypeArr addObject:@{@"key":@"23", @"name":LocalizationKey(@"Thirdpartyoutgoing")}];
//        [_transactionTypeArr addObject:@{@"key":@"24", @"name":LocalizationKey(@"CoinToCurrency")}];
//        [_transactionTypeArr addObject:@{@"key":@"25", @"name":LocalizationKey(@"CurrencyToCoin")}];
//        [_transactionTypeArr addObject:@{@"key":@"26", @"name":LocalizationKey(@"BorrowingTurnover")}];
//        [_transactionTypeArr addObject:@{@"key":@"27", @"name":LocalizationKey(@"Repaymentflow")}];
        
    }
    return _transactionTypeArr;
}

@end
