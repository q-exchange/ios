//
//  HomeViewController.m
//  ZTuo
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ZTuoKEJI. All rights reserved.
//

#import "HomeViewController.h"
#import "messageViewController.h"
#import "KJBannerView.h"
#import "symbolModel.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "bannerModel.h"
#import "pageScrollView.h"
#import "MineNetManager.h"
#import "PlatformMessageModel.h"
#import "listCell.h"
#import "SecondHeader.h"
#import "ChatGroupMessageViewController.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "PlatformMessageDetailViewController.h"
#import "Marketmodel.h"
#import "RegisterViewController.h"
#import "ZLGestureLockViewController.h"
#import "GestureViewController.h"
#import "HomeRecommendTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
#import "VersionUpdateModel.h"
#import "ZTNoticeTableViewCell.h"

#import "ZTHomeBottomTableViewCell.h"
#import "ZTMineViewController.h"

@interface HomeViewController ()<SocketDelegate,chatSocketDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    CGFloat _endDeceleratingOffset;//停止滚动的偏移量
    BOOL _comeIn;
}
@property (nonatomic, strong)NSMutableArray *contentArr;
@property (nonatomic, strong)NSMutableArray *bannerArr;
@property (nonatomic, strong)KJBannerView *bannerView;
@property (nonatomic, copy)NSMutableArray *platformMessageArr;
@property (nonatomic, strong)ChatGroupInfoModel *groupInfoModel;
@property (nonatomic, strong)UIImageView *tipImageView;
@property (nonatomic, strong)Marketmodel *marketmodel;
@property (nonatomic, strong)SecondHeader *sectionView;
@property (nonatomic, strong)VersionUpdateModel *versionModel;

@property (nonatomic, strong) ZTMineViewController *menu;
@end

@implementation HomeViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
    [self getNotice];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    [self leftItem];
    [self setTablewViewHeard];
    [self headRefreshWithScrollerView:self.tableView];
    [self getBannerData];
    [self getUSDTToCNYRate];
    [self getDefaultSymbol];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchImageViewDismiss) name:@"launchImageViewDismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];

}

#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    self.tableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.bannerView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;

    [self.sectionView layoutUI];
    
    [self.tableView reloadData];
}

- (void)launchImageViewDismiss{
    [self gesturePassword];
    [self versionUpdate];
}

#pragma mark - 提示用户开启手势密码
- (void)gesturePassword{
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        //已经创建手势密码
    }else{
        //提示用户开启手势密码
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kShowGesturePassword]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 200, 20);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:LocalizationKey(@"noLongerReminding") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(Nolongerreminding:) forControlEvents:UIControlEventTouchUpInside];
            
            [LEEAlert alert].config
            .LeeHeaderColor([UIColor whiteColor])
            .LeeAddTitle(^(UILabel *label) {
                label.text = LocalizationKey(@"warmPrompt");
                label.textColor = RGBOF(0x333333);
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = LocalizationKey(@"RemindingMessage");
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = RGBOF(0x333333);
            })
            .LeeAddCustomView(^(LEECustomView *custom) {
                
                custom.view = btn;
                
                custom.positionType = LEECustomViewPositionTypeLeft;
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, -10, 0))
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"ok");
                action.titleColor = RGBOF(0x333333);
                action.font = [UIFont systemFontOfSize:16];
                action.clickBlock = ^{
                    GestureViewController *safeVC = [[GestureViewController alloc] init];
                    [[AppDelegate sharedAppDelegate] pushViewController:safeVC];
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"cancel");
                action.titleColor = RGBOF(0x333333);
                action.font = [UIFont systemFontOfSize:16];
            })
            .LeeShow();
        }
    }
}

- (void)Nolongerreminding:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:kShowGesturePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)leftItem{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"头像黑天");
        }
        return UIIMAGE(@"头像白天");
    }];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:imageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMine)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

- (void)showMine{
    self.menu = [[ZTMineViewController alloc]initWithNibName:@"ZTMineViewController" bundle:nil];
    CGRect frame = self.menu.view.frame;
    frame.origin.x = - CGRectGetWidth(self.view.frame);
    self.menu.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  kWindowW, kWindowH);
    [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    [self.menu showFromLeft];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self getBannerData];
    [self getNotice];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (!_comeIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageViewDismiss" object:nil];
        _comeIn = YES;
    }
    
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate = self;
    }
    NSMutableArray *chatGroupArr = [ChatGroupFMDBTool getChatGroupDataArr];
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if ([infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = NO;
        }
    }
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if (![infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = YES;
        }
    }
}


