//
//  AboutUSViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "AboutUSViewController.h"
#import "MineNetManager.h"
#import "AboutUSModel.h"
#import "SettingCenterTableViewCell.h"
#import "VersionUpdateModel.h"


@interface AboutUSViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL updateFlag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VersionUpdateModel *versionModel;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"aboutUS" value:nil table:@"English"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingCenterTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([SettingCenterTableViewCell class])];
    
    [self versionUpdate];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   SettingCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingCenterTableViewCell class])];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SettingCenterTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    cell.leftLabel.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    cell.rightLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    cell.lineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;

    if (indexPath.row == 1) {
        cell.leftLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"versionUpdate" value:nil table:@"English"];
        cell.rightLabel.hidden = NO;
        // app当前版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.rightLabel.text = app_Version;
        if (updateFlag) {
            cell.updateLabel.hidden = NO;
        }else{
            cell.updateLabel.hidden = YES;
        }
    }else{
        cell.rightLabel.hidden = YES;
        cell.updateLabel.hidden = YES;
        cell.leftLabel.text = @"隐私政策";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

//MARK:--版本更新接口请求
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
                    updateFlag = NO;
                }else{
                    updateFlag = YES;
                }
                [self.tableView reloadData];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000||[resPonseObj[@"code"] integerValue]==3000){
                [YLUserInfo logout];
                
            }else if ([resPonseObj[@"code"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

@end
