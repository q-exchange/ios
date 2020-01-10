//
//  AccountSettingViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountSettingTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MoneyPasswordViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "BindingEmailViewController.h"
#import "BindingPhoneViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "ResetPhoneViewController.h"
#import "GestureTableViewCell.h"
#import "ZLGestureLockViewController.h"
#import "UpdateIDCardViewController.h"
#import "UpVideoViewController.h"
#import "PaymentAccountViewController.h"

@interface AccountSettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL _phoneVerified;
    BOOL _emailVerified;
    BOOL _loginVerified;
    BOOL _fundsVerified;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

//上传路径
@property(nonatomic,strong) NSMutableArray *accountInfoArr;
@property(nonatomic,strong)NSMutableArray *accountColorArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) UIImage *headImage;
@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"securitySetting" value:nil table:@"English"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GestureTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GestureTableViewCell class])];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self accountSettingData];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"resPonseObj ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
               
                [self.tableView reloadData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self getNameArr][section];
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSArray *)getNameArr{

    NSArray * nameArr = @[@[[[ChangeLanguage bundle] localizedStringForKey:@"mine_phone" value:nil table:@"English"]],
  @[[[ChangeLanguage bundle] localizedStringForKey:@"mine_payment" value:nil table:@"English"],
    [[ChangeLanguage bundle] localizedStringForKey:@"mine_Fund" value:nil table:@"English"]],
                          @[[[ChangeLanguage bundle] localizedStringForKey:@"mine_gesture" value:nil table:@"English"]]];
    return nameArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = [self getNameArr][indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            if ([_accountInfo.phoneVerified isEqualToString:@"1"]) {
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"bounded" value:nil table:@"English"];
                cell.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
                _phoneVerified = YES;
            }else{
                _phoneVerified = NO;
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"];
                cell.rightLabel.textColor = UIColorMake(110, 37, 59);
            }
        }else if (indexPath.row == 1){
            if ([_accountInfo.emailVerified isEqualToString:@"1"]) {
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"bounded" value:nil table:@"English"];
                cell.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
                _emailVerified = YES;
            }else{
                _emailVerified = NO;
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"];
                cell.rightLabel.textColor = UIColorMake(110, 37, 59);
            }
        }else if (indexPath.row == 2){
            if ([_accountInfo.googleState isEqualToString:@"1"]) {
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"bounded" value:nil table:@"English"];
                cell.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
            }else{
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"];
                cell.rightLabel.textColor = UIColorMake(110, 37, 59);
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = [self getNameArr][indexPath.section][indexPath.row];
        
        if (indexPath.row == 1) {
            if ([_accountInfo.fundsVerified isEqualToString:@"1"]) {
                _fundsVerified = YES;
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"modify" value:nil table:@"English"];
                cell.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
            }else{
                _fundsVerified = NO;
                cell.rightLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"unSetting" value:nil table:@"English"];
                cell.rightLabel.textColor = UIColorMake(110, 37, 59);
            }
        }else{
            cell.rightLabel.hidden = YES;
        }
        
        return cell;
    }else{
        GestureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GestureTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([ZLGestureLockViewController gesturesPassword].length > 0) {
            cell.gestureSwitch.on=YES;
        }else{
            cell.gestureSwitch.on=NO;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001f;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
//
//        NSString *tixing = LocalizationKey(@"mine_secuLevel");
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 65, 20)];
//        label.text = tixing;
//        label.textColor = QDThemeManager.currentTheme.themeMainTextColor;;
//        label.font = [UIFont systemFontOfSize:13];
//        [view addSubview:label];
//
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, 15, 65, 20)];
//        label1.font = [UIFont systemFontOfSize:13];
//        [view addSubview:label1];
//
//        UIProgressView *progre = [[UIProgressView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame) + 10, kWindowW - 30, 2)];
//        progre.trackTintColor = QDThemeManager.currentTheme.themeBorderColor;
//        progre.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
//
//        [view addSubview:progre];
//
//        NSInteger count = 0;
//        if (_phoneVerified) {
//            count += 1;
//        }
//        if (_emailVerified) {
//            count += 1;
//        }
//        if ([_accountInfo.googleState isEqualToString:@"1"]) {
//            count += 1;
//        }
//        if (count == 1) {
//            label1.text = LocalizationKey(@"minimumest");
//            label1.textColor = UIColorMake(110, 37, 59);
//            [progre setProgress:0.33 animated:YES];
//            progre.progressTintColor = UIColorMake(110, 37, 59);
//
//        }else if (count == 2){
//            label1.text = LocalizationKey(@"mine_mid");
//            label1.textColor = UIColorMake(237, 190, 130);
//            [progre setProgress:0.66 animated:YES];
//            progre.progressTintColor = UIColorMake(237, 190, 130);
//        }else{
//            label1.text = LocalizationKey(@"highest");
//            label1.textColor = GreenColor;
//            [progre setProgress:1 animated:YES];
//            progre.progressTintColor = GreenColor;
//        }
//
//        return view;
//    }
    
    if (section == 0) {
        return [UIView new];
    }

    UIView *view = [[UIView alloc] init];
    NSString *tixing = @"";
    if (section == 1) {
        tixing = LocalizationKey(@"mine_C2Cset");
    }else{
        tixing = LocalizationKey(@"mine_otherset");
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kWindowW - 30, 19)];
    label.text = tixing;
    label.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kWindowW, 1)];
    line.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //绑定手机
            if (_phoneVerified){
                ResetPhoneViewController *resetVC = [[ResetPhoneViewController alloc] init];
                resetVC.phoneNum = self.accountInfo.mobilePhone;
                [[AppDelegate sharedAppDelegate] pushViewController:resetVC];
            }else{
                BindingPhoneViewController *phoneVC = [[BindingPhoneViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:phoneVC];
            }
        }else if (indexPath.row == 1){
            //绑定邮箱
            BindingEmailViewController *emailVC = [[BindingEmailViewController alloc] init];
            if (_emailVerified == YES) {
                emailVC.bindingStatus = 1;
                emailVC.emailStr = self.accountInfo.email;
            }else{
                emailVC.bindingStatus = 0;
            }
            [[AppDelegate sharedAppDelegate] pushViewController:emailVC];
        }else if (indexPath.row == 2){
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            //资金密码
            MoneyPasswordViewController *moneyVC = [[MoneyPasswordViewController alloc] init];
            if (_fundsVerified == YES) {
                moneyVC.setStatus = 1;
            }else{
                moneyVC.setStatus = 0;
            }
            [[AppDelegate sharedAppDelegate] pushViewController:moneyVC];
        }else if (indexPath.row == 0){
            PaymentAccountViewController *pay = [[PaymentAccountViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:pay];
        }
        
    }
}


@end
