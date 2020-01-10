//
//  ZTAssetsTotalBalanceTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/10/15.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTAssetsTotalBalanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UIView *sepView;

@end

NS_ASSUME_NONNULL_END
