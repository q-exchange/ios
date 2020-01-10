//
//  SLSegmentView.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSegmentView : UIView

@property (nonatomic, copy) void (^clickSegmentButton)(NSInteger index);

- (instancetype)initWithSegmentWithTitleArray:(NSArray *)segementTitleArray;

//滑动到当前选中的segment
- (void)movieToCurrentSelectedSegment:(NSInteger)index;
//修改按钮标题
-(void)modifyButtonTitle:(NSString*)title;

//segment默认颜色
@property (nonatomic, strong) UIColor *normalColor;
//segment选中颜色
@property (nonatomic, strong) UIColor *selectColor;
//指示线颜色
@property (nonatomic, strong) UIColor *indLineColor;
//底部分割线颜色
@property (nonatomic, strong) UIColor *bottomLineColor;
@end


