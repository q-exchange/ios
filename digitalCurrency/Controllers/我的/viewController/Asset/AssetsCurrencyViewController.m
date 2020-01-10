//
//  AssetsCurrencyViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AssetsCurrencyViewController.h"
#import "WalletManageTableHeadView.h"
#import "WalletManageTableViewCell.h"
#import "MineNetManager.h"
#import "WalletManageModel.h"
#import "AccountSettingInfoModel.h"
#import "ChargeMoneyViewController.h"
#import "MentionMoneyViewController.h"
#import "UIView+LLXAlertPop.h"
#import "TurnOutViewController.h"
#import "LTScrollView-Swift.h"

#import "ZTAssetsTotalBalanceTableViewCell.h"
#import "ZTCoinDetailsViewController.h"

@interface AssetsCurrencyViewController ()<UITableViewDelegate, UITableViewDataSource,QMUITextFieldDelegate>
{
    BOOL _refreshFlag;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property(nonatomic,strong) WalletManageTableHeadView *sectionHeader;

@property(nonatomic,strong)NSMutableArray *walletManageArr;
@property(nonatomic,assign)NSInteger selectIndex;//0未隐藏 1 隐藏
@property(nonatomic,assign)NSInteger searchIndex;//0未搜索 1 搜索
@property(nonatomic,assign)NSInteger flagIndex;//1搜索 2隐藏 0没有
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,strong)NSMutableArray *searchArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;

@property(nonatomic,strong)NSIndexPath *clickIndexPath;
@property(nonatomic,strong)WalletManageModel *clickModel;

@property (nonatomic, assign) BOOL isHidden;

@end

@implementation AssetsCurrencyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
//    [self accountSettingData];
}

- (void)reload
{
    [self getData];
    [self accountSettingData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MainBackColor;
    self.assetUSD = @"0.00000000";
    self.assetCNY = @"0.00";
    [self.view addSubview:self.tableView];
    self.glt_scrollView = self.tableView;

    self.tableView.estimatedRowHeight = 44;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.selectArr = [[NSMutableArray alloc] init];
    self.searchArr = [[NSMutableArray alloc] init];
    self.selectIndex = 0;
    self.searchIndex = 0;
    self.flagIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eyeStatusChange:)name:@"AsertEyeStatusChange" object:nil];

}

- (void)eyeStatusChange:(NSNotification *)nofi{
    NSNumber *selected = nofi.userInfo[@"change"];
    self.isHidden = [selected boolValue];
    [self.tableView reloadData];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (_selectIndex == 0){
        if (_searchIndex == 0) {
            return _walletManageArr.count;
        }else{
            return _searchArr.count;
        }
    }else{
        if (_searchIndex == 0) {
            return _selectArr.count;
        }else{
            if (_flagIndex == 1) {
                return _searchArr.count;
            }else{
                return _selectArr.count;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZTAssetsTotalBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTAssetsTotalBalanceTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        cell.titleLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
        cell.totalLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        cell.cnyLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
        cell.sepView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            if ([identifier isEqualToString:QDThemeIdentifierDark]) {
                return UIColorMake(8, 23, 37);
            }
            return UIColorMake(247, 247, 247);
        }];
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@（USDT）", LocalizationKey(@"assert_C2Cbalances")];
        cell.totalLabel.text = [ToolUtil interceptTheEightBitsAfterDecimalPoint:self.assetUSD];
        cell.cnyLabel.text = [NSString stringWithFormat:@"≈ %@ CNY", [ToolUtil interceptTheTwoBitsAfterDecimalPoint:self.assetCNY]];
        if (self.isHidden) {
            cell.totalLabel.text = @"******";
            cell.cnyLabel.text = @"******";
        }
        return cell;
    }else{
        WalletManageModel *model;
        if (_selectIndex == 0){
            if (_searchIndex == 0) {
                model = _walletManageArr[indexPath.row];
            }else{
                model = _searchArr[indexPath.row];
            }
        }else{
            if (_searchIndex == 0) {
                model = _selectArr[indexPath.row];
            }else{
                if (_flagIndex == 1) {
                    model = _searchArr[indexPath.row];
                }else{
                    model = _selectArr[indexPath.row];
                }
            }
        }
        
        WalletManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletManageTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.index = indexPath;
        cell.model = model;
        
        if (self.isHidden) {
            cell.availableNum.text = @"*****";
            cell.freezeNum.text = @"*****";
            cell.lockingNum.text = @"*****";
        }
        
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc] init];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 40)];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [view addSubview:self.sectionHeader];
    [self.sectionHeader layoutUI];
    self.sectionHeader.selectBtnLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"hidden0Currency" value:nil table:@"English"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        WalletManageModel *model;
        if (_selectIndex == 0){
            if (_searchIndex == 0) {
                model = _walletManageArr[indexPath.row];
            }else{
                model = _searchArr[indexPath.row];
            }
        }else{
            if (_searchIndex == 0) {
                model = _selectArr[indexPath.row];
            }else{
                if (_flagIndex == 1) {
                    model = _searchArr[indexPath.row];
                }else{
                    model = _selectArr[indexPath.row];
                }
            }
        }
        
        if ([model.clickIndex isEqualToString:@"1"]) {
            model.clickIndex = @"0";
        }else{
            model.clickIndex = @"1";
        }
        
        ZTCoinDetailsViewController *detail = [[ZTCoinDetailsViewController alloc] init];
        detail.model = model;
        [[AppDelegate sharedAppDelegate] pushViewController:detail];
    }
    
}


