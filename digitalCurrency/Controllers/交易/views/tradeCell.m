//
//  tradeCell.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "tradeCell.h"

@implementation tradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.amountLabel.font = [UIFont systemFontOfSize:9];
    self.priceLabel.font = [UIFont systemFontOfSize:9];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
