//
//  NoticeTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/7/31.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *transactionview;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *transactionlabel;
@property (weak, nonatomic) IBOutlet UILabel *safelabel;
@property (weak, nonatomic) IBOutlet UILabel *helplebel;

@property (weak, nonatomic) IBOutlet UIView *Noticeview;
@property (weak, nonatomic) IBOutlet UILabel *noticelabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView2;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,copy)void (^ContractBlock)(void);

- (void)layoutUI;

@end