-(void)setTablewViewHeard{
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"listCell" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZTNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTNoticeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZTHomeBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTHomeBottomTableViewCell"];

    
    UIView *hedaview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150)];
    hedaview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    if (self.bannerArr.count > 0) {
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
        for (bannerModel *model in self.bannerArr) {
            [muArr addObject:model.url];
        }
        self.bannerView.imageDatas = muArr;
    }
    [hedaview addSubview:self.bannerView];
    //轮播图事件方法
    __weak typeof(self)weakself = self;
    self.bannerView.kSelectBlock = ^(KJBannerView * _Nonnull banner, NSInteger idx) {
        bannerModel *model = weakself.bannerArr[idx];
        if (model.linkUrl) {
            NSURL *url = [NSURL URLWithString:model.linkUrl];
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {
                                                     
                                                 }];
                    } else {
                        
                    }
                } else {
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    if (success) {
                        
                    }else{
                        
                    }
                }
                
            } else {
                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                if(can){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    };

    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
    self.tableView.tableHeaderView=hedaview ;
    self.tableView.tableFooterView=[UIView new];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section==2) {
        return 110;
    }else if (indexPath.section == 1){
        return 115;
    }else if (indexPath.section == 0){
        return 40;
    }else{
        return 50;
    }
}
-(void)configUrlArrayWithModelArray:(NSMutableArray*)array{
    NSMutableArray*urlArray=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        bannerModel*model=array[i];
        [urlArray addObject:model.url];
    }
    self.bannerView.imageDatas = urlArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        if (self.contentArr.count > 0) {
            NSArray *arr = [self.contentArr lastObject];
            return arr.count;
        }
        return 0;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        ZTNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTNoticeTableViewCell"];
        if (!cell) {
            cell = [[ZTNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZTNoticeTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
        if (self.platformMessageArr.count > 0) {
            cell.dataSource = self.platformMessageArr;
        }
        return cell;
    }else if (indexPath.section==1) {
        HomeRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[HomeRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.contentArr.count > 0) {
            cell.dataSourceArr = [self.contentArr firstObject];
        }
        return cell;

    }else if (indexPath.section == 2){

        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell" forIndexPath:indexPath];
        [cell layoutUI];

        cell.ContractBlock = ^{
            [[UIApplication sharedApplication].keyWindow makeToast:LocalizationKey(@"not_yet_open") duration:1.5 position:CSToastPositionCenter];

//            [self.tabBarController setSelectedIndex:3];
        };
        return cell;
    }else{
        
        listCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.contentArr.count>0) {
            [cell configModel:[self.contentArr lastObject] withIndex:(int)indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==3) {
        symbolModel*model=[self.contentArr lastObject][indexPath.row];
        KchatViewController*klineVC=[[KchatViewController alloc]init];
        klineVC.symbol=model.symbol;
        [[AppDelegate sharedAppDelegate] pushViewController:klineVC withBackTitle:model.symbol];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark-自定义section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 70;
    }
    return 0.0001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3){
        self.sectionView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
        return self.sectionView;
    }else{
        UIView * headview = [[UIView alloc]init];
        return headview;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(SecondHeader *)sectionView{
    if (!_sectionView) {
        _sectionView = [SecondHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 70)];
        [_sectionView layoutUI];
        _sectionView.btn1.selected = YES;
        __weak typeof(self)weakself = self;
        _sectionView.block = ^(UIButton *sender) {
        };
    }
    return _sectionView;
}
#pragma mark-下拉刷新数据
- (void)refreshHeaderAction{
    [self getBannerData];
    [self getData];
    [self getDefaultSymbol];
}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==SUBSCRIBE_GROUP_CHAT) {
        NSLog(@"订阅聊天组成功");
    }
    else if (cmd==UNSUBSCRIBE_GROUP_CHAT) {
        NSLog(@"取消订阅聊天组成功");
    }
    else if (cmd==SEND_CHAT) {//发送消息
        if (endStr) {
            NSLog(@"发送消息--%@-收到的回复命令--%d",endStr,cmd);
        }
    }
    else if (cmd==PUSH_GROUP_CHAT)//收到消息
    {
        if (endStr) {
            NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
            //            NSLog(@"接受消息--收到的回复-%@--%d--",dic,cmd);
            _groupInfoModel = [ChatGroupInfoModel mj_objectWithKeyValues:dic];
            //存入数据库
            //NSLog(@"--%@",_groupInfoModel.content);
            [ChatGroupFMDBTool createTable:_groupInfoModel withIndex:1];
            [self setSound];
            self.tipImageView.hidden = NO;
        }
    }else{
        //        NSLog(@"首页聊天消息-%@--%d",endStr,cmd);
    }
}
//MARK:--设置音效
-(void)setSound{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"m_click" withExtension:@"wav"];
    //对该音效标记SoundID
    SystemSoundID soundID1 = 0;
    //加载该音效
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID1);
    //播放该音效
    AudioServicesPlaySystemSound(soundID1);
}

