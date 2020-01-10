//
//  LeftMenuViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^selSymbolBlock)(NSString *baseSymbol, NSString *changeSymbol);

@interface LeftMenuViewController : BaseViewController
typedef enum : NSUInteger {
    ChildViewType_Collection = 0,
    ChildViewType_USDT,
    ChildViewType_BTC,
    ChildViewType_ETH
} ChildViewType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(assign,nonatomic)ChildViewType viewType;
- (void)showFromLeft;
@property (nonatomic, copy) selSymbolBlock block;
@property (nonatomic, assign) BOOL isLever;//是否杠杆缩略行情 默认NO
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
