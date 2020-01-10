//
//  ZTMarketHeaderView.h
//  digitalCurrency
//
//  Created by chu on 2019/10/11.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^MarketSectionBtnClickBlock)(UIButton *sender);

@interface ZTMarketHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UIImageView *midImg;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightimg;
@property (weak, nonatomic) IBOutlet UIView *backView;
+(ZTMarketHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
- (void)layoutUI;
@property (nonatomic, copy) MarketSectionBtnClickBlock block;
@end

NS_ASSUME_NONNULL_END
