//
//  IEORecordDetailViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEORecordDetailViewController.h"

@interface IEORecordDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *raiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *saleCoinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *useAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *useAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *butTimeValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;

@end

@implementation IEORecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Detail");
    // Do any additional setup after loading the view from its nib.
    self.backViewHeightConstraint.constant = CGRectGetMaxY(self.buyTimeLabel.frame) + 20;
    self.raiseImageView.layer.cornerRadius = self.raiseImageView.frame.size.height / 2;
    self.raiseImageView.layer.masksToBounds = YES;
    
    self.saleAmountLabel.text = LocalizationKey(@"IEORaise_count");
    self.raiseCoinLabel.text = LocalizationKey(@"IEORaise_Coin");
    self.raiseTimeLabel.text = LocalizationKey(@"IEORaise_Cycle");
    self.buyAmountLabel.text = LocalizationKey(@"IEORaise_BuyAmount");
    self.useAmountLabel.text = LocalizationKey(@"IEORaise_UseAmount");
    self.buyTimeLabel.text = LocalizationKey(@"IEORaise_Uptime");
    [self initData];
}

- (void)initData{
    
    [self.raiseImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picView]];
    self.saleCoinNameLabel.text = self.model.saleCoin;
    self.saleNamelabel.text = self.model.ieoName;
    if ([self.model.status isEqualToString:@"1"]) {
        self.statusLabel.text = LocalizationKey(@"IEOSubscriptionSucess");
    }else{
        self.statusLabel.text = LocalizationKey(@"IEOSubscriptionFail");
    }
    
    
    self.saleAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.saleAmount, self.model.saleCoin];
    self.raiseTimeValueLabel.text = [NSString stringWithFormat:@"%@ - \n %@",self.model.startTime, self.model.endTime];
    self.raiseCoinValueLabel.text = self.model.raiseCoin;
    self.buyAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.receiveAmount, self.model.saleCoin];
    self.useAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.payAmount, self.model.raiseCoin];
    self.butTimeValueLabel.text = self.model.createTime;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
