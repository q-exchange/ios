//
//  MineDrawerTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/9/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineDrawerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
- (void)LayoutUI;
@end

NS_ASSUME_NONNULL_END
