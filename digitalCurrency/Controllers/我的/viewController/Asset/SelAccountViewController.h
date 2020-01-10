//
//  SelAccountViewController.h
//  digitalCurrency
//
//  Created by chu on 2019/5/8.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetModel.h"

@protocol SelAccountDelegate <NSObject>

- (void)selAccountFinishWithSymbol:(NSString *_Nullable)symbol baseSymbol:(NSString *_Nullable)baseSymbol changeSymbol:(NSString *_Nullable)changeSymbol;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SelAccountViewController : BaseViewController

@property (nonatomic, weak) id <SelAccountDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
