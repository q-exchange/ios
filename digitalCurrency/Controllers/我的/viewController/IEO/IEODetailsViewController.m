//
//  IEODetailsViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "IEODetailsViewController.h"
#import "MineNetManager.h"
#import "WalletManageModel.h"

@interface IEODetailsViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
{
    UIView *_lineView;
}
@property (weak, nonatomic) IBOutlet UIView *mainBackView;

@property (weak, nonatomic) IBOutlet UIImageView *raiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *sailCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *raiseContentImageView;

@property (weak, nonatomic) IBOutlet UILabel *raiseAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseAmountValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *raiseCycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCycleValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *raiseCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *uptimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uptimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *biliLabel;

@property (weak, nonatomic) IBOutlet UITextField *raiseCoinTF;
@property (weak, nonatomic) IBOutlet UITextField *saleCoinTF;
@property (weak, nonatomic) IBOutlet UILabel *raiseCoinLabel1;
@property (weak, nonatomic) IBOutlet UILabel *saleCoinLabel1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UILabel *haveRaiseCoinLabel;//已有数量

@property (weak, nonatomic) IBOutlet UIView *raiseCoinView;
@property (weak, nonatomic) IBOutlet UIView *saleCoinView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *guizeBtn;

@property (nonatomic, strong) NSMutableArray *btnsArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation IEODetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Detail");
    // Do any additional setup after loading the view from its nib.
    self.raiseAmountLabel.text = LocalizationKey(@"IEORaise_count");
    self.raiseCycleLabel.text = LocalizationKey(@"IEORaise_Cycle");
    self.raiseCoinLabel.text = LocalizationKey(@"IEORaise_Coin");
    self.uptimeLabel.text = LocalizationKey(@"IEORaise_Time");
    self.raiseStatusLabel.layer.cornerRadius = 11;
    self.raiseStatusLabel.layer.masksToBounds = YES;

    self.backView.layer.cornerRadius = 3;
    self.raiseCoinView.layer.borderColor = BackColor.CGColor;
    self.raiseCoinView.layer.borderWidth = 1;
    self.saleCoinView.layer.borderColor = BackColor.CGColor;
    self.saleCoinView.layer.borderWidth = 1;
    self.passwordView.layer.borderColor = BackColor.CGColor;
    self.passwordView.layer.borderWidth = 1;
    
    self.doneBtn.layer.cornerRadius = self.doneBtn.frame.size.height / 2;
    self.doneBtn.layer.masksToBounds = YES;
    
    _passwordTF.placeholder = LocalizationKey(@"inputMoneyPassword");
    _raiseCoinTF.placeholder = LocalizationKey(@"inputRaiseAmount");
    _saleCoinTF.placeholder = LocalizationKey(@"inputSaleAmount");
    
    _raiseCoinTF.delegate = self;
    _saleCoinTF.delegate = self;

    [self initData];
    [self initBottomViews];
    [self getData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.raiseCoinTF) {
        NSDecimalNumber *ratio = [[NSDecimalNumber alloc] initWithString:self.model.ratio];
        NSDecimalNumber *raise = [[NSDecimalNumber alloc] initWithString:textField.text];
        if (raise.doubleValue > 0) {
            self.saleCoinTF.text = [[raise decimalNumberByMultiplyingBy:ratio] stringValue];
        }
    }
    if (textField == self.saleCoinTF) {
        NSDecimalNumber *ratio = [[NSDecimalNumber alloc] initWithString:self.model.ratio];
        NSDecimalNumber *sale = [[NSDecimalNumber alloc] initWithString:textField.text];
        if (sale.doubleValue > 0&&ratio.doubleValue >0) {
            self.raiseCoinTF.text = [[sale decimalNumberByDividingBy:ratio] stringValue];
        }
    }
}

- (void)initBottomViews{
    NSArray *titles = @[LocalizationKey(@"saleMode"), LocalizationKey(@"projectDetail")];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(15 + i * 70 + i * 20, CGRectGetMaxY(self.backView.frame) + 25, 70, 20);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBOF(0x3399FF) forState:UIControlStateSelected];
        [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 15, 70, 1)];
            _lineView.backgroundColor = RGBOF(0x3399FF);
            [self.mainBackView addSubview:_lineView];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainBackView addSubview:btn];
        [self.btnsArr addObject:btn];

    }
    
    [self.mainBackView addSubview:self.scrollView];
    
    NSMutableAttributedString *mode = [self setAttributedString:self.model.sellMode];
    CGFloat modeHeight = [self getHTMLHeightByStr:self.model.sellMode];
    NSMutableAttributedString *pro = [self setAttributedString:self.model.sellDetail];
    CGFloat proHeight = [self getHTMLHeightByStr:self.model.sellDetail];

    NSArray *contents = @[mode, pro];
    NSArray *heights = @[@(modeHeight), @(proHeight)];
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + i * (kWindowW - 30) + i* 30, 0, kWindowW - 30, [heights[i] floatValue])];
        label.numberOfLines = 0;
        label.attributedText = contents[i];
        [self.scrollView addSubview:label];
    }
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame) + 20, kWindowW, modeHeight);
    self.backViewHeightConstraint.constant = CGRectGetMaxY(self.scrollView.frame) + 20;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kWindowW;
    if (index == 0) {
        CGFloat modeHeight = [self getHTMLHeightByStr:self.model.sellMode];
        self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame) + 20, kWindowW, modeHeight);
        self.backViewHeightConstraint.constant = CGRectGetMaxY(self.scrollView.frame) + 20;
    }else{
        CGFloat proHeight = [self getHTMLHeightByStr:self.model.sellDetail];
        self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame) + 20, kWindowW, proHeight);
        self.backViewHeightConstraint.constant = CGRectGetMaxY(self.scrollView.frame) + 20;
    }
    UIButton *sender = self.btnsArr[index];
    _lineView.centerX = sender.centerX;
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

