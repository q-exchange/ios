//
//  ZTFinRecordModel.h
//  digitalCurrency
//
//  Created by chu on 2019/10/17.
//  Copyright © 2019 ZTuo. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTFinRecordModel : BaseModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *airdropId;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *createTime;
@end

NS_ASSUME_NONNULL_END
