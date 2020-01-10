//
//  LoginViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "LoginNetManager.h"
#import "YLTabBarController.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>
#import "HWTFCursorView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *userNameTF;

@property (weak, nonatomic) IBOutlet QMUITextField *passwordTF;


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowRegisterBtn;
@property (weak, nonatomic) IBOutlet UILabel *noAccountlabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomspec;

@property (weak, nonatomic) IBOutlet UIButton *eyebutton;

@property (nonatomic, assign) BOOL verifyGoogle;//是否需要谷歌验证 默认NO
@property (nonatomic, copy) NSString *randstr;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *code;
@property (weak, nonatomic) IBOutlet UIView *line3;

@property (weak, nonatomic) IBOutlet QMUILinkButton *psLoginBtn;
@property (weak, nonatomic) IBOutlet QMUILinkButton *codeLoginBtn;

#define isRemember @"isRemember"
#define rememberPassword @"rememberPassword"
#define rememberUsername @"rememberUsername"

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewHeightConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:rememberUsername]) {
        self.userNameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:rememberUsername];
    }
    self.code = @"";
    self.userNameTF.placeholder = LocalizationKey(@"phoneNum");
    self.passwordTF.placeholder = LocalizationKey(@"password");
    self.codeTF.placeholder = LocalizationKey(@"inputPhoneCode");

    [self setNavigationControllerStyle];
    [self leftbutitem];
    self.bottomspec.constant = SafeAreaBottomHeight + 10;

    self.noAccountlabel.text = LocalizationKey(@"noAccount");
    
    // Do any additional setup after loading the view from its nib.
    [self.loginBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
    [self.forgetPwdBtn setTitle:LocalizationKey(@"forgetPassword") forState:UIControlStateNormal];
    [self.nowRegisterBtn setTitle:LocalizationKey(@"nowregister") forState:UIControlStateNormal];
    [self.psLoginBtn setTitle:LocalizationKey(@"mine_passwordlogin") forState:UIControlStateNormal];
    [self.codeLoginBtn setTitle:LocalizationKey(@"mine_smslogin") forState:UIControlStateNormal];
    [self.codeBtn setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];

    self.codeLoginBtn.underlineHidden = YES;
    self.codeView.hidden = YES;
    self.codeViewHeightConstraint.constant = 0;
    [self layoutUI];
    
}
- (IBAction)codeAction:(UIButton *)sender {
    if ([NSString stringIsNull:self.userNameTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobile") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [self getphonncode];
}

//获取手机验证码
-(void)getphonncode{
    [self.view endEditing:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/mobile/login/send"];
    NSDictionary *param = @{@"phone":self.userNameTF.text};
    
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param contentType:@"application/x-www-form-urlencoded;charset=UTF-8" ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取验证码 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                //发送短信验证码成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [APPLICATION.window makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
                });
                __block int timeout=60; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeBtn setTitle:LocalizationKey(@"sendValidate") forState:UIControlStateNormal];
                            self.codeBtn.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = timeout % 90;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.codeBtn setTitle: [NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                            self.codeBtn.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }else{
                [APPLICATION.window makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

- (void)layoutUI{
    self.view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.codeView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;

    self.userNameTF.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.passwordTF.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.codeTF.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.noAccountlabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;

    self.userNameTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.passwordTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.codeTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;

    self.line1.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.line2.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    self.line3.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    [self.forgetPwdBtn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateNormal];
    [self.nowRegisterBtn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateNormal];

    [self.psLoginBtn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateNormal];
    [self.codeLoginBtn setTitleColor:[QDThemeManager currentTheme].themeSelectedTitleColor forState:UIControlStateNormal];
    
    self.psLoginBtn.underlineInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    self.codeLoginBtn.underlineInsets = UIEdgeInsetsMake(10, 0, 0, 0);

}

//是否显示密码
- (IBAction)openeyeaction:(id)sender {
    self.eyebutton.selected = !self.eyebutton.selected;
    self.passwordTF.secureTextEntry = !self.eyebutton.selected;
}

-(void)leftbutitem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    [btn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isRemember]) {
        self.passwordTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:rememberPassword];
        self.userNameTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:rememberUsername];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:QDThemeManager.currentTheme.themeBackgroundColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self setNavigationControllerStyle];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
//    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:NavColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
//    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}
-(void)RighttouchEvent{
    if (self.pushOrPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self cancelNavigationControllerStyle];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)changeLoginState:(QMUILinkButton *)sender {
    if (sender.tag == 100) {
        self.codeView.hidden = YES;
        self.codeViewHeightConstraint.constant = 0;
        sender.underlineHidden = NO;
        self.codeLoginBtn.underlineHidden = YES;
    }else{
        self.codeView.hidden = NO;
        self.codeViewHeightConstraint.constant = 45;
        sender.underlineHidden = NO;
        self.psLoginBtn.underlineHidden = YES;
    }
}

