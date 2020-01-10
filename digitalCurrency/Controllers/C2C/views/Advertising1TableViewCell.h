//
//  Advertising1TableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Advertising1TableViewCell;

@protocol Advertising1TableViewCellDelegate <NSObject>
- (void)textFieldIndex:(NSIndexPath *)index TextFieldString: (NSString *)textString;
@end
@interface Advertising1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *centerTextFileld;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (nonatomic,weak) id<Advertising1TableViewCellDelegate> delegate;
@property(nonatomic,strong)NSIndexPath *index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightwidth;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end