//MARK:--隐藏为0的币种
-(void)selectBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.flagIndex = 2;
        _selectIndex = 1;
        //被选择
        [self.sectionHeader.selectButton setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateNormal];
        [_selectArr removeAllObjects];
        if (_searchIndex == 0) {
            //未搜索
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }else if (_searchIndex == 1) {
            //搜索
            for (WalletManageModel *model in _searchArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }
    }else{
        self.flagIndex = 0;
        //未被选择
        [self.sectionHeader.selectButton setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
        [self.selectArr removeAllObjects];
        if (_searchIndex == 0) {
            //未搜索
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }else if (_searchIndex == 1) {
            //搜索
            for (WalletManageModel *model in _searchArr) {
                if ([model.balance floatValue] > 0) {
                    [self.selectArr addObject:model];
                }
            }
        }
        _selectIndex = 0;
    }
    [self.tableView reloadData];
}

//MARK:---获取我的钱包所有数据
-(void)getData{
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/otc/wallet/get"];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:nil contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取法币账户 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription duration:1.5 position:CSToastPositionCenter];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [self.walletManageArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
                NSDecimalNumber *ass2 = [[NSDecimalNumber alloc] initWithString:@"0"];
                [self.walletManageArr addObjectsFromArray:dataArr];
                for (WalletManageModel *walletModel in dataArr) {
                    //计算总资产
                    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:walletModel.balance];
                    NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.usdRate];
                    NSDecimalNumber *cnyRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.cnyRate];
                    
                    ass1 = [ass1 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle] withBehavior:handle];
                    ass2 = [ass2 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:cnyRate withBehavior:handle] withBehavior:handle];
                }
                self.assetUSD = [ass1 stringValue];
                self.assetCNY = [ass2 stringValue];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];

//                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"]];
            }
        }
    }];
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取用户信息 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldValueChanged:(QMUITextField *)textField {
    if (textField.text.length <= 0) {
        //不处理
        self.flagIndex = 0;
        _searchIndex = 0;
        
    }else{
        self.flagIndex = 1;
        [self.searchArr removeAllObjects];
        //小写转大写
        NSString *transformString = [textField.text uppercaseString];
        if (_selectIndex == 0) {
            //未隐藏
            for (WalletManageModel *model in _walletManageArr) {
                if ([model.coin.unit containsString:transformString]) {
                    [self.searchArr addObject:model];
                }
            }
        }else if (_selectIndex == 1) {
            //已隐藏
            for (WalletManageModel *model in _selectArr) {
                if ([model.coin.unit containsString:transformString]) {
                    [self.searchArr addObject:model];
                }
            }
        }
        _searchIndex = 1;
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_TabBar) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WalletManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletManageTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ZTAssetsTotalBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTAssetsTotalBalanceTableViewCell"];
    }
    return _tableView;
}

- (WalletManageTableHeadView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[WalletManageTableHeadView alloc] instancetableHeardViewWithFrame:CGRectMake(0, 0, kWindowW, 40)];
        _sectionHeader.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        [_sectionHeader.selectButton addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sectionHeader.textField.delegate = self;
        [_sectionHeader.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _sectionHeader;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)walletManageArr{
    if (!_walletManageArr) {
        _walletManageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _walletManageArr;
}
@end
