//
//  ZTSearchCoinViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/10/15.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchType_charge,
    SearchType_withdraw
};

@protocol ZTSearchCoinViewControllerDelegate <NSObject>

- (void)selCoinFinish:(NSString *)unit;

@end

@interface ZTSearchCoinViewController : BaseViewController

- (instancetype)initWithType:(SearchType)type;
@property (nonatomic, weak) id <ZTSearchCoinViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
