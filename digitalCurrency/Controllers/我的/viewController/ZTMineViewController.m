//
//  ZTMineViewController.m
//  exchange_ztuo
//
//  Created by chu on 2019/10/9.
//  Copyright © 2019 chu. All rights reserved.
//

#import "ZTMineViewController.h"
#import "ZQTCustomSwitch.h"
#import "UIViewController+LeftSlide.h"
#import "MineDrawerTableViewCell.h"
#import "ZTSearchCoinViewController.h"
#import "EntrustmentRecordViewController.h"
#import "HelpeCenterViewController.h"
#import "SettingCenterViewController.h"
#import "MyPromoteViewController.h"
#import "ZTFeeSettingViewController.h"
#import "AccountSettingViewController.h"
#import "AboutUSViewController.h"
#import "TurnOutViewController.h"
#import "AccountSettingInfoModel.h"
#import "MineNetManager.h"
#import "IdentityAuthenticationViewController.h"
#import "UpVideoViewController.h"

@interface ZTMineViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    NSArray *_titles;
    NSArray *_images;
    NSArray *_images_dark;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewMarginBottomConstraint;
@property (weak, nonatomic) IBOutlet QMUILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *uidBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *chongbiBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *tibiBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *huazhuanBtn;
@property (weak, nonatomic) IBOutlet UIView *midBackView;
@property (weak, nonatomic) IBOutlet QMUIButton *helpBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *shareBtn;

@property (nonatomic, strong) AccountSettingInfoModel *accountInfo;

@property (nonatomic, strong) ZQTCustomSwitch *cswitch;
@end

@implementation ZTMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([YLUserInfo isLogIn]) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"HI,%@****%@", [[YLUserInfo shareUserInfo].mobile substringWithRange:NSMakeRange(0, 3)], [[YLUserInfo shareUserInfo].mobile substringWithRange:NSMakeRange(7, 4)]];
        [self.uidBtn setTitle:[NSString stringWithFormat:@"UID:%@",[YLUserInfo shareUserInfo].ID] forState:UIControlStateNormal];
        [self.uidBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            if ([identifier isEqualToString:QDThemeIdentifierDark]) {
                return UIImageMake(@"account_copy-1");
            }
            return UIImageMake(@"account_copy");
        }] forState:UIControlStateNormal];
    }else{
        self.nicknameLabel.text = @"HI";
        [self.uidBtn setTitle:LocalizationKey(@"accounting") forState:UIControlStateNormal];
    }
    [self accountSettingData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.backView.backgroundColor = UIColor.qd_backgroundColor;
    self.bottomViewMarginBottomConstraint.constant = SafeAreaBottomHeight;
    _titles = @[LocalizationKey(@"mine_ordermanager"), LocalizationKey(@"mine_feeset"),
                LocalizationKey(@"mine_identity_authentication"),
                LocalizationKey(@"mine_promote"),
    LocalizationKey(@"mine_account"), LocalizationKey(@"mine_aboutus"), LocalizationKey(@"mine_seting")];
    _images = @[@"订单管理", @"费率设置", @"account_verification", @"邀请奖励", @"账户中心", @"关于我们", @"设置"];
    _images_dark = @[@"订单管理黑", @"费率设置黑", @"account_verification-1", @"邀请奖励黑", @"账户中心黑", @"关于我们黑", @"设置黑"];
    [self initSlideFoundation];
    ZQTCustomSwitch *Cswitch = [[ZQTCustomSwitch alloc] initWithFrame:CGRectMake(kWindowW - 80 - 30 - 60, 50, 60, 20) onColor:UIColor.qd_descriptionTextColor offColor:UIColor.qd_descriptionTextColor font:[UIFont systemFontOfSize:11] ballSize:16];
    self.cswitch = Cswitch;
    [self initSwitchUI];
    [Cswitch addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
    [self.backView addSubview:Cswitch];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineDrawerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineDrawerTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    
    self.tibiBtn.imagePosition = QMUIButtonImagePositionTop;
    self.chongbiBtn.imagePosition = QMUIButtonImagePositionTop;
    self.huazhuanBtn.imagePosition = QMUIButtonImagePositionTop;

    [self.uidBtn setImagePosition:QMUIButtonImagePositionRight];
    [self.uidBtn setSpacingBetweenImageAndTitle:5];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self initSubviews];
    _titles = @[LocalizationKey(@"mine_ordermanager"), LocalizationKey(@"mine_feeset"),
                LocalizationKey(@"mine_identity_authentication"),
                LocalizationKey(@"mine_promote"),
    LocalizationKey(@"mine_account"), LocalizationKey(@"mine_aboutus"), LocalizationKey(@"mine_seting")];
    [self.tableView reloadData];
}

- (void)initSwitchUI{
    
    self.cswitch.textColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(30, 49, 73);
        }
        return UIColorMake(247, 247, 247);
    }];
    self.cswitch.onTintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(62, 83, 108);
        }
        return UIColorMake(197, 207, 213);
    }];
    self.cswitch.tintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(62, 83, 108);
        }
        return UIColorMake(197, 207, 213);
    }];
    self.cswitch.onText = LocalizationKey(@"mine_night");
    self.cswitch.offText = LocalizationKey(@"mine_day");
    /**
     *  on 等于  YES 为打开状态 ,
     *           NO 为关闭状态
     */
    self.cswitch.thumbTintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 35);
        }
        return UIColorMake(247, 247, 247);
    }];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:QDSelectedThemeIdentifier]) {
        self.cswitch.on = YES;
    }else{
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:QDSelectedThemeIdentifier];
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            self.cswitch.on = NO;
        }else{
            self.cswitch.on = YES;
        }
    }
     

}

