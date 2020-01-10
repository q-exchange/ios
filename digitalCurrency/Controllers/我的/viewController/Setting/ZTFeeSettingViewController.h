//
//  ZTFeeSettingViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/10/16.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTFeeSettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *makerFee;
@property (weak, nonatomic) IBOutlet UILabel *takerFee;
@property (weak, nonatomic) IBOutlet UILabel *maker;
@property (weak, nonatomic) IBOutlet UILabel *taker;
@property (weak, nonatomic) IBOutlet UIView *upview;
@property (weak, nonatomic) IBOutlet UILabel *line1;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *leverLabel;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *lilvValue;
@property (weak, nonatomic) IBOutlet UILabel *lilvLabel;


@end

NS_ASSUME_NONNULL_END
