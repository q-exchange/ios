//
//  WalletManageTableHeadView.h
//  digitalCurrency
//
//  Created by iDog on 2018/4/12.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletManageTableHeadView : UIView

@property (weak, nonatomic) IBOutlet QMUITextField *textField;


@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *line;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *selectBtnLabel;
-(WalletManageTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect;
- (void)layoutUI;
@end
