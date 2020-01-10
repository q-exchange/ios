//
//  GestureTableViewCell.h
//  digitalCurrency
//
//  Created by chu on 2018/8/9.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gestureSwitch;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end
