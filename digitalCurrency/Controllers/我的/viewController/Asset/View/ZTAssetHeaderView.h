//
//  ZTAssetHeaderView.h
//  digitalCurrency
//
//  Created by chu on 2019/10/15.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTAssetHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UIButton *despoitBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
+(ZTAssetHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
- (void)layoutUI;
@property (nonatomic, strong) NSArray *dataArr;
@end

NS_ASSUME_NONNULL_END
