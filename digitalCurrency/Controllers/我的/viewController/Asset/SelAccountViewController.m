//
//  SelAccountViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "SelAccountViewController.h"
#import "SelAccountTableViewCell.h"

@interface SelAccountViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_openOrCloseStr;
    BOOL _isOpen;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation SelAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOpen = NO;
    // Do any additional setup after loading the view.
    _openOrCloseStr = LocalizationKey(@"Open");
    
    self.title = LocalizationKey(@"AccountSelecte");
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _isOpen == YES ? self.dataSourceArr.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelAccountTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelAccountTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.leftLabel.text = LocalizationKey(@"AccountCurrency");
    }else{
        AssetModel *model = self.dataSourceArr[indexPath.row];
        cell.leftLabel.text = model.symbol;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 45)];
        [view1 addSubview:view];
        view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 22, 18, 12, 8)];
        if (!_isOpen) {
            img.image = [UIImage imageNamed:@"zk"];
        }else{
            img.image = [UIImage imageNamed:@"sq"];
        }
        [view addSubview:img];
        
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        type.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        type.font = [UIFont systemFontOfSize:14];
        type.text = LocalizationKey(@"AccountLever");
        type.textAlignment = NSTextAlignmentLeft;
        [view addSubview:type];
        
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(img.frame) - 5 - 50, 0, 50, 45)];
        count.textColor = QDThemeManager.currentTheme.themeMainTextColor;
        count.font = [UIFont systemFontOfSize:12];
        count.text = _openOrCloseStr;
        count.textAlignment = NSTextAlignmentRight;
        [view addSubview:count];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 45)];
        [btn addTarget:self action:@selector(openOrclose:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    return view1;
}

- (void)openOrclose:(UIButton *)sender{
    _isOpen = !_isOpen;
    _openOrCloseStr = _isOpen == YES ? LocalizationKey(@"Close") : LocalizationKey(@"Open");
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        view.backgroundColor = QDThemeManager.currentTheme.themeBackgroundDescriptionColor;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(selAccountFinishWithSymbol:baseSymbol:changeSymbol:)]) {
            [self.delegate selAccountFinishWithSymbol:@"" baseSymbol:@"" changeSymbol:@""];
        }
    }else{
        AssetModel *model = self.dataSourceArr[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(selAccountFinishWithSymbol:baseSymbol:changeSymbol:)]) {
            [self.delegate selAccountFinishWithSymbol:model.symbol baseSymbol:model.baseSymbol changeSymbol:model.coinSymbol];
        }
    }
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (void)getData{
    self.page = 1;
    __weak typeof(self)weakself = self;
    [EasyShowLodingView showLoding];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/transfer/support_coin"];
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:nil contentType:@"application/x-www-form-urlencoded" ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"获取支持划转币种 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSArray *supportLeverCoins = responseResult[@"data"][@"supportLeverCoins"];
                    [self.dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in supportLeverCoins) {
                        AssetModel *model = [AssetModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                }
                [self.tableView reloadData];
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SelAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelAccountTableViewCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

@end
