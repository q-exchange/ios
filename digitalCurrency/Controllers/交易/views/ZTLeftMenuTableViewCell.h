//
//  ZTLeftMenuTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/10/19.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTLeftMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
-(void)configDataWithModel:(symbolModel*)model withtype:(int)type withIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
