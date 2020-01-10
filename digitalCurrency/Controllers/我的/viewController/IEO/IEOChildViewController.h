//
//  IEOChildViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/5/6.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "UIViewController+ZJScrollPageController.h"
typedef NS_ENUM(NSUInteger, IEOStatus) {
    IEOStatus_All,
    IEOStatus_Preheating,//预热中
    IEOStatus_Ongoing,//进行中
    IEOStatus_Completed//已结束
};

NS_ASSUME_NONNULL_BEGIN

@interface IEOChildViewController : BaseViewController<ZJScrollPageViewChildVcDelegate>

- (instancetype)initWithStatus:(NSInteger)status;

@end

NS_ASSUME_NONNULL_END
