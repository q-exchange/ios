//
//  BaseViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)didInitialize{
    [super didInitialize];
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
}

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"warmPrompt" value:nil table:@"English"] message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ok" value:nil table:@"English"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        actionBlock();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alert animated: YES completion: nil];
    });
}
-(void)addAlterViewWithTitle:(NSString *)title withMessage:(NSString *)message withCertainBtnTitle:(NSString *)certainBtnTilte withCancelBtnTitle:(NSString *)cancelBtnTitle withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:certainBtnTilte style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                               actionBlock();
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             cancelBlock();
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
