//
//  MyPromoteShareView.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromoteShareView.h"

@implementation MyPromoteShareView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.saveImageButton setTitle:LocalizationKey(@"promoteSaveImage") forState:UIControlStateNormal];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [_bgView.layer convertPoint:point fromLayer:self.layer];
    if (![_bgView.layer containsPoint:point]) {
        [self removeFromSuperview];
    }
}


@end
