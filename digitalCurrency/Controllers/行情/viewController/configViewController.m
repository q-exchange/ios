//
//  configViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 DTD. All rights reserved.
//

#import "configViewController.h"
#import "marketCell.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "MarketViewController.h"
#import "ZTMarketHeaderView.h"

@interface configViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isDragging;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)ChildViewType childViewType;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic, strong)ZTMarketHeaderView *sectionView;;

@end

@implementation configViewController

- (instancetype)initWithChildViewType:(ChildViewType)childViewType
{
    self = [super init];
    if (self) {
        self.childViewType = childViewType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    self.view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"marketCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
    self.tableView.frame=CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaTopHeight-SafeAreaBottomHeight-40);
    self.tableView.rowHeight=60;
    if (self.childViewType==ChildViewType_USDT) {
        [self getData];
    }
    //收藏
    if (self.childViewType==ChildViewType_Collection) {
        if ([YLUserInfo isLogIn]) {
            [self getData];
//            [self getPersonAllCollection];//获取全部自选
        }else{
//            [self showLoginViewController];
        }
    }
    [self languageSetting];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowCNY) name:SHOWCNY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:SUBSCRIBE_SYMBOL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];

}
#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    self.tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    [self.tableView reloadData];
}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}
-(void)notification:(NSNotification *)noti
{
    NSString *dataStr = [[noti userInfo] objectForKey:@"param"];
    NSDictionary*dic=[SocketUtils dictionaryWithJsonString:dataStr];
    //NSLog(@"接收 userInfo传递的消息：%@",dic);
    symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
    if (_isDragging) {
        return;
    }
    if (self.childViewType==ChildViewType_USDT) {
        [[marketManager shareInstance].USDTArray enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].USDTArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
               
                [self.tableView reloadData];
            }
        }];
    }
    else if (self.childViewType==ChildViewType_BTC)
    {
        [[marketManager shareInstance].BTCArray enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].BTCArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                [self.tableView reloadData];
            }
        }];
    }else if (self.childViewType==ChildViewType_ETH){
        [[marketManager shareInstance].ETHArray enumerateObjectsUsingBlock:^(symbolModel*   obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].ETHArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                [self.tableView reloadData];
            }
        }];
    }
    else{
        [[marketManager shareInstance].CollectionArray enumerateObjectsUsingBlock:^(symbolModel*   obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                [[marketManager shareInstance].CollectionArray  replaceObjectAtIndex:idx withObject:model];
                *stop = YES;

                [self.tableView reloadData];
            }
        }];
    }
 
}

-(void)isShowCNY{
    [self.tableView reloadData];
}
#pragma mark-获取所有交易币种缩略行情
-(void)getData{
   // [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取所有交易币种缩略行情 --- %@",resPonseObj);
       // [EasyShowLodingView hidenLoding];
         [self removeAllArray];
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self removeAllArray];
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
                 [self.tableView reloadData];
                if ([YLUserInfo isLogIn]) {
                    [self getPersonAllCollection];
                }
            }else if ([resPonseObj[@"code"] integerValue] ==4000){
              
                 [YLUserInfo logout];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"networkAbnormal") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//获取个人全部自选
-(void)getPersonAllCollection{
    
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            [[marketManager shareInstance].CollectionArray removeAllObjects];
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [[marketManager shareInstance].CollectionArray removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    NSDictionary*dict=symbolArray[i];
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
            [self.view makeToast:LocalizationKey(@"networkAbnormal") duration:1.5 position:CSToastPositionCenter];
        }
    } ];
}
- (void)refreshHeaderAction{
    [self getData];
}


- (void)setUpViews
{
    [self.view addSubview:self.tableView];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.childViewType==ChildViewType_USDT) {
        return [marketManager shareInstance].USDTArray.count;
    }else if (self.childViewType==ChildViewType_BTC)
    {
       return [marketManager shareInstance].BTCArray.count;
    }else if (self.childViewType==ChildViewType_ETH){
        return [marketManager shareInstance].ETHArray.count;
    }else{
        return [marketManager shareInstance].CollectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   marketCell * cell = [tableView dequeueReusableCellWithIdentifier:@"marketCell" forIndexPath:indexPath];
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.childViewType==ChildViewType_USDT) {
        symbolModel*model=[marketManager shareInstance].USDTArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else if (self.childViewType==ChildViewType_BTC){
        symbolModel*model=[marketManager shareInstance].BTCArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex:(int)indexPath.row];
    }else if (self.childViewType==ChildViewType_ETH){
        symbolModel*model=[marketManager shareInstance].ETHArray[indexPath.row];
        [cell configDataWithModel:model withtype:0 withIndex: (int)indexPath.row];
    }else{
        symbolModel*model=[marketManager shareInstance].CollectionArray[indexPath.row];
        [cell configDataWithModel:model withtype:1 withIndex:(int)indexPath.row];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self.sectionView layoutUI];
    return self.sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    symbolModel*model;
    if (self.childViewType==ChildViewType_USDT) {
        model=[marketManager shareInstance].USDTArray[indexPath.row];
    }
    else if (self.childViewType==ChildViewType_BTC)
    {
        model=[marketManager shareInstance].BTCArray[indexPath.row];
        
    }else if (self.childViewType==ChildViewType_ETH){
        model=[marketManager shareInstance].ETHArray[indexPath.row];
    }
    else{
       model=[marketManager shareInstance].CollectionArray[indexPath.row];
    }
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.symbol=model.symbol;
    [[AppDelegate sharedAppDelegate] pushViewController:klineVC withBackTitle:model.symbol];
}
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
//更新数据
-(void)reloadData{

    if (self.childViewType==ChildViewType_USDT) {
        [self getData];

    }else if (self.childViewType==ChildViewType_BTC)
    {
        [self getData];
    }
    else if (self.childViewType==ChildViewType_ETH){
        [self getData];
    }
    else{
//        if (![YLUserInfo isLogIn]) {
//            [self showLoginViewController];
//            return ;
//        }
       [self getPersonAllCollection];
    }
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
//    [[marketManager shareInstance].CollectionArray removeAllObjects];
}

kRemoveCellSeparator
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(ZTMarketHeaderView *)sectionView{
    if (!_sectionView) {
        _sectionView = [ZTMarketHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 35)];
        [_sectionView layoutUI];
        
    }
    return _sectionView;
}

@end
