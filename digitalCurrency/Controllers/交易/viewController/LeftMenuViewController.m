//
//  LeftMenuViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+LeftSlide.h"
//#import "menuCell.h"
#import "marketManager.h"
#import "HomeNetManager.h"
#import "symbolModel.h"
#import "MarketNetManager.h"
#import "ZTLeftMenuTableViewCell.h"
//#import "LeftTableViewCell.h"

@interface LeftMenuViewController ()<SocketDelegate>
{
    UIButton*_currentBtn;//当前选中的按钮
    BOOL  _isDragging;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIButton *defalutBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong)NSMutableArray *contentArr;
//@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *marketsLabel;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeight.constant=SafeAreaTopHeight;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZTLeftMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTLeftMenuTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=55;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.backView1.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.backView2.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    self.backView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 37);
        }
        return UIColorMake(247, 247, 247);
    }];
    
    self.marketsLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;

    [_defalutBtn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    [self.btn2 setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    [self.btn3 setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    [self.btn4 setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];

    [_defalutBtn setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];
    [self.btn2 setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];
    [self.btn3 setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];
    [self.btn4 setTitleColor:QDThemeManager.currentTheme.themeSelectedTitleColor forState:UIControlStateSelected];
    
    _defalutBtn.selected = YES;
    _currentBtn = _defalutBtn;

    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
    // 添加从左划入的功能
    [self initSlideFoundation];
    _currentBtn=self.defalutBtn;
    self.indicatorView.hidesWhenStopped=YES;
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    // Do any additional setup after loading the view from its nib.
}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewType==ChildViewType_USDT) {
        return [marketManager shareInstance].USDTArray.count;
    }else if (self.viewType==ChildViewType_BTC){
        return [marketManager shareInstance].BTCArray.count;
    }else if (self.viewType==ChildViewType_ETH){
        return [marketManager shareInstance].ETHArray.count;
    }else{
        return [marketManager shareInstance].CollectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTLeftMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZTLeftMenuTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.viewType==ChildViewType_USDT) {
        symbolModel*model=[marketManager shareInstance].USDTArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else if (self.viewType==ChildViewType_BTC)
    {
        symbolModel*model=[marketManager shareInstance].BTCArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else if (self.viewType==ChildViewType_ETH){
        symbolModel*model=[marketManager shareInstance].ETHArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex: (int)indexPath.row];
    }else{
        symbolModel*model=[marketManager shareInstance].CollectionArray[indexPath.row];
        [cell configDataWithModel:model withtype:1 withIndex:(int)indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    ZTLeftMenuTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.viewType==ChildViewType_Collection) {
        symbolModel*model=[marketManager shareInstance].CollectionArray[indexPath.row];
        NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
       dict =[[NSDictionary alloc]initWithObjectsAndKeys:[array firstObject],@"object",[array lastObject],@"base",nil];
    }
    else{
       dict =[[NSDictionary alloc]initWithObjectsAndKeys:currentCell.currencyLabel.text,@"object",[currentCell.baseLabel.text substringFromIndex:1],@"base",nil];
    }
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    
    [marketManager shareInstance].symbol=[NSString stringWithFormat:@"%@/%@",dict[@"object"],dict[@"base"]];

    if (self.block) {
        self.block(dict[@"base"], dict[@"object"]);
    }
    [self hide];
}
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}
//点击切换数据
- (IBAction)changeData:(UIButton *)sender {
    
    if (sender!=_currentBtn) {
        _currentBtn.selected = NO;
        
        sender.selected = YES;
        _currentBtn=sender;
        self.viewType=sender.tag;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.mj_x=sender.mj_x;
            
        } completion:^(BOOL finished) {
            //            [self getData];

        }];
    }
}

#pragma mark -- show or hide
- (void)showFromLeft
{
    [self.defalutBtn setTitle:LocalizationKey(@"Collection") forState:UIControlStateNormal];
    if (self.isLever) {
        self.marketsLabel.text = LocalizationKey(@"AssetsLever");
    }else{
        self.marketsLabel.text = LocalizationKey(@"AssetsCoin");
    }
    [self show];
    [self getData];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
}
- (IBAction)hideToLeft:(id)sender {
    [self hide];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
}
kRemoveCellSeparator

