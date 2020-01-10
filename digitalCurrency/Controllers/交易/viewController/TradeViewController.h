//
//  TradeViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TradeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *asktableView;//卖出
@property (weak, nonatomic) IBOutlet UITableView *bidtableView;//买入
@property (weak, nonatomic) IBOutlet UITableView *entrusttableView;//委托
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

- (void)getPersonAllCollection;

@property (weak, nonatomic) IBOutlet UILabel *triggerLineView1;
@property (weak, nonatomic) IBOutlet UILabel *triggerLineView2;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *amountView;

@property (weak, nonatomic) IBOutlet UIButton *sub1;
@property (weak, nonatomic) IBOutlet UIButton *add1;
@property (weak, nonatomic) IBOutlet UIButton *add2;
@property (weak, nonatomic) IBOutlet UIButton *sub2;
@property (weak, nonatomic) IBOutlet UILabel *sliderMinValue;
@property (weak, nonatomic) IBOutlet UIView *spaceView;
@property (weak, nonatomic) IBOutlet UIView *weituoLineView;
@property (weak, nonatomic) IBOutlet UIView *mainBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidTableViewHeightConstraint;

@end
