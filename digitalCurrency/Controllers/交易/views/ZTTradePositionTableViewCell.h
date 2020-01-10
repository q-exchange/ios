//
//  ZTTradePositionTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/10/14.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZTTradePositionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *tradetypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tradeValueLabel;
@property (weak, nonatomic) IBOutlet UIView *tradeTypeView;

//触发价视图
@property (weak, nonatomic) IBOutlet UIButton *trigger_price_addbtn;
@property (weak, nonatomic) IBOutlet UIButton *trigger_price_subbtn;
@property (weak, nonatomic) IBOutlet UIView *trigger_view_lineview1;
@property (weak, nonatomic) IBOutlet UIView *trigger_view_lineview2;
@property (weak, nonatomic) IBOutlet UIView *trigger_view;
@property (weak, nonatomic) IBOutlet UILabel *triggerprice_conversion_cnyLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *triggerTF;



//价格视图
@property (weak, nonatomic) IBOutlet UIButton *price_addBtn;
@property (weak, nonatomic) IBOutlet UIButton *price_subBtn;
@property (weak, nonatomic) IBOutlet UIView *priceView_lineView1;
@property (weak, nonatomic) IBOutlet UIView *priceView_lineView2;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *price_conversion_cnyLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *priceTF;


//数量视图
@property (weak, nonatomic) IBOutlet UILabel *coinTypeLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *amountTF;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UILabel *canuseLabel;

//滑块
@property (weak, nonatomic) IBOutlet StepSlider *myslider;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;


//右侧tableview
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITableView *askTableView;
@property (weak, nonatomic) IBOutlet UITableView *bidTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice_conversionCnyLabel;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

NS_ASSUME_NONNULL_END
