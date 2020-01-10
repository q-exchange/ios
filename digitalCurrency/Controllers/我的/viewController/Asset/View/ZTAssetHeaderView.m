//
//  ZTAssetHeaderView.m
//  digitalCurrency
//
//  Created by chu on 2019/10/15.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "ZTAssetHeaderView.h"
#import "ZTSearchCoinViewController.h"
#import "TurnOutViewController.h"

@implementation ZTAssetHeaderView

+(ZTAssetHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZTAssetHeaderView" owner:nil options:nil];
    ZTAssetHeaderView *headerView = [nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (dataArr.count == 2) {
        NSString *value1 = [NSString stringWithFormat:@"%@",dataArr[0]];
        NSString *value2 = [NSString stringWithFormat:@"%@",dataArr[1]];

        self.totalLabel.text = [ToolUtil judgeStringForDecimalPlaces:value1];
        self.cnyLabel.text = [NSString stringWithFormat:@"≈ %@ CNY", [ToolUtil interceptTheTwoBitsAfterDecimalPoint:value2]];
    }
}

- (void)layoutUI{
    self.titleLabel.text = [NSString stringWithFormat:@"%@(USDT)", LocalizationKey(@"assert_totalbalances")];
    
    self.despoitBtn.layer.cornerRadius = 2;
    self.despoitBtn.layer.borderWidth = 1;
    self.despoitBtn.layer.borderColor = UIColorMake(60, 128, 228).CGColor;
    [self.despoitBtn setTitle:LocalizationKey(@"chargeMoney") forState:UIControlStateNormal];
    
    self.withdrawBtn.layer.cornerRadius = 2;
    self.withdrawBtn.layer.borderWidth = 1;
    self.withdrawBtn.layer.borderColor = UIColorMake(60, 128, 228).CGColor;
    [self.withdrawBtn setTitle:LocalizationKey(@"mentionMoney") forState:UIControlStateNormal];

    self.transferBtn.layer.cornerRadius = 2;
    self.transferBtn.layer.borderWidth = 1;
    self.transferBtn.layer.borderColor = UIColorMake(60, 128, 228).CGColor;
    [self.transferBtn setTitle:LocalizationKey(@"Transfer") forState:UIControlStateNormal];

}

- (IBAction)despiotAction:(UIButton *)sender {
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_charge];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (IBAction)withdrawAction:(UIButton *)sender {
    ZTSearchCoinViewController *search = [[ZTSearchCoinViewController alloc] initWithType:SearchType_withdraw];
    [[AppDelegate sharedAppDelegate] pushViewController:search];
}

- (IBAction)transferAction:(UIButton *)sender {
    TurnOutViewController *turn = [[TurnOutViewController alloc] init];
    turn.unit = @"USDT";
    turn.from = AccountType_Coin;
    turn.to = AccountType_Curreny;
    [[AppDelegate sharedAppDelegate] pushViewController:turn];
}

- (IBAction)eyeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AsertEyeStatusChange" object:nil userInfo:@{@"change":@(sender.selected)}];
    
    if (sender.selected) {
        self.totalLabel.text = @"******";
        self.cnyLabel.text = @"******";
    }else{
        if (self.dataArr.count == 2) {
            NSString *value1 = [NSString stringWithFormat:@"%@",self.dataArr[0]];
            NSString *value2 = [NSString stringWithFormat:@"%@",self.dataArr[1]];

            self.totalLabel.text = [ToolUtil judgeStringForDecimalPlaces:value1];
            self.cnyLabel.text = [NSString stringWithFormat:@"≈ %@ CNY", [ToolUtil interceptTheTwoBitsAfterDecimalPoint:value2]];
        }
    }
}

@end
