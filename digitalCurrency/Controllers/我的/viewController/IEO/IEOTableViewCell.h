//
//  IEOTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/5/6.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEOModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IEOTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *raiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *raiseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *raiseContentImageView;
@property (weak, nonatomic) IBOutlet UILabel *raiseCountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCycleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCycleValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinValueLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) IEOModel *model;

@end

NS_ASSUME_NONNULL_END
