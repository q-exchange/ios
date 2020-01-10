//
//  listCell.h
//  digitalCurrency
//
//  Created by sunliang on 2018/4/14.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"
@interface listCell : UITableViewCell

-(void)configModel:(NSArray*)modelArray withIndex:(int)index;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
