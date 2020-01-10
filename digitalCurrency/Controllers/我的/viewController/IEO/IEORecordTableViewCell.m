//
//  IEORecordTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEORecordTableViewCell.h"

@implementation IEORecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.raiseImageView.layer.cornerRadius = self.raiseImageView.frame.size.height / 2;
    self.raiseImageView.layer.masksToBounds = YES;
}

- (void)setModel:(IEOModel *)model{
    _model = model;
    [self.raiseImageView sd_setImageWithURL:[NSURL URLWithString:model.picView]];
    self.saleCoinLabel.text = model.saleCoin;
    self.saleNameLabel.text = model.ieoName;
    if ([model.status isEqualToString:@"1"]) {
        self.statusLabel.text = LocalizationKey(@"IEOSubscriptionSucess");
    }else{
        self.statusLabel.text = LocalizationKey(@"IEOSubscriptionFail");
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
