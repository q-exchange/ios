//
//  configViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 DTD. All rights reserved.
//

#import "BaseViewController.h"

@interface configViewController : BaseViewController
typedef enum : NSUInteger {
    ChildViewType_Collection=0,
    ChildViewType_USDT,
    ChildViewType_BTC,
    ChildViewType_ETH,
} ChildViewType;
- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
-(void)reloadData;//刷新数据
@end
