//
//  WalletManageTableViewCell.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletManageModel.h"
#import "ZTFinRecordModel.h"

@class WalletManageTableViewCell;

@protocol WalletManageTableViewCellDelegate <NSObject>
- (void)buttonIndex:(NSIndexPath *)indexPath withModel:(WalletManageModel *)model;
@end
@interface WalletManageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *coinType;//货币种类
@property (weak, nonatomic) IBOutlet UILabel *availableNum;//可用数量
@property (weak, nonatomic) IBOutlet UILabel *freezeNum;//冻结数量
@property (weak, nonatomic) IBOutlet UILabel *lockingNum;//锁定数量

@property (nonatomic,weak) id<WalletManageTableViewCellDelegate> delegate;
@property(nonatomic,strong)NSIndexPath *index;
@property(nonatomic,strong)WalletManageModel *model;
@property(nonatomic,strong)ZTFinRecordModel *finModel;

@property (weak, nonatomic) IBOutlet UILabel *line;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockingLabel;

@end
