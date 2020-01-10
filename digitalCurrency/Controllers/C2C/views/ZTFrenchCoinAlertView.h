//
//  ZTFrenchCoinAlertView.h
//  digitalCurrency
//
//  Created by chu on 2019/10/16.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTFrenchCoinAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tradeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *danjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *danjiaValueLabel;
@property (weak, nonatomic) IBOutlet UIView *upView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet QMUIFillButton *moneyBtn;
@property (weak, nonatomic) IBOutlet QMUIFillButton *amountBtn;


@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet QMUITextField *inputTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *xianeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

NS_ASSUME_NONNULL_END
