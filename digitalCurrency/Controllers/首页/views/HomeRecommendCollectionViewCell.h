//
//  HomeRecommendCollectionViewCell.h
//  digitalCurrency
//
//  Created by chu on 2018/7/20.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"

@interface HomeRecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chgLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) symbolModel *model;
@end
