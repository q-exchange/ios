//
//  IEORecordViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEORecordViewController.h"
#import "IEORecordTableViewCell.h"
#import "IEOModel.h"
#import "IEORecordDetailViewController.h"
#import "DownTheTabs.h"

@interface IEORecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    DownTheTabs *_tabs;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *projectName;

@end

@implementation IEORecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startTime = @"";
    self.endTime = @"";
    self.status = @"";
    self.projectName = @"";
    
    self.title = LocalizationKey(@"IEORecord");
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
    [self RightsetupNavgationItemWithpictureName:@"zicanliushui"];

}

-(void)RighttouchEvent{
//    self.startime = nil;
//    self.endtime = nil;
//    self.type = nil;
    if (_tabs) {
        [_tabs removeFromSuperview];
        _tabs = nil;
        return;
    }
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSArray *tabsarray = @[LocalizationKey(@"IEOSubscriptionSucess"),LocalizationKey(@"IEOSubscriptionFail")];
    DownTheTabs *tabs = [[DownTheTabs alloc] initCoinguessingView:self.view Projects:tabsarray];
    _tabs = tabs;
    __weak typeof(self)weakself = self;
    tabs.dismissBlock = ^{
//        weakself.navigationItem.rightBarButtonItem.enabled = YES;
    };
    tabs.SubscriptionBlock = ^(NSString *startTime, NSString *endTime, NSString *status, NSString *projectName) {
//        weakself.navigationItem.rightBarButtonItem.enabled = YES;

        if (startTime.length > 0) {
            weakself.startTime = [ToolUtil timeIntervalToTimeString:startTime WithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        if (endTime.length > 0) {
            weakself.endTime = [ToolUtil timeIntervalToTimeString:endTime WithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        if ([status isEqualToString:LocalizationKey(@"IEOSubscriptionSucess")]) {
            weakself.status = @"1";
        }else{
            weakself.status = @"0";
        }
        
        weakself.projectName = projectName;
        
        [weakself getData];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IEORecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IEORecordTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IEORecordTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
    IEORecordDetailViewController *detail = [[IEORecordDetailViewController alloc] init];
    detail.model = self.dataSourceArr[indexPath.section];
    [[AppDelegate sharedAppDelegate] pushViewController:detail];
}

- (void)getData{
    [EasyShowLodingView showLoding];
    __weak typeof(self)weakself = self;
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/ieo/record"];
    NSDictionary *param = @{@"pageNum":@1, @"pageSize":@10, @"ieoName":self.projectName, @"status":self.status, @"startTime":self.startTime, @"endTime":self.endTime};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param  ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取所有ieo记录 ---- %@",responseResult);
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
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

- (void)getMoreData{
    __weak typeof(self)weakself = self;
    self.page++;
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/ieo/record"];
    NSDictionary *param = @{@"pageNum":[NSNumber numberWithInteger:self.page], @"pageSize":@10, @"ieoName":self.projectName, @"status":self.status, @"startTime":self.startTime, @"endTime":self.endTime};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param  ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"获取所有ieo记录 ---- %@",responseResult);
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [weakself.view makeToast:error.localizedDescription];
            weakself.page --;
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                if (responseResult[@"data"] && [responseResult[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *data = responseResult[@"data"];
                    for (NSDictionary *dic in data) {
                        IEOModel *model = [IEOModel mj_objectWithKeyValues:dic];
                        [self.dataSourceArr addObject:model];
                    }
                    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"detailTableViewTip" value:nil table:@"English"]];
                    self.tableView.ly_emptyView = emptyView;
                    [self.tableView reloadData];
                }
                
            }else{
                weakself.page --;
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
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"IEORecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"IEORecordTableViewCell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getMoreData];
        }];
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