- (void)initSubviews{
    [super initSubviews];
    
    self.backView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.bottomView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.tableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    
    self.nicknameLabel.textColor = [QDThemeManager currentTheme].themeTitleTextColor;
    [self.chongbiBtn setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateNormal];
    [self.tibiBtn setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateNormal];
    [self.huazhuanBtn setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateNormal];
    [self.helpBtn setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[QDThemeManager currentTheme].themeTitleTextColor forState:UIControlStateNormal];
    [self.uidBtn setTitleColor:[QDThemeManager currentTheme].themeMainTextColor forState:UIControlStateNormal];

    
    [self.chongbiBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"充币黑");
        }
        return UIIMAGE(@"充币");
    }] forState:UIControlStateNormal];
    
    [self.tibiBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"提币黑");
        }
        return UIIMAGE(@"提币");
    }] forState:UIControlStateNormal];
    
    [self.huazhuanBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"划转黑");
        }
        return UIIMAGE(@"划转");
    }] forState:UIControlStateNormal];
    
    [self.helpBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"帮助黑");
        }
        return UIIMAGE(@"帮助");
    }] forState:UIControlStateNormal];
    
    [self.shareBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"分享黑");
        }
        return UIIMAGE(@"分享");
    }] forState:UIControlStateNormal];
    
    [self.tibiBtn setTitle:LocalizationKey(@"mentionMoney") forState:UIControlStateNormal];
    [self.chongbiBtn setTitle:LocalizationKey(@"chargeMoney") forState:UIControlStateNormal];
    [self.huazhuanBtn setTitle:LocalizationKey(@"transfer") forState:UIControlStateNormal];
    [self.helpBtn setTitle:LocalizationKey(@"mine_helpcenter") forState:UIControlStateNormal];
    [self.shareBtn setTitle:LocalizationKey(@"mine_shareapp") forState:UIControlStateNormal];

    
}

- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    [self initSubviews];
    [self initSwitchUI];
    [self.tableView reloadData];
}

- (void)switchPressed:(ZQTCustomSwitch *)Cswitch
{
    
    if (Cswitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Default" forKey:QDSelectedThemeIdentifier];
        QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = QDThemeIdentifierDefault;

    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"Dark" forKey:QDSelectedThemeIdentifier];
        QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = QDThemeIdentifierDark;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.view layoutSubviews];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(NSString *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineDrawerTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2) {
        if ([self.accountInfo.kycStatus isEqualToString:@"4"]) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
    }else{
        cell.hidden = NO;
    }
    
    cell.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    cell.leftImageView.image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(_images_dark[indexPath.row]);
        }
        return UIIMAGE(_images[indexPath.row]);
    }];
    cell.leftLabel.text = _titles[indexPath.row];
    cell.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 5){
        AboutUSViewController *set = [[AboutUSViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];

    }else if (indexPath.row == 6){
        SettingCenterViewController *set = [[SettingCenterViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];

    }
    
    if (![YLUserInfo isLogIn]) {
        [self showLoginViewController];
        return;
    }
    [self hide];

    if (indexPath.row == 0) {
        EntrustmentRecordViewController *record = [[EntrustmentRecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:record];
    }else if (indexPath.row == 1){
        ZTFeeSettingViewController *set = [[ZTFeeSettingViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];

    }else if(indexPath.row == 2){
        if ([self.accountInfo.kycStatus isEqualToString:@"0"] || [self.accountInfo.kycStatus isEqualToString:@"2"] || [self.accountInfo.kycStatus isEqualToString:@"5"] || [self.accountInfo.kycStatus isEqualToString:@"4"]) {
            //身份认证
            IdentityAuthenticationViewController *identityVC = [[IdentityAuthenticationViewController alloc] init];
            identityVC.identifyStatus = self.accountInfo.realVerified;
            identityVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
            identityVC.realAuditing = self.accountInfo.realAuditing;
            [[AppDelegate sharedAppDelegate] pushViewController:identityVC];
            return;
        }
        //视频认证
        UpVideoViewController *UpVideoVC = [UpVideoViewController new];
        UpVideoVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
        [[AppDelegate sharedAppDelegate] pushViewController:UpVideoVC];
    }else if (indexPath.row == 3){
        MyPromoteViewController *set = [[MyPromoteViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];

    }else if (indexPath.row == 4){
        AccountSettingViewController *set = [[AccountSettingViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:set];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        if ([self.accountInfo.kycStatus isEqualToString:@"4"]) {
            return 0;
        }
        return 50;
    }
    return 50;
}

- (IBAction)depositAction:(QMUIButton *)sender {
    [self hide];
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_charge];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (IBAction)withdrawAction:(QMUIButton *)sender {
    [self hide];
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_withdraw];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (IBAction)transferAction:(QMUIButton *)sender {
    [self hide];
    TurnOutViewController *turn = [[TurnOutViewController alloc] init];
    turn.unit = @"USDT";
    turn.from = AccountType_Coin;
    turn.to = AccountType_Curreny;
    [[AppDelegate sharedAppDelegate] pushViewController:turn];
}

- (IBAction)helpAction:(QMUIButton *)sender {
    [self hide];
    HelpeCenterViewController *help = [[HelpeCenterViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

- (IBAction)shareAction:(QMUIButton *)sender {
    [self hide];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self hide];
}
- (IBAction)uidAction:(QMUIButton *)sender {
    if ([YLUserInfo isLogIn]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [YLUserInfo shareUserInfo].ID;
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"copyscuuses" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark -- show or hide
- (void)showFromLeft
{
    [self show];
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"resPonseObj ---- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
               
                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue]==4000){

                [YLUserInfo logout];
            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
//            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

@end
