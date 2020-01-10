//
//  IEOChildViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/6.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEOChildViewController.h"
#import "IEOTableViewCell.h"
#import "IEOModel.h"
#import "IEODetailsViewController.h"

@interface IEOChildViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    IEOStatus _status;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation IEOChildViewController

- (instancetype)initWithStatus:(NSInteger)status{
    if (self = [super init]) {
        _status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackColor;
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

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IEOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IEOTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IEOTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
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
    IEODetailsViewController *detail = [[IEODetailsViewController alloc] init];
    detail.model = self.dataSourceArr[indexPath.row];
    [[AppDelegate sharedAppDelegate] pushViewController:detail];
}

- (void)getData{
    [EasyShowLodingView showLoding];
    __weak typeof(self)weakself = self;
    NSString *status = @"";
    if (_status == IEOStatus_Preheating) {
        status = @"1";
    }else if (_status == IEOStatus_Ongoing){
        status = @"2";
    }else if (_status == IEOStatus_Completed){
        status = @"3";
    }else{
        status = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/ieo/all"];
    NSDictionary *param = @{@"pageNum":@1, @"pageSize":@10, @"status":status};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param  ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取所有ieo ---- %@",responseResult);
        [EasyShowLodingView hidenLoding];
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    [self.dataSourceArr removeAllObjects];
                    for (NSDictionary *dic in data) {
                        IEOModel *model = [IEOModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"detailTableViewTip" value:nil table:@"English"]];
                    self.tableView.ly_emptyView = emptyView;
                    [self.tableView reloadData];
                }
                
            }else{
                [weakself.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - Height_NavBar - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"IEOTableViewCell" bundle:nil] forCellReuseIdentifier:@"IEOTableViewCell"];
        
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
