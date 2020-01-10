//
//  ZTSearchCoinViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/10/15.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTSearchCoinViewController.h"
#import "WalletManageModel.h"
#import "MineNetManager.h"
#import "ZTSearchTableViewCell.h"
#import "ChargeMoneyViewController.h"
#import "MentionMoneyViewController.h"

@interface ZTSearchCoinViewController ()<UITableViewDelegate, UITableViewDataSource, QMUITextFieldDelegate>
{
    NSMutableArray *totalArr;
    UITableView *mTableView;
    NSMutableDictionary *cityDict;
    NSMutableArray *searchArr;//搜索到的内容
    NSMutableArray *citys;
    NSMutableArray *saveArr;//要保存的数据
    UISearchBar *mSearchBar;
    NSMutableArray *selectIndexs;//多选选中的行
}

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *showDataSourceArr;
@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, assign) SearchType searchType;

@end

@implementation ZTSearchCoinViewController

- (instancetype)initWithType:(SearchType)type{
    if (self = [super init]) {
        self.searchType = type;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.naviView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController.navigationBar addSubview:self.naviView];

    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *arr = self.showDataSourceArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = self.indexArr[section];
    return str;
}
//索引 数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArr;
}
//索引 点击
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    NSLog(@"%@ -- %ld", title,(long)index);

    return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 37);
        }
        return UIColorMake(247, 247, 247);
    }];;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.indexArr[section];
    label.textColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    [header addSubview:label];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTSearchTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WalletManageCoinInfoModel *model = self.showDataSourceArr[indexPath.section][indexPath.row];
    
    cell.titleLabel.text = model.unit;
    cell.titleLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    cell.lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    cell.contentView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WalletManageCoinInfoModel *model = self.showDataSourceArr[indexPath.section][indexPath.row];
    
    if (self.searchType == SearchType_charge) {
        //充币
        if ([model.canRecharge isEqualToString:@"1"]) {
            //可以充币
            if (self.delegate && [self.delegate respondsToSelector:@selector(selCoinFinish:)]) {
                [self.delegate selCoinFinish:model.unit];
                [[AppDelegate sharedAppDelegate] popViewController];
            }else{
                ChargeMoneyViewController *chargeVC = [[ChargeMoneyViewController alloc] init];
                chargeVC.unit = model.unit;
                [[AppDelegate sharedAppDelegate] pushViewController:chargeVC];
            }
            
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:LocalizationKey(@"assert_cannotcharge") duration:1.5 position:CSToastPositionCenter];
        }
    }else if (self.searchType == SearchType_withdraw){
        //提币
        if ([model.canWithdraw isEqualToString:@"1"]) {
            //可以提币
            if (self.delegate && [self.delegate respondsToSelector:@selector(selCoinFinish:)]) {
                [self.delegate selCoinFinish:model.unit];
                [[AppDelegate sharedAppDelegate] popViewController];
            }else{
                MentionMoneyViewController *mentionVC = [[MentionMoneyViewController alloc] init];
                mentionVC.unit = model.unit;
                [[AppDelegate sharedAppDelegate] pushViewController:mentionVC];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:LocalizationKey(@"assert_cannotwithdraw") duration:1.5 position:CSToastPositionCenter];
        }
    }
}

/**
 将传进来的数据模型分组并排序  分成若干个分组  每个分组也进行排序 并删除分组中为空的分组
 
 @param objects 初始的对象数组
 @param selector 属性名称
 @param empty 清空与否
 @return 返回一个大数组 数组中是小数组  小数组中存储模型对象
 */
