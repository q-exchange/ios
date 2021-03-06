//
//  Adversiting2TableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Adversiting2TableViewCell;
@protocol Adversiting2TableViewCellDelegate <NSObject>
- (void)textViewIndex:(NSIndexPath *)index TextViewString: (NSString *)textString;
@end
@interface Adversiting2TableViewCell : UITableViewCell<QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (nonatomic,weak) id<Adversiting2TableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;//左边标题
@property(nonatomic,strong)NSIndexPath *index;

@property (weak, nonatomic) IBOutlet UILabel *line;
@end
