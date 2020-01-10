//
//  YLTabBarController.h
//  BaseProject
//
//  Created by YLCai on 16/11/23.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@interface YLTabBarController : QMUITabBarViewController

+(YLTabBarController *)defaultTabBarContrller;
//重置tabar标题
-(void)resettabarItemsTitle;

@end