-(NSMutableAttributedString *)setAttributedString:(NSString *)str
{
    //如果有换行，把\n替换成<br/>
    //如果有需要把换行加上
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    //设置HTML图片的宽度
    str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",[UIScreen mainScreen].bounds.size.width - 30,str];
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    //设置富文本字的大小
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, htmlString.length)];
    [htmlString addAttribute:NSForegroundColorAttributeName value:RGBOF(0x999999) range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    
    return htmlString;
}

//计算html字符串高度
-(CGFloat )getHTMLHeightByStr:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",[UIScreen mainScreen].bounds.size.width,str];
    
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [htmlString length])];
    
    CGSize contextSize = [htmlString boundingRectWithSize:(CGSize){[UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return contextSize.height ;
    
}

- (void)btnClick:(UIButton *)sender{
    _lineView.centerX = sender.centerX;
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    self.scrollView.contentOffset = CGPointMake(sender.tag * kWindowW, 0);

}

- (void)initData{
    [self.raiseImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picView]];
    self.sailCoinLabel.text = self.model.saleCoin;
    self.raiseNameLabel.text = self.model.ieoName;
    NSString *currentTime = [ToolUtil getCurrentTime];
    NSString *startTime = self.model.startTime;
    NSString *endTime = self.model.endTime;
    self.doneBtn.enabled = YES;
    if ([self compareDate:startTime withDate:currentTime] == -1) {
        //预热中
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Preheating");
        self.raiseStatusLabel.backgroundColor = RGBOF(0x00B273);
        self.doneBtn.enabled = NO;
        [self.doneBtn setBackgroundColor:RGBOF(0x999999)];
        [self.doneBtn setTitle:LocalizationKey(@"IEOStatus_Preheating") forState:UIControlStateNormal];
    }else if ([self compareDate:startTime withDate:currentTime] == 1 && [self compareDate:endTime withDate:currentTime] == -1){
        //进行中
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Ongoing");
        self.raiseStatusLabel.backgroundColor = RGBOF(0x00B273);
        [self.doneBtn setBackgroundColor:NavColor];
        [self.doneBtn setTitle:LocalizationKey(@"ConfirmSubscription") forState:UIControlStateNormal];
    }else{
        //已完成
        self.raiseStatusLabel.text = LocalizationKey(@"IEOStatus_Completed");
        self.raiseStatusLabel.backgroundColor = RGBOF(0x999999);
        self.doneBtn.enabled = NO;
        [self.doneBtn setBackgroundColor:RGBOF(0x999999)];
        [self.doneBtn setTitle:LocalizationKey(@"IEOStatus_Completed") forState:UIControlStateNormal];
    }
    
    [self.raiseContentImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic]];
    
    self.raiseAmountValueLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.saleAmount, self.model.saleCoin];
    self.raiseCycleValueLabel.text = [NSString stringWithFormat:@"%@ - \n %@",self.model.startTime, self.model.endTime];
    self.raiseCoinValueLabel.text = self.model.raiseCoin;
    self.uptimeValueLabel.text = self.model.expectTime;
    self.biliLabel.text = [NSString stringWithFormat:@"1 %@ = %@ %@", self.model.raiseCoin, self.model.ratio, self.model.saleCoin];
    
    self.haveRaiseCoinLabel.text = [NSString stringWithFormat:@"--%@",self.model.raiseCoin];
    self.raiseCoinLabel1.text = self.model.raiseCoin;
    self.saleCoinLabel1.text = self.model.saleCoin;
    
    [self.guizeBtn setTitle:LocalizationKey(@"IEOTip") forState:UIControlStateNormal];
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

- (IBAction)doneAction:(UIButton *)sender {
    if ([NSString stringIsNull:self.raiseCoinTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputRaiseAmount") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.saleCoinTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputSaleAmount") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([NSString stringIsNull:self.passwordTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMoneyPassword") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/ieo/order"];
    NSDictionary *param = @{@"id":self.model.ID, @"amount":self.raiseCoinTF.text, @"jyPassword":self.passwordTF.text};
    NSLog(@"param -- %@",param);
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"募集 ---- %@",responseResult);
        if ([responseResult objectForKey:@"resError"]) {
            NSError *error = responseResult[@"resError"];
            [self.view makeToast:error.localizedDescription];
        }else{
            if ([responseResult[@"code"] integerValue] == 0) {
                
                [[UIApplication sharedApplication].keyWindow makeToast:responseResult[@"message"] duration:1.5 position:CSToastPositionCenter];
                [[AppDelegate sharedAppDelegate] popViewController];
            }else{
                [self.view makeToast:responseResult[@"message"]];
            }
        }
    }];
}

- (IBAction)guizeAction:(UIButton *)sender {
}

//MARK:---获取我的钱包所有数据
-(void)getData{
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"请求总资产的接口 --- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];

                for (WalletManageModel *walletModel in dataArr) {
                    if ([walletModel.coin.name isEqualToString:self.model.raiseCoin]) {
                        self.haveRaiseCoinLabel.text = [NSString stringWithFormat:@"%@ %@",walletModel.balance, self.model.raiseCoin];
                    }
                }
                
            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
//            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineView.frame) + 20, kWindowW, 0)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kWindowW * 2, 0);
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

@end