//获取所有交易币种缩略行情
-(void)getData{
    [self removeAllArray];
    [self.indicatorView startAnimating];
    if (self.isLever) {
        [HomeNetManager getLeverSymbolthumbCompleteHandle:^(id resPonseObj, int code) {
            if (code) {
                if ([resPonseObj isKindOfClass:[NSArray class]]) {
                    [self.contentArr removeAllObjects];
                    NSArray*symbolArray=(NSArray*)resPonseObj;
                    for (int i=0; i<symbolArray.count; i++) {
                        symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                        [self.contentArr addObject:model];
                        NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
                        NSString*baseSymbol=[array lastObject];
                        if ([baseSymbol isEqualToString:@"USDT"]) {
                            [[marketManager shareInstance].USDTArray addObject:model];
                        }else if ([baseSymbol isEqualToString:@"BTC"])
                        {
                            [[marketManager shareInstance].BTCArray addObject:model];
                        }
                        else if ([baseSymbol isEqualToString:@"ETH"])
                        {
                            [[marketManager shareInstance].ETHArray addObject:model];
                        }
                    }
                    [marketManager shareInstance].AllCoinArray=self.contentArr;
                    if ([YLUserInfo isLogIn]) {
                        //                    if (_currentBtn.tag==3) {
                        //                        [self getPersonAllCollection];//获取全部自选
                        //                    }else{
                        //                        [self.tableView reloadData];
                        //                        [self.indicatorView stopAnimating];
                        //                        }
                        [self getPersonAllCollection];//获取全部自选
                        [self.indicatorView stopAnimating];
                    }else{
                        [self.tableView reloadData];
                        [self.indicatorView stopAnimating];
                    }
                }else{
                    [self.indicatorView stopAnimating];
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.indicatorView stopAnimating];
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }else{
        [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
            if (code) {
                if ([resPonseObj isKindOfClass:[NSArray class]]) {
                    [self.contentArr removeAllObjects];
                    NSArray*symbolArray=(NSArray*)resPonseObj;
                    for (int i=0; i<symbolArray.count; i++) {
                        symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                        [self.contentArr addObject:model];
                        NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
                        NSString*baseSymbol=[array lastObject];
                        if ([baseSymbol isEqualToString:@"USDT"]) {
                            [[marketManager shareInstance].USDTArray addObject:model];
                        }else if ([baseSymbol isEqualToString:@"BTC"])
                        {
                            [[marketManager shareInstance].BTCArray addObject:model];
                        }
                        else if ([baseSymbol isEqualToString:@"ETH"])
                        {
                            [[marketManager shareInstance].ETHArray addObject:model];
                        }
                    }
                    [marketManager shareInstance].AllCoinArray=self.contentArr;
                    if ([YLUserInfo isLogIn]) {
                        //                    if (_currentBtn.tag==3) {
                        //                        [self getPersonAllCollection];//获取全部自选
                        //                    }else{
                        //                        [self.tableView reloadData];
                        //                        [self.indicatorView stopAnimating];
                        //                        }
                        [self getPersonAllCollection];//获取全部自选
                        [self.indicatorView stopAnimating];
                    }else{
                        [self.tableView reloadData];
                        [self.indicatorView stopAnimating];
                    }
                }else{
                    [self.indicatorView stopAnimating];
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.indicatorView stopAnimating];
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }
    
}
//获取个人全部自选
-(void)getPersonAllCollection{
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self.indicatorView stopAnimating];
                [[marketManager shareInstance].CollectionArray removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    NSDictionary*dict=symbolArray[i];
//                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
//                    [[marketManager shareInstance].CollectionArray addObject:model];
                    [[marketManager shareInstance].AllCoinArray enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.symbol isEqualToString:dict[@"symbol"]]) {
                            [[marketManager shareInstance].CollectionArray addObject:obj];
                        }
                    }];
                }
                [self.tableView reloadData];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    } ];
}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
-(void)removeAllArray{
    [[marketManager shareInstance].USDTArray removeAllObjects];
    [[marketManager shareInstance].BTCArray removeAllObjects];
    [[marketManager shareInstance].ETHArray removeAllObjects];
    [[marketManager shareInstance].CollectionArray removeAllObjects];
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {
        if (endStr) {
            NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
//            NSLog(@"收到消息-%@--%@",endStr,dic);
            symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
            if (_isDragging) {
                return;
            }
            if (self.viewType==ChildViewType_USDT) {
                [[marketManager shareInstance].USDTArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].USDTArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;

                        [self.tableView reloadData];
                    }
                }];
            }
            else if (self.viewType==ChildViewType_BTC)
            {
                [[marketManager shareInstance].BTCArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].BTCArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        [self.tableView reloadData];
                    }
                }];
            }else if (self.viewType==ChildViewType_ETH){
                [[marketManager shareInstance].ETHArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].ETHArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        [self.tableView reloadData];
                    }
                }];
            }
            else{
                [[marketManager shareInstance].CollectionArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].CollectionArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        [self.tableView reloadData];
                    }
                }];
            }
            
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
