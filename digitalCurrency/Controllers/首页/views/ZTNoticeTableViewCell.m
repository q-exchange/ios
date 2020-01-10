//
//  ZTNoticeTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/10/10.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ZTNoticeTableViewCell.h"
#import "PlatformMessageModel.h"
#import "PlatformMessageDetailViewController.h"

@implementation ZTNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.pageScrollView.BGColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.pageScrollView.titleColor = [QDThemeManager currentTheme].themeTitleTextColor;
    self.lineView.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;
    
    [self.contentView addSubview:self.pageScrollView];
    __weak typeof(self)weakself = self;
    [self.pageScrollView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        PlatformMessageModel *model = weakself.dataSource[index-100];
        PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
        detailVC.content = model.content;
        detailVC.navtitle = model.title;
        detailVC.title = model.title;
        [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    }];
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.leftImageView.image = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"网络白");
        }
        return UIIMAGE(@"网络");
    }];
    self.pageScrollView.BGColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.pageScrollView.titleColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.lineView.backgroundColor = [QDThemeManager currentTheme].themeSeparatorColor;
    NSMutableArray*titleArray=[[NSMutableArray alloc]init];
    [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PlatformMessageModel *model = dataSource[idx];
        [titleArray addObject:model.title];
    }];
    self.pageScrollView.titleArray = titleArray;
}

- (pageScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[pageScrollView alloc] initWithFrame:CGRectMake(40, 0, kWindowW-55, 39)];
        _pageScrollView.BGColor = [QDThemeManager currentTheme].themeBackgroundColor;
    }
    return _pageScrollView;
}

@end
