//
//  IEORecordTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEOModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IEORecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *raiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *saleCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IEOModel *model;
@end

NS_ASSUME_NONNULL_END