- (IBAction)touchEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 0://登录
            //[self ToLogin];
            break;
        case 1://忘记密码
            [self.navigationController pushViewController:[[ForgetViewController alloc]initWithNibName:@"ForgetViewController" bundle:nil] animated:YES];
            
            break;
        case 2://注册
            [self.navigationController pushViewController:[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil] animated:YES];
            break;
            
        default:
            break;
    }
}
- (IBAction)loginAction:(UIButton *)sender {
    if ([NSString stringIsNull:self.userNameTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobileEmail") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.passwordTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputLoginPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self getGoogle];
//    __weak typeof(self)weakself = self;
//    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:[UIApplication sharedApplication].keyWindow appid:@"2038419167" callback:^(NSDictionary *resultJSON) {
//        NSLog(@"resultJSON -- %@",resultJSON);
//        if(0==[resultJSON[@"ret"] intValue]){
//            weakself.ticket = resultJSON[@"ticket"];
//            weakself.randstr = resultJSON[@"randstr"];
//
//        }
//    }];
}

- (void)showGoogleVerifyView{
    UIView *contrainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW - 40, 150)];
    contrainer.backgroundColor = [UIColor whiteColor];
    contrainer.layer.cornerRadius = 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, contrainer.frame.size.width - 20, 20)];
    label.text = LocalizationKey(@"enterGoogleCode");
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [contrainer addSubview:label];
    __weak typeof(self)weakself = self;
    HWTFCursorView *code4View = [[HWTFCursorView alloc] initWithCount:6 margin:20];
    code4View.frame = CGRectMake(0, 0, contrainer.frame.size.width - 40, 50);
    code4View.center = contrainer.center;
    code4View.backgroundColor = mainColor;
    code4View.block = ^(NSString * _Nonnull code) {
        [GKCover hideCover];
        weakself.code = code;
        [weakself login];
    };
    [contrainer addSubview:code4View];
    
    [GKCover coverFrom:[UIApplication sharedApplication].keyWindow contentView:contrainer style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleCenter showAnimStyle:GKCoverShowAnimStyleBottom hideAnimStyle:GKCoverHideAnimStyleBottom notClick:YES showBlock:^{
        
    } hideBlock:^{
        
    }];
}

- (void)login{
    if (self.codeLoginBtn.underlineHidden == NO) {
        [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
        NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/login/phone"];
        NSDictionary *param = @{};
        if ([NSString stringIsNull:self.code]) {
            param = @{@"phone":self.userNameTF.text, @"msgCode":self.codeTF.text, @"ticket":self.ticket, @"randStr":self.randstr};
        }else{
            param = @{@"phone":self.userNameTF.text, @"msgCode":self.codeTF.text, @"ticket":self.ticket, @"randStr":self.randstr, @"code":self.code};
        }
        NSLog(@"param -- %@",param);
        [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
            [EasyShowLodingView hidenLoding];
            NSLog(@"登录 ---- %@",responseResult);
            if ([responseResult objectForKey:@"resError"]) {
                NSError *error = responseResult[@"resError"];
                [self.view makeToast:error.localizedDescription];
            }else{
                if ([responseResult[@"code"] integerValue] == 0) {
                    [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];//存储登录信息

                    [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:rememberPassword];
                    [[NSUserDefaults standardUserDefaults] setValue:self.userNameTF.text forKey:rememberUsername];

                    [[NSUserDefaults standardUserDefaults] synchronize];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [keychianTool saveToKeychainWithUserName:self.userNameTF.text withPassword:self.passwordTF.text];
                    });
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//订阅聊天
                    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[YLUserInfo shareUserInfo].token forKey:executableFile];
                    [defaults synchronize];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.enterType==1) {
                            YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
                            APPLICATION.window.rootViewController = SectionTabbar;
                        }else{
                            if (self.pushOrPresent) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                    });
                }else{
                    [self.view makeToast:responseResult[@"message"]];
                }
            }
        }];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/login"];
    NSDictionary *param = @{};
    if ([NSString stringIsNull:self.code]) {
        param = @{@"username":self.userNameTF.text, @"password":self.passwordTF.text, @"ticket":self.ticket, @"randStr":self.randstr};
    }else{
        param = @{@"username":self.userNameTF.text, @"password":self.passwordTF.text, @"ticket":self.ticket, @"randStr":self.randstr, @"code":self.code};
    }
    NSLog(@"param -- %@",param);
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"登录 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];//存储登录信息

                [[NSUserDefaults standardUserDefaults] setValue:self.passwordTF.text forKey:rememberPassword];
                [[NSUserDefaults standardUserDefaults] setValue:self.userNameTF.text forKey:rememberUsername];

                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [keychianTool saveToKeychainWithUserName:self.userNameTF.text withPassword:self.passwordTF.text];
                });
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//订阅聊天
                NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[YLUserInfo shareUserInfo].token forKey:executableFile];
                [defaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.enterType==1) {
                        YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
                        APPLICATION.window.rootViewController = SectionTabbar;
                    }else{
                        if (self.pushOrPresent) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                });
            }else{
                [self.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

#pragma mark - 判断用户是否打开谷歌验证
- (void)getGoogle{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/get/user"];
    NSDictionary *param = @{@"mobile":self.userNameTF.text};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"判断用户是否打开谷歌验证 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
//            NSError *error = responseResult[@"resError"];
//            [weakself.view makeToast:error.localizedDescription];
            weakself.verifyGoogle = NO;
            if (weakself.verifyGoogle) {
                [weakself showGoogleVerifyView];
            }else{
                [weakself login];
            }
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] integerValue] == 1) {
                    weakself.verifyGoogle = YES;
                }else{
                    weakself.verifyGoogle = NO;
                }
                
                if (weakself.verifyGoogle) {
                    [weakself showGoogleVerifyView];
                }else{
                    [weakself login];
                }
            }else{
                weakself.verifyGoogle = NO;
//                [weakself.view makeToast:responseResult[@"message"]];
                if (weakself.verifyGoogle) {
                    [weakself showGoogleVerifyView];
                }else{
                    [weakself login];
                }
            }
        }
    }];
}


@end