-(NSArray *)groupingSortingWithObjects:(NSArray *)objects withSelector:(SEL)selector isEmptyArray:(BOOL)empty{
    
    //UILocalizedIndexedCollation的分组排序建立在对对象的操作之上
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得到collation索引数量（26个字母和1个#）
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:collation.sectionTitles];
    NSUInteger sectionNumber = [indexArray count];//sectionNumber = 27
    
    //建立每个section数组
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionNumber];
    for (int index = 0; index < sectionNumber; index++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [sectionArray addObject:subArray];
    }
    
    for (WalletManageCoinInfoModel *model in objects) {
        //根绝SEL方法返回的字符串判断对象应该处于哪个分区
        //将每个人按name分到某个section下
        NSInteger index = [collation sectionForObject:model collationStringSelector:selector];//获取name属性的值所在的位置，比如“林”首字母是L,则就把林放在L组中
        NSMutableArray *tempArray = sectionArray[index];
        [tempArray addObject:model];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSMutableArray *arr in sectionArray) {
        NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:selector];
        [arr removeAllObjects];
        [arr addObjectsFromArray:sortArr];
    }
    
    //是不是删除空数组
    if (empty) {
        [sectionArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.count == 0) {
                [sectionArray removeObjectAtIndex:idx];
                [indexArray removeObjectAtIndex:idx];
            }
        }];
    }
    //第一个数组为tableView的数据源  第二个数组为索引数组 A B C......
    [self.showDataSourceArr removeAllObjects];
    [self.indexArr removeAllObjects];
    [self.showDataSourceArr addObjectsFromArray:sectionArray];
    [self.indexArr addObjectsFromArray:indexArray];
    return @[sectionArray,indexArray];
}

//MARK:---获取我的钱包所有数据
-(void)getData{
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"请求总资产的接口 --- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.dataSourceArr removeAllObjects];
                [self.indexArr removeAllObjects];
                [self.showDataSourceArr removeAllObjects];

                NSArray *data = resPonseObj[@"data"];
                for (NSDictionary *dic in data) {
                    NSDictionary *coin = dic[@"coin"];
                    WalletManageCoinInfoModel *model = [WalletManageCoinInfoModel mj_objectWithKeyValues:coin];
                    [self.dataSourceArr addObject:model];
                }
                                
                NSArray *arr = [self groupingSortingWithObjects:self.dataSourceArr withSelector:@selector(unit) isEmptyArray:YES];
                NSLog(@"arr -- %@",arr);
                
                [self.view addSubview:self.listTableView];

            }else{
            }
        }else{
        }
    }];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:NO];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldValueChanged:(UITextField *)textField {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (textField.text.length <= 0) {
        //不处理
        [self groupingSortingWithObjects:self.dataSourceArr withSelector:@selector(unit) isEmptyArray:YES];
    }else{
        //小写转大写
        NSString *transformString = [textField.text uppercaseString];
        for (WalletManageCoinInfoModel *model in self.dataSourceArr) {
            if ([model.unit containsString:transformString]) {
                [arr addObject:model];
            }
        }
        [self groupingSortingWithObjects:arr withSelector:@selector(unit) isEmptyArray:YES];
    }
    [self.listTableView reloadData];
}


- (void)popAction{
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 44)];
        _naviView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        
        QMUITextField *textField = [[QMUITextField alloc] initWithFrame:CGRectMake(15, 7, kWindowW - 80, 30)];
        
        textField.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        textField.tintColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
        textField.placeholder = LocalizationKey(@"search");
        textField.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
        textField.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        textField.font = [UIFont systemFontOfSize:13];
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:(UIControlEventEditingChanged)];
        textField.delegate = self;
        [_naviView addSubview:textField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWindowW - 65, 2, 50, 40);
        [btn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
        [btn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_naviView addSubview:btn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kWindowW, 1)];
        lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
        [_naviView addSubview:lineView];
    }
    return _naviView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)showDataSourceArr{
    if (!_showDataSourceArr) {
        _showDataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _showDataSourceArr;
}

- (NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _indexArr;
}

- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _listTableView.sectionIndexBackgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        [_listTableView registerNib:[UINib nibWithNibName:@"ZTSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZTSearchTableViewCell"];
    }
    return _listTableView;
}

@end