#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {

        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
        //推荐
        if (self.contentArr.count>0) {
            NSMutableArray*recommendArr = (NSMutableArray*)self.contentArr[0];
            [recommendArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [recommendArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                   
                    [self.tableView reloadData];
                }
            }];
            //涨幅榜
            if (self.contentArr.count < 1) {
                return;
            }
            NSMutableArray*changeRankArr = (NSMutableArray*)self.contentArr[1];
            [changeRankArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [changeRankArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                    [self.tableView reloadData];
                }
            }];
        }
    }else if (cmd==UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(@"取消订阅首页消息");
        
    }else{
        
    }
    //    NSLog(@"首页消息-%@--%d",endStr,cmd);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.y;
    _endDeceleratingOffset = offsetX;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat offsetX = scrollView.contentOffset.y;
        if (offsetX > 0) {
            self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:QDThemeManager.currentTheme.themeSeparatorColor Size:CGSizeMake(kWindowW, 1)];
        }else{
            self.navigationController.navigationBar.shadowImage = [UIImage new];
        }
    }
}

#pragma mark - 版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"app_Version ---- %@",app_Version);
                if ([app_Version compare:_versionModel.version] == NSOrderedSame ||[app_Version compare:_versionModel.version] == NSOrderedDescending) {
                    //不需要更新
                    
                }else{
                    [LEEAlert alert].config
                    .LeeTitle(LocalizationKey(@"warmPrompt"))
                    .LeeAddContent(^(UILabel *label) {
                        label.text = LocalizationKey(@"newVersion");
                        label.font = [UIFont systemFontOfSize:16];
                    })
                    .LeeAddAction(^(LEEAction *action) {
                        action.title = LocalizationKey(@"ok");
                        action.titleColor = RGBCOLOR(43, 43, 43);
                        action.font = [UIFont systemFontOfSize:16];
                        action.clickBlock = ^{
                            //版本更新
                            NSURL *url = [NSURL URLWithString:_versionModel.downloadUrl];
                            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                    if (@available(iOS 10.0, *)) {
                                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                                 completionHandler:^(BOOL success) {
                                                                     
                                                                 }];
                                    } else {
                                        
                                    }
                                } else {
                                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                                    if (success) {
                                        
                                    }else{
                                        
                                    }
                                }
                                
                            } else{
                                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                                if(can){
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                            }
                        };
                    })
                    .LeeShow();
                }
                
            }else if ([resPonseObj[@"code"] integerValue]==4000||[resPonseObj[@"code"] integerValue]==3000){
                
            }else if ([resPonseObj[@"code"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                
            }
        }else{
            
        }
    }];
    
}

#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate = [NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 获取默认交易对
- (void)getDefaultSymbol{
    __weak typeof(self)weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"market/default/symbol"];
    [[XBRequest sharedInstance] getDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取默认交易对 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *data = responseResult[@"data"];
                    if (![marketManager shareInstance].symbol) {
                        [marketManager shareInstance].symbol = data[@"app"];//默认第一个
                    }
                }
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

#pragma mark-获取首页推荐信息
-(void)getData{
    [HomeNetManager HomeDataCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取首页推荐信息 --- %@",resPonseObj);
        [self.contentArr removeAllObjects];
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *recommendArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"recommend"]];
            NSMutableArray *muarr = [NSMutableArray arrayWithCapacity:0];
            NSArray *changeRankArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"changeRank"]];
            [muarr addObjectsFromArray:changeRankArr];

            if (changeRankArr&&recommendArr) {
                [self.contentArr addObject:recommendArr];//推荐
                [self.contentArr addObject:muarr];//涨幅榜

                [self.tableView reloadData];
            }
        }else{
            
        }
    }];
}

#pragma mark - 获取轮播图
-(void)getBannerData{
    [HomeNetManager advertiseBannerCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"首页轮播图 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.bannerArr removeAllObjects];
                [self.bannerArr addObjectsFromArray:[bannerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]]];
                if (self.bannerArr.count>0) {
                    [self configUrlArrayWithModelArray:self.bannerArr];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark-获取平台消息
-(void)getNotice{
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.platformMessageArr removeAllObjects];
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in arr) {
                    [muArr addObject:dic];
                }
                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
                [self.platformMessageArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}

#pragma mark - LayzLoad
- (KJBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[KJBannerView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150)];
        _bannerView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
        _bannerView.imgCornerRadius = 10;
        _bannerView.autoScrollTimeInterval = 2;
        _bannerView.isZoom = YES;
        _bannerView.itemSpace = - 15;
        _bannerView.itemWidth = kWindowW - 70;
        _bannerView.imageType = KJBannerViewImageTypeMix;
    }
    return _bannerView;
}

- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArr;
}

- (NSMutableArray *)platformMessageArr {
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray array];
    }
    return _platformMessageArr;
}

@end
