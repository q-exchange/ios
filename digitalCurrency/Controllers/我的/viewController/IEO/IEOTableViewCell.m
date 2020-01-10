//
//  IEOTableViewCell.m
//  digitalCurrency
//
//  Created by chu on 2019/5/6.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEOTableViewCell.h"

@implementation IEOTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 3;
    self.raiseCountNameLabel.text = LocalizationKey(@"IEORaise_count");
    self.raiseCycleNameLabel.text = LocalizationKey(@"IEORaise_Cycle");
    self.raiseCoinNameLabel.text = LocalizationKey(@"IEORaise_Coin");
    self.raiseStatusLabel.layer.cornerRadius = self.raiseStatusLabel.frame.size.height / 2;
    self.raiseStatusLabel.layer.masksToBounds = YES;
    
    self.raiseImageView.layer.cornerRadius = self.raiseImageView.frame.size.height / 2;
    self.raiseImageView.layer.masksToBounds = YES;
}

- (void)setModel:(IEOModel *)model{
    _model = model;
    [self.raiseImageView sd_setImageWithURL:[NSURL URLWithString:model.picView]];
    self.raiseNameLabel.text = model.saleCoin;
    self.raiseDescLabel.text = model.ieoName;
    NSString *currentTime = [ToolUtil getCurrentTime];
    NSString *startTime = model.startTime;
    NSString *endTime = model.endTime;
    if ([self compareDate:startTime withDate:currentTime] == -1) {
        //预热中
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Preheating");
        self.raiseStatusLabel.backgroundColor = RGBOF(0xF15057);
    }else if ([self compareDate:startTime withDate:currentTime] == 1 && [self compareDate:endTime withDate:currentTime] == -1){
        //进行中
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Ongoing");
        self.raiseStatusLabel.backgroundColor = RGBOF(0x00B273);
    }else{
        //已完成
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Completed");
        self.raiseStatusLabel.backgroundColor = RGBOF(0x999999);
    }
    
    [self.raiseContentImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];

    self.raiseCountValueLabel.text = [NSString stringWithFormat:@"%@ %@",model.saleAmount, model.saleCoin];
    self.raiseCycleValueLabel.text = [NSString stringWithFormat:@"%@ - \n %@",model.startTime, model.endTime];
    self.raiseCoinValueLabel.text = model.raiseCoin;
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
