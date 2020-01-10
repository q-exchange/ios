//
//  ZTNoticeTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2019/10/10.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pageScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) pageScrollView *pageScrollView;
@property (nonatomic, strong) NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
