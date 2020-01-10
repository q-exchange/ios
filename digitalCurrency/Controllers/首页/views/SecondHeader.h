//
//  SecondHeader.h
//  digitalCurrency
//
//  Created by sunliang on 2018/4/14.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HomeSectionBtnClickBlock)(UIButton *sender);

@interface SecondHeader : UIView
+(SecondHeader *)instancesectionHeaderViewWithFrame:(CGRect)Rect;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)layoutUI;
@property (nonatomic, copy) HomeSectionBtnClickBlock block;

@end
