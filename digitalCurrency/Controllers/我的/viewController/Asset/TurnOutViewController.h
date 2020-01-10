//
//  TurnOutViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, AccountType) {
    AccountType_Coin,
    AccountType_Curreny,
    AccountType_Lever,
};

NS_ASSUME_NONNULL_BEGIN

@interface TurnOutViewController : BaseViewController

@property (nonatomic, copy) NSString *unit;
//只有从杠杆转让需要传交易对 不是杠杆不要传
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, assign) AccountType from;
@property (nonatomic, assign) AccountType to;

@end

NS_ASSUME_NONNULL_END
