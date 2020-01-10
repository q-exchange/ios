//
//  TradeViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 ZTuo. All rights reserved.
//

#import "TradeViewController.h"
#import "commissionViewController.h"
#import "LeftMenuViewController.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "symbolModel.h"
#import "tradeCell.h"
#import "EntrustCell.h"
#import "UIView+LLXAlertPop.h"
#import "HomeNetManager.h"
#import "TradeNetManager.h"
#import "commissionModel.h"
#import "plateModel.h"
#import "MarketNetManager.h"
#import "AppDelegate.h"
#import "StepSlider.h"
#import "MyEntrustInfoModel.h"
#import "MyEntrustTableViewCell.h"
#import "MyEntrustDetailViewController.h"
#import "HistoryTransactionEntrustViewController.h"
#import "EntrustmentRecordViewController.h"//委托记录
#import "AccountSettingInfoModel.h"

#import "MineNetManager.h"
#import "YBPopupMenu.h"
#import "ZTSearchCoinViewController.h"
#import "TurnOutViewController.h"

#define Handicap 12  //买入卖出显示数量

typedef NS_ENUM(NSUInteger, PriceType) {
    PriceType_Fixed,//限价
    PriceType_Market,//市价
    PriceType_Trigger,//止盈止损
};

@interface TradeViewController ()<SocketDelegate,StepSliderDelegate,UIScrollViewDelegate, QMUITextFieldDelegate, YBPopupMenuDelegate>
{
//    BOOL _IsMarketprice;//按市价交易;
    BOOL _IsSell;//卖出;
    double _usdRate;
    NSString* _baseCoinName;
    NSString* _ObjectCoinName;
    int _baseCoinScale;//价格精确度(小数点后几位)
    int _coinScale;//数量精确度
    BOOL _isCollect;//是否收藏了
    
    double allDepthbuyAmount;
    double allDepthsellAmount;
    double _maxValue;

    CGFloat _lastContentOffset;
}
@property(nonatomic,retain) dispatch_source_t timer;
@property (nonatomic, assign) PriceType priceType;
@property (nonatomic,strong) LeftMenuViewController *menu;
@property (weak, nonatomic) IBOutlet UIScrollView *Myscrollview;
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet UIView *titleview;
@property (weak, nonatomic) IBOutlet QMUITextField *PriceTF;

@property (weak, nonatomic) IBOutlet UILabel *CNYPrice;
@property (weak, nonatomic) IBOutlet QMUITextField *AmountTF;

@property (weak, nonatomic) IBOutlet UILabel *Useable;//可用
@property (weak, nonatomic) IBOutlet UILabel *TradeNumber;//委托额
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;//现价
@property (weak, nonatomic) IBOutlet UILabel *nowCNY;
@property (weak, nonatomic) IBOutlet UIButton *TradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *objectCoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *askcontentArr;//卖出数组
@property (nonatomic,strong)NSMutableArray *bidcontentArr;//买入数组
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UILabel *plateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *amountlabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *typeBtn;


//新加
@property (weak, nonatomic) IBOutlet StepSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxValue;
@property(nonatomic,copy)NSString *priceLimitBuy;//限价买入价格 货币
//@property(nonatomic,strong)UIButton *shareButton;//导航栏右侧收藏按钮
@property (weak, nonatomic) IBOutlet QMUILabel *chgLabel;

@property (weak, nonatomic) IBOutlet UIButton *CurrentnowBut;//当前委托

@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;//用户状态

//头部交易对按钮和右边的两个按钮
@property (weak, nonatomic) IBOutlet UIButton *symbolBtn;
@property (weak, nonatomic) IBOutlet UIButton *kLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

//触发价
@property (weak, nonatomic) IBOutlet QMUITextField *triggerTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *triggerHeightConstraint;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *triggerBottomConstraint;//30
@property (weak, nonatomic) IBOutlet UIView *triggerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheights;
@property (weak, nonatomic) IBOutlet QMUILabel *deepLabel;

@property (weak, nonatomic) IBOutlet UIView *typeView;

//盘口显示内容类型 0默认 1只显示买盘 2只显示卖盘
@property (nonatomic, assign) NSInteger platformType;
@end

@implementation TradeViewController

- (NSMutableArray *)askcontentArr
{
    if (!_askcontentArr) {
        _askcontentArr = [NSMutableArray array];
    }
    return _askcontentArr;
}
- (NSMutableArray *)bidcontentArr
{
    if (!_bidcontentArr) {
        _bidcontentArr = [NSMutableArray array];
    }
    return _bidcontentArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.symbolBtn setTitle:[marketManager shareInstance].symbol forState:UIControlStateNormal];
    self.priceType = PriceType_Fixed;//默认限价
    self.Myscrollview.delegate = self;
    self.Myscrollview.showsVerticalScrollIndicator =NO;
    self.Myscrollview.showsHorizontalScrollIndicator =NO;
    
    [self.PriceTF setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0 * kWindowWHOne]];
    [self.PriceTF addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.PriceTF.tag = 1;
    [self.AmountTF setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0 * kWindowWHOne]];
    [self.AmountTF addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.AmountTF.tag = 2;
    [self.triggerTF setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0 * kWindowWHOne]];
    [self.triggerTF addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.triggerTF.placeholder = LocalizationKey(@"Triggerprice");
    self.triggerTF.tag = 3;
    
    self.triggerView.layer.borderColor = RGBOF(0xe6e6e6).CGColor;
    self.triggerView.layer.borderWidth = 1;
    self.triggerView.hidden = YES;
    self.triggerBottomConstraint.constant = 0;
    self.triggerHeightConstraint.constant = 0;
    
    [self getUSDTToCNYRate];
    self.topDistance.constant=0;
    [self LeftsetupNavgationItemWithpictureName:@"tradeLeft"];
    self.viewheights.constant = [self getviewheightspce];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData:)name:CURRENTSELECTED_SYMBOL object:nil];
    
    [self setTablewViewHeard];
    NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
    _baseCoinName = [coinArray lastObject];
    _ObjectCoinName = [coinArray firstObject];
    [self.TradeBtn setTitle:LocalizationKey(@"Buy")forState:UIControlStateNormal];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    [self languageSetting];
    self.objectCoin.text=_ObjectCoinName;
    self.PriceTF.delegate=self;
    self.AmountTF.delegate=self;
    _IsSell=NO;
    self.buyBtn.selected = YES;
    self.sellBtn.selected = NO;
    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];//默认

    //设置sloder属性
    self.slider.delegate = self;
    self.slider.trackHeight = 3;
    self.slider.trackCircleRadius = 6;
    self.slider.sliderCircleRadius = 6;
    self.slider.trackColor= RGBOF(0xE6E6E6);
    self.slider.tintColor = GreenColor;
    self.slider.sliderCircleImage = [UIImage imageNamed:@"circularGreen"];
    [self.slider setMaxCount:5];
    [self.slider setIndex:0 animated:NO];
    self.slider.backgroundColor = [UIColor whiteColor];
    self.mainview.clipsToBounds = YES;
    //现价的手势设置
    UITapGestureRecognizer *tapRecognizerNowPrice=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nowPriceTapClick)];
    self.nowPrice.userInteractionEnabled=YES;
    [self.nowPrice addGestureRecognizer:tapRecognizerNowPrice];
    [self getData:[marketManager shareInstance].symbol];
    [self getPersonAllCollection];
    
    [self initLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];

}

#pragma mark - 换肤通知回调
- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    [self initLayer];
    
    [self.bidtableView reloadData];
    [self.asktableView reloadData];
    [self.entrusttableView reloadData];
}

- (void)initLayer{
    self.Myscrollview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.mainview.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.mainBackView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    
    self.asktableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.bidtableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
    self.entrusttableView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;

    self.triggerView.layer.cornerRadius = 2;
    self.triggerView.layer.borderWidth = 1;
    self.triggerView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.triggerLineView1.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.triggerLineView2.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.triggerTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.triggerTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.triggerTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.priceView.layer.cornerRadius = 2;
    self.priceView.layer.borderWidth = 1;
    self.priceView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.line1.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.line2.backgroundColor = QDThemeManager.currentTheme.themeBorderColor;
    self.PriceTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.PriceTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.PriceTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.amountView.layer.cornerRadius = 2;
    self.amountView.layer.borderWidth = 1;
    self.amountView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.AmountTF.placeholderColor = QDThemeManager.currentTheme.themePlaceholderColor;
    self.AmountTF.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
    self.AmountTF.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self.add1 setTitleColor:QDThemeManager.currentTheme.themePlaceholderColor forState:UIControlStateNormal];
    [self.add2 setTitleColor:QDThemeManager.currentTheme.themePlaceholderColor forState:UIControlStateNormal];
    [self.sub1 setTitleColor:QDThemeManager.currentTheme.themePlaceholderColor forState:UIControlStateNormal];
    [self.sub2 setTitleColor:QDThemeManager.currentTheme.themePlaceholderColor forState:UIControlStateNormal];

    [self.typeBtn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];
    self.typeView.layer.cornerRadius = 2;
    self.typeView.layer.borderWidth = 1;
    self.typeView.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    
    self.CNYPrice.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.Useable.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.sliderMinValue.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.sliderMaxValue.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.TradeNumber.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.plateLabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.pricelabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    self.amountlabel.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    self.slider.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    
    self.spaceView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorMake(8, 23, 35);
        }
        return UIColorMake(248, 247, 251);
    }];
    
    self.weituoLineView.backgroundColor = QDThemeManager.currentTheme.themeSeparatorColor;
    
    [self.CurrentnowBut setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
    
    self.nowCNY.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    [self.symbolBtn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];

    self.objectCoin.textColor = QDThemeManager.currentTheme.themeMainTextColor;
    
    [self.symbolBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"trade_drawer_open_kline_page");
        }
        return UIIMAGE(@"展开-1");
    }] forState:UIControlStateNormal];
    
    [self.moreBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"trade_head_right_pop_normal-1");
        }
        return UIIMAGE(@"trade_head_right_pop_normal");
    }] forState:UIControlStateNormal];
    
    [self.kLineBtn setImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"trade_kline_bg-1");
        }
        return UIIMAGE(@"trade_kline_bg");
    }] forState:UIControlStateNormal];
    
    [self.buyBtn setBackgroundImage:UIIMAGE(@"exchange_buy_vertical_light") forState:UIControlStateSelected];
    [self.sellBtn setBackgroundImage:UIIMAGE(@"exchange_sell_vertical_light") forState:UIControlStateSelected];

    [self.buyBtn setBackgroundImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"exchange_buy_vertical-1");
        }
        return UIIMAGE(@"exchange_buy_vertical");
    }] forState:UIControlStateNormal];
    [self.sellBtn setBackgroundImage:[UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIIMAGE(@"exchange_sell_vertical-1");
        }
        return UIIMAGE(@"exchange_sell_vertical");
    }] forState:UIControlStateNormal];

    [self.sellBtn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateSelected];
    [self.sellBtn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];
    
    [self.buyBtn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateSelected];
    [self.buyBtn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];
    [self.allBtn setTitleColor:QDThemeManager.currentTheme.themeMainTextColor forState:UIControlStateNormal];

    self.deepLabel.layer.cornerRadius = 1;
    self.deepLabel.layer.borderWidth = 1;
    self.deepLabel.layer.borderColor = QDThemeManager.currentTheme.themeBorderColor.CGColor;
    self.deepLabel.textColor = QDThemeManager.currentTheme.themeDescriptionTextColor;
    self.deepLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    self.chgLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
}

/*删除
 */
-(void)deleteCollectionWithsymbol:(NSString*)symbol{
    [MarketNetManager deleteMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                _isCollect=NO;
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
/*添加
 */
-(void)addCollectionWithsymbol:(NSString*)symbol{
    [MarketNetManager addMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                _isCollect=YES;
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark-获取个人全部自选
-(void)getPersonAllCollection{
    _isCollect=NO;
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*symbolArray=(NSArray*)resPonseObj;
                NSArray *dataArr = [symbolModel mj_objectArrayWithKeyValuesArray:symbolArray];
                [dataArr enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:[marketManager shareInstance].symbol]) {
                        _isCollect=YES;
                    }
                }];
                
            }
            else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    } ];
}
//MARK:---现价的手势设置
-(void)nowPriceTapClick{
    if ([self.nowPrice.text floatValue] > 0) {
        self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[self.nowPrice.text floatValue] withlimit:_baseCoinScale]];
        NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
        self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
    }
}

-(void)getSliderValue:(CGFloat)sliderValue{
    NSArray *array = [self.sliderMaxValue.text componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString *numStr = array[0];
    self.AmountTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[numStr floatValue]*sliderValue/4 withlimit:_coinScale]];
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName];

   
}



//MARK:--价格,数量输入输入框点击事件
- (void)textfieldValueChange:(UITextField *)textField{
    if (textField.tag == 1) {
        //价格
        if (self.priceType == PriceType_Fixed) {
            if (_IsSell) {
                self.AmountTF.text = [ToolUtil stringFromNumber:0 withlimit:_baseCoinScale];

                //限价
                [self.slider setIndex:0 animated:NO];
                self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:0.00000000 withlimit:_baseCoinScale],_baseCoinName];
            }else{
                _maxValue = [self.priceLimitBuy doubleValue]/[textField.text doubleValue];
                if ([self.AmountTF.text doubleValue] > _maxValue) {
                    self.AmountTF.text = [ToolUtil stringFromNumber:0 withlimit:_baseCoinScale];
                }
                //限价
                NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                NSString *coinStr = [coinArray firstObject];
                self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.priceLimitBuy doubleValue]/[textField.text doubleValue] withlimit:_coinScale],coinStr];
                [self textfieldValueChange:self.AmountTF];
            }
            
        }
    }else if (textField.tag == 2){
        [self ValueChange:self.AmountTF];
        //数量
        NSArray *array = [self.sliderMaxValue.text componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
        NSString *numStr = array[0];
         if ([textField.text floatValue] <= 0) {
              [self.slider setIndex:0 animated:NO];
         }else if ([textField.text floatValue] > [numStr floatValue]){
             [self.view makeToast:_IsSell?LocalizationKey(@"tradSlideTip2"):LocalizationKey(@"tradSlideTip1") duration:1.5 position:CSToastPositionCenter];
             textField.text = @"";
             self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:0.00000000 withlimit:_baseCoinScale],_baseCoinName];
         }else{
             [self.slider setIndex:[textField.text floatValue]/[numStr floatValue]*4 animated:NO];
         }
    }
}
-(void)setTablewViewHeard{
    [self.asktableView registerNib:[UINib nibWithNibName:@"tradeCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.asktableView.tableFooterView=[UIView new];
    [self.bidtableView registerNib:[UINib nibWithNibName:@"tradeCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.bidtableView.tableFooterView=[UIView new];
    [self.entrusttableView registerNib:[UINib nibWithNibName:@"EntrustCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
     [self.entrusttableView  registerNib:[UINib nibWithNibName:@"MyEntrustTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyEntrustTableViewCell class])];
    self.entrusttableView.tableFooterView=[UIView new];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(![YLUserInfo isLogIn]){
        if (!_IsSell) {
            [self.TradeBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
            [self.TradeBtn setBackgroundColor:GreenColor];
        }else{
            [self.TradeBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
            [self.TradeBtn setBackgroundColor:RedColor];
        }

    }else{
        if (!_IsSell) {
            [self.TradeBtn setTitle:LocalizationKey(@"Buy") forState:UIControlStateNormal];
            [self.TradeBtn setBackgroundColor:GreenColor];
        }else{
            [self.TradeBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
            [self.TradeBtn setBackgroundColor:RedColor];
        }
        
        if ([marketManager shareInstance].symbol) {
            [self getCommissionData:[marketManager shareInstance].symbol];//当前委托
        }
        [self accountSettingData];//账号信息
        [self getPersonAllCollection];//个人自选
    }
    if ([marketManager shareInstance].symbol) {
        [self getSingleAccuracy:[marketManager shareInstance].symbol];//获取单个交易对的精确度
        self.navigationItem.title=[marketManager shareInstance].symbol;
    }
}

//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
            self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self.buyBtn setTitle:LocalizationKey(@"Buy") forState:UIControlStateNormal];
    [self.sellBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
    [self.allBtn setTitle:[NSString stringWithFormat:@"%@",LocalizationKey(@"total")] forState:UIControlStateNormal];
    self.plateLabel.text=LocalizationKey(@"plate");
    self.pricelabel.text=LocalizationKey(@"price");
    self.amountlabel.text=LocalizationKey(@"amonut");
    if (self.priceType == PriceType_Market) {
        [self.typeBtn setTitle:LocalizationKey(@"marketPrice") forState:UIControlStateNormal];
    }else if (self.priceType == PriceType_Fixed){
        [self.typeBtn setTitle:LocalizationKey(@"limitPrice") forState:UIControlStateNormal];
    }else{
        [self.typeBtn setTitle:LocalizationKey(@"Stoploss") forState:UIControlStateNormal];
    }

    self.PriceTF.placeholder=LocalizationKey(@"enterPrice");
    self.AmountTF.placeholder=LocalizationKey(@"commissionamount");
    self.Useable.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"usabel")];
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName];
    if(![YLUserInfo isLogIn]){
        [self.TradeBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];

    }else{
        if (!_IsSell) {
            [self.TradeBtn setTitle:LocalizationKey(@"Buy") forState:UIControlStateNormal];
        }else{
            [self.TradeBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
        }
    }
    
     [self.CurrentnowBut setTitle:LocalizationKey(@"Current")forState:UIControlStateNormal];
    self.deepLabel.text = [NSString stringWithFormat:@"%@1",LocalizationKey(@"depth")];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
     [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
     [SocketManager share].delegate=self;
}

#pragma mark-左侧弹出菜单
- (IBAction)leftMenu:(UIButton *)sender {
    if (!self.menu) {
        self.menu = [[LeftMenuViewController alloc]initWithNibName:@"LeftMenuViewController" bundle:nil];
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  kWindowW, kWindowH);
        [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    }
    [self.menu showFromLeft];
    __weak typeof(self)weakself = self;
    self.menu.block = ^(NSString *baseSymbol, NSString *changeSymbol) {
        [weakself reloadShowDataWithBaseSymbol:baseSymbol changeSymbol:changeSymbol];
    };
}
-(void)reloadShowDataWithBaseSymbol:(NSString *)baseSymbol changeSymbol:(NSString *)changeSymbol{
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@/%@",changeSymbol,baseSymbol];
    [self.symbolBtn setTitle:[NSString stringWithFormat:@"%@/%@",changeSymbol,baseSymbol] forState:UIControlStateNormal];
    
    [self getSingleAccuracy:[marketManager shareInstance].symbol];
    _baseCoinName=baseSymbol;
    _ObjectCoinName=changeSymbol;
    [self.slider setIndex:0 animated:NO];
    self.AmountTF.text=@"";
    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
    if (self.priceType == PriceType_Fixed) {
        //限价
        self.objectCoin.text=_ObjectCoinName;
    }else{
        //市价
        if (!_IsSell) {
            self.objectCoin.text=_baseCoinName;
        }else{
            self.objectCoin.text=_ObjectCoinName;
        }
    }
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [SocketManager share].delegate=self;
    if ([YLUserInfo isLogIn]) {
        [self getCommissionData:[marketManager shareInstance].symbol];
        [self getPersonAllCollection];
    }
}

#pragma mark-头部右侧的进入K线按钮点击事件
- (IBAction)kLineAction:(UIButton *)sender {
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.symbol = [marketManager shareInstance].symbol;
    [[AppDelegate sharedAppDelegate] pushViewController:klineVC withBackTitle:[marketManager shareInstance].symbol];
}
#pragma mark-头部右侧的收藏按钮点击事件
- (IBAction)moreAction:(UIButton *)sender {
    if (![YLUserInfo isLogIn]) {//未登录
        [self showLoginViewController];
        return;
    }
    NSString *coll = @"";
    if (_isCollect) {
        coll = @"collect";
    }else{
        coll = @"uncollect";
    }
    NSArray *titles = @[LocalizationKey(@"chargeMoney"), LocalizationKey(@"Transfer"), LocalizationKey(@"addFavo")];
    NSArray *images = @[@"account_tab_deposit_btn2", @"trad_switch_transfer-1", coll];
    if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqualToString:QDThemeIdentifierDark]) {
        images = @[@"account_tab_deposit_btn2-1", @"trad_switch_transfer", coll];
    }
    
    if (_isCollect) {
        titles = @[LocalizationKey(@"chargeMoney"), LocalizationKey(@"Transfer"), LocalizationKey(@"deleteFavo")];
    }
    
    
    [YBPopupMenu showRelyOnView:sender titles:titles icons:images menuWidth:130 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.arrowDirection = YBPopupMenuArrowDirectionNone;
        popupMenu.showMaskView = NO;
        popupMenu.delegate = self;
        popupMenu.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        popupMenu.backColor = QDThemeManager.currentTheme.themeBackgroundColor;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.fontSize = 13;
        if (@available(iOS 11.0, *)) {
            popupMenu.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }];
    
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (![YLUserInfo isLogIn]) {//未登录
        [self showLoginViewController];
        return;
    }
    if (index == 0) {
        ZTSearchCoinViewController *chargeVC = [[ZTSearchCoinViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:chargeVC];
    }else if (index == 1){
        TurnOutViewController *turn = [[TurnOutViewController alloc] init];
        turn.unit = _baseCoinName;
        turn.from = AccountType_Coin;
        turn.to = AccountType_Curreny;
        [[AppDelegate sharedAppDelegate] pushViewController:turn];
    }else{
        if (_isCollect) {
            [self deleteCollectionWithsymbol:[marketManager shareInstance].symbol];
        }else{
            [self addCollectionWithsymbol:[marketManager shareInstance].symbol];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.asktableView]) {
        return self.askcontentArr.count;
    }else  if ([tableView isEqual:self.bidtableView]) {
        return self.bidcontentArr.count;
    }else{
        return self.contentArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.asktableView]) {
        tradeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
        cell.backview.backgroundColor = kRGBColor(241, 80, 87);
        cell.backview.alpha = 0.1;
        cell.amountLabel.textColor = [QDThemeManager currentTheme].themeMainTextColor;
        if (self.askcontentArr.count>0 ) {
            plateModel*bidplatemodel=[[self.askcontentArr reverseObjectEnumerator] allObjects][indexPath.row];
            if (bidplatemodel.price<0) {
                cell.priceLabel.text=@"--";
                cell.amountLabel.text=@"--";
                cell.priceLabel.textColor=RedColor;

            }else{
                cell.priceLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.price withlimit:_baseCoinScale]];
                if (bidplatemodel.amount>=1000) {
                    cell.amountLabel.text=[NSString stringWithFormat:@"%@K",[ToolUtil stringFromNumber:bidplatemodel.amount/1000 withlimit:_coinScale]];
                }else{
                    cell.amountLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.amount withlimit:_coinScale]];
                }
//                cell.amountLabel.textColor=RedColor;
                cell.priceLabel.textColor=RedColor;
            }
            
            if (bidplatemodel.amount>=0 && allDepthsellAmount > 0) {
                cell.backwidth.constant = bidplatemodel.totalAmount/allDepthsellAmount*cell.contentView.width;
            }else{
                cell.backwidth.constant=0;
            }
        }
        return cell;
    }else if ([tableView isEqual:self.bidtableView]){
        tradeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [QDThemeManager currentTheme].themeBackgroundColor;
        cell.backview.backgroundColor = kRGBColor(42, 178, 116);
        cell.backview.alpha = 0.1;
        cell.amountLabel.textColor = [QDThemeManager currentTheme].themeMainTextColor;
        plateModel*askplatemodel=self.bidcontentArr[indexPath.row];
        if (askplatemodel.price<0) {
            cell.priceLabel.text=@"--";
            cell.amountLabel.text=@"--";
//            cell.amountLabel.textColor=GreenColor;
            cell.priceLabel.textColor=GreenColor;
            cell.backwidth.constant=0;

        }else{
            cell.priceLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.price withlimit:_baseCoinScale]];
            if (askplatemodel.amount>=1000) {
                cell.amountLabel.text=[NSString stringWithFormat:@"%@K",[ToolUtil stringFromNumber:askplatemodel.amount/1000 withlimit:_coinScale]];
            }else{
                cell.amountLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.amount withlimit:_coinScale]];
            }
//            cell.amountLabel.textColor=GreenColor;
            cell.priceLabel.textColor=GreenColor;
        }
        if (askplatemodel.amount>=0 && allDepthbuyAmount > 0) {
            cell.backwidth.constant=askplatemodel.totalAmount/allDepthbuyAmount*cell.contentView.width;
        }else{
            cell.backwidth.constant=0;
        }
        return cell;
    }else{
        EntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_contentArr.count>0) {
            [cell configModel:_contentArr[indexPath.row]];
        }
        cell.withDraw.tag=indexPath.row;
        [cell.withDraw addTarget:self action:@selector(withDraw:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:self.asktableView]||[tableView isEqual:self.bidtableView]) {
        return 25;
    }else{
        return 115;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.priceType == PriceType_Fixed) {
        //限价
        if ([tableView isEqual:self.asktableView]) {

            plateModel*bidplatemodel=[[self.askcontentArr reverseObjectEnumerator] allObjects][indexPath.row];
            if (bidplatemodel.price>=0) {
                self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.price withlimit:_baseCoinScale]];
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                
            }
            [self textfieldValueChange:self.PriceTF];
            
        }else if ([tableView isEqual:self.bidtableView]){
            plateModel*askplatemodel=self.bidcontentArr[indexPath.row];
            if (askplatemodel.price>=0) {
                self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.price withlimit:_baseCoinScale]];
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
            }
            [self textfieldValueChange:self.PriceTF];

        }else{
            
        }
    }else if (self.priceType == PriceType_Trigger){
        if ([tableView isEqual:self.asktableView]) {
            plateModel*bidplatemodel=[[self.askcontentArr reverseObjectEnumerator] allObjects][indexPath.row];
            if (bidplatemodel.price>=0) {
                self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.price withlimit:_baseCoinScale]];
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
            }
            
        }else if ([tableView isEqual:self.bidtableView]){
            plateModel*askplatemodel=self.bidcontentArr[indexPath.row];
            if (askplatemodel.price>=0) {
                self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.price withlimit:_baseCoinScale]];
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
            }
        }else{
            
        }
    }
}
#pragma mark-撤销
-(void)withDraw:(UIButton*)sender{
    commissionModel*model=self.contentArr[sender.tag];
    __weak TradeViewController*weakSelf=self;
    NSString*price;//委托价
    NSString*commissionAmount;//委托量
    NSString*commissionTotal;//委托总额
    if ([model.type isEqualToString:@"LIMIT_PRICE"]) {
        price=[NSString stringWithFormat:@"%@%@",model.price,model.baseSymbol];
        commissionAmount=[NSString stringWithFormat:@"%@%@",model.amount,model.coinSymbol];
        
        NSDecimalNumber *price = [[NSDecimalNumber alloc] initWithString:model.price];
        NSDecimalNumber *tradedAmount = [[NSDecimalNumber alloc] initWithString:model.amount];
        commissionTotal=[NSString stringWithFormat:@"%@%@",[[price decimalNumberByMultiplyingBy:tradedAmount] stringValue],model.baseSymbol];
    }else{
        price=LocalizationKey(@"marketPrice");
        if ([model.direction isEqualToString:@"SELL"]) {
            commissionAmount=[NSString stringWithFormat:@"%.2f%@",[model.amount doubleValue],model.coinSymbol];
            commissionTotal=[NSString stringWithFormat:@"%@%@",@"--",model.baseSymbol];
        }else{
            commissionAmount=[NSString stringWithFormat:@"%@%@",@"--",model.coinSymbol];
            commissionTotal=[NSString stringWithFormat:@"%.2f%@",[model.amount doubleValue],model.baseSymbol];
        }
    }
    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"Confirmation") left1message:price right1message:commissionAmount left2message:commissionTotal right2message:[model.direction isEqualToString:@"BUY"]==YES?LocalizationKey(@"Buy"):LocalizationKey(@"Sell")];
    [showView addItemWithTitle:LocalizationKey(@"Cancelorder") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
        [weakSelf cancelCommissionwithOrderID:model.orderId];//撤单
    }];
    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
    }];
    [showView show];
}

-(void)cancelCommissionwithOrderID:(NSString*)orderId{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [TradeNetManager cancelCommissionwithOrderID:orderId CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                
                [self getAllCoinData:[marketManager shareInstance].symbol];//重新获取钱包余额
                [self getCommissionData:[marketManager shareInstance].symbol];


            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}
#pragma mark-按钮点击事件
- (IBAction)touchEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 100://买入
            {
                _IsSell=NO;
                self.buyBtn.selected = YES;
                self.sellBtn.selected = NO;
                if (!_timer) {
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    [self.TradeBtn setTitle:LocalizationKey(@"Buy") forState:UIControlStateNormal];
                    self.TradeBtn.backgroundColor=GreenColor;
                }

                 NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                if ([YLUserInfo isLogIn]) {
                    [self getBasewalletwithcoin:[coinArray lastObject]];
                    
                }
            }
            if (self.priceType == PriceType_Market) {
                self.heightConstant.constant=0;
                self.PriceTF.text=LocalizationKey(@"Optimal");
                self.PriceTF.enabled=NO;
                self.AmountTF.placeholder=LocalizationKey(@"entrustment");
                self.objectCoin.text=_baseCoinName;
            }else{
                self.heightConstant.constant=35;
                self.PriceTF.text=self.nowPrice.text;
                self.PriceTF.enabled=YES;
                self.AmountTF.placeholder=LocalizationKey(@"amonut");
                self.objectCoin.text=_ObjectCoinName;
            }
            self.slider.sliderCircleImage = [UIImage imageNamed:@"circularGreen"];
            [self.slider setIndex:0 animated:NO];
            self.slider.tintColor = GreenColor;
            self.AmountTF.text=@"";
            self.triggerTF.text = @"";
            break;
        case 101://卖出
        {
            _IsSell=YES;
            self.buyBtn.selected = NO;
            self.sellBtn.selected = YES;
            if (!_timer) {
                self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                [self.TradeBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
                self.TradeBtn.backgroundColor=RedColor;
            }
            
            NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
            if ([YLUserInfo isLogIn]) {
                [self getCoinwalletwithcoin:[coinArray firstObject]];
            }
            if (self.priceType == PriceType_Market) {
                self.heightConstant.constant=0;
                self.PriceTF.text=LocalizationKey(@"Optimal");
                self.PriceTF.enabled=NO;
                self.AmountTF.placeholder=LocalizationKey(@"amonut");
                self.objectCoin.text=_ObjectCoinName;
            }else{
                self.heightConstant.constant=35;
                self.PriceTF.text=self.nowPrice.text;
                self.PriceTF.enabled=YES;
                self.AmountTF.placeholder=LocalizationKey(@"amonut");
                self.objectCoin.text=_ObjectCoinName;
            }
        }
            self.slider.sliderCircleImage = [UIImage imageNamed:@"circularRed"];
            [self.slider setIndex:0 animated:NO];
            self.slider.tintColor = RedColor;
            self.AmountTF.text=@"";
            self.triggerTF.text = @"";
            break;
        case 102://限价Or市价
        {
            [self.PriceTF resignFirstResponder];
            [self.AmountTF resignFirstResponder];
            NSArray *arrayTitle = @[LocalizationKey(@"limitPrice"),LocalizationKey(@"marketPrice"), LocalizationKey(@"Stoploss")];
            UIColor *color = [UIColor blackColor];
            [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] type:0 actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
                [sender setTitle:button.currentTitle forState:UIControlStateNormal];
                [self.slider setIndex:0 animated:NO];
                
                if (didRow==0) {
                    //限价
                    self.triggerHeightConstraint.constant = 0;
                    self.triggerBottomConstraint.constant = 0;
                    self.triggerView.hidden = YES;
                    self.heightConstant.constant=35;
                    self.priceType=PriceType_Fixed;
                    self.PriceTF.text=self.nowPrice.text;
                    self.PriceTF.enabled=YES;
                    self.AmountTF.placeholder=LocalizationKey(@"amonut");
                    self.objectCoin.text=_ObjectCoinName;
                    self.CNYPrice.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.line1.hidden=NO;
                    self.line2.hidden=NO;
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    if (!_IsSell) {
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getBasewalletwithcoin:[coinArray lastObject]];
                        }
                    }else{
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getCoinwalletwithcoin:[coinArray firstObject]];
                        }
                    }
                    
                }else if (didRow==1){
                    //市价
                    self.triggerHeightConstraint.constant = 0;
                    self.triggerBottomConstraint.constant = 0;
                    self.triggerView.hidden = YES;
                    self.priceType = PriceType_Market;
                    self.heightConstant.constant=0;
                    self.PriceTF.text=LocalizationKey(@"Optimal");
                    self.PriceTF.enabled=NO;
                    self.CNYPrice.hidden=YES;
                    self.TradeNumber.hidden=YES;
                    self.TradeNumber.hidden=YES;
                    self.line1.hidden=YES;
                    self.line2.hidden=YES;
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    if (!_IsSell) {
                        //买入
                        self.AmountTF.placeholder=LocalizationKey(@"entrustment");
                        self.objectCoin.text=_baseCoinName;
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getBasewalletwithcoin:[coinArray lastObject]];                }
                    }else{
                        //卖出
                        self.AmountTF.placeholder=LocalizationKey(@"amonut");
                        self.objectCoin.text=_ObjectCoinName;
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getCoinwalletwithcoin:[coinArray firstObject]];
                        }
                    }
                }else if (didRow==2){
                    //止盈止损
                    self.priceType = PriceType_Trigger;
                    self.triggerHeightConstraint.constant = 35;
                    self.triggerBottomConstraint.constant = 30;
                    self.triggerView.hidden = NO;

                    self.heightConstant.constant=35;
                    self.PriceTF.text=self.nowPrice.text;
                    self.PriceTF.enabled=YES;
                    self.AmountTF.placeholder=LocalizationKey(@"amonut");
                    self.objectCoin.text=_ObjectCoinName;
                    self.CNYPrice.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.line1.hidden=NO;
                    self.line2.hidden=NO;
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    if (!_IsSell) {
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getBasewalletwithcoin:[coinArray lastObject]];
                        }
                    }else{
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        if ([YLUserInfo isLogIn]) {
                            [self getCoinwalletwithcoin:[coinArray firstObject]];
                        }
                    }
                }
                self.viewheights.constant = [self getviewheightspce];
                [self layoutSubviewsFrames];
                self.typeBtn.spacingBetweenImageAndTitle = self.typeBtn.frame.size.width - self.typeBtn.titleLabel.frame.size.width - 50;
            }];
        }
            break;
        case 103://价格-
        {
            if ([self.PriceTF.text doubleValue]>0) {
             
                self.PriceTF.text=[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]-(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName];
                [self textfieldValueChange:self.PriceTF];

            }
            
        }
            break;
        case 104://价格+
        {
            if ([self.PriceTF.text doubleValue]>=0) {
               self.PriceTF.text= [ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]+(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
                NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale] ,_baseCoinName];
                [self textfieldValueChange:self.PriceTF];
            }
        }
            break;
        case 105: //下单
        {
            [self.PriceTF resignFirstResponder];
            [self.AmountTF resignFirstResponder];
            if(![YLUserInfo isLogIn]){
                [self showLoginViewController];
                return;
            }
            
            //实名认证
            if (![self.accountInfo.realVerified isEqualToString:@"1"]) {
                [self.view makeToast:LocalizationKey(@"validateYourID") duration:1.5 position:CSToastPositionCenter];
                
                return;
            }
            if (!_IsSell) { /*买入*/
    
                if (self.priceType == PriceType_Fixed) {
            
                    //限价买入
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view makeToast:LocalizationKey(@"enterprice") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleasecommissionamount") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionamountzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionbuy") left1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_objectCoin.text] left2message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right2message:LocalizationKey(@"buyDirection")];
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"BUY"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [EasyShowOptions sharedEasyShowOptions].alertTintColor = [UIColor whiteColor];
                    [EasyShowOptions sharedEasyShowOptions].alertTitleColor = RGBOF(0xe6e6e6);
                    [EasyShowOptions sharedEasyShowOptions].alertMessageColor = mainColor;
                    [showView show];
                }else if (self.priceType == PriceType_Market){
                    //市价买入
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"commissionmoney") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionmoneyzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionbuy") left1message:LocalizationKey(@"marketPrice") right1message:[NSString stringWithFormat:@"%@%@",@"--",_ObjectCoinName] left2message:[NSString stringWithFormat:@"%.8f%@",[self.AmountTF.text doubleValue],_baseCoinName] right2message:LocalizationKey(@"Buy")];
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"BUY"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [showView show];
                }else{
                    //止盈止损
                    if ( [NSString stringIsNull:self.triggerTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleaseenterTrigger") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.triggerTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"TriggerPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view makeToast:LocalizationKey(@"enterprice") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleasecommissionamount") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionamountzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionbuy") left1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_objectCoin.text] left2message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right2message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.triggerTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName]];
                    showView.typeStr = LocalizationKey(@"Triggerprice");
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"BUY"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [EasyShowOptions sharedEasyShowOptions].alertTintColor = [UIColor whiteColor];
                    [EasyShowOptions sharedEasyShowOptions].alertTitleColor = RGBOF(0xe6e6e6);
                    [EasyShowOptions sharedEasyShowOptions].alertMessageColor = mainColor;
                    [showView show];
                }
            }
            else{

             /*卖出*/
                if (self.priceType == PriceType_Fixed) {
             
                    //限价卖出
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleaseenterPrice") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleasecommissionamount") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionamountzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                 
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionsell") left1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_ObjectCoinName] left2message:[NSString stringWithFormat:@"%.8f%@",[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],_baseCoinName] right2message:LocalizationKey(@"sellDirection")];
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"SELL"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [showView show];
                }
                else if (self.priceType == PriceType_Market){
                    //市价卖出
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleasecommissionamount") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionamountzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                  
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionsell") left1message:LocalizationKey(@"marketPrice") right1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_ObjectCoinName] left2message:[NSString stringWithFormat:@"%@%@",@"--",_baseCoinName] right2message:LocalizationKey(@"sellDirection")];
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"SELL"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [showView show];
                }else{
                    //止盈止损
                    if ( [NSString stringIsNull:self.triggerTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleaseenterTrigger") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.triggerTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"TriggerPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleaseenterPrice") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionPricezero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view makeToast:LocalizationKey(@"pleasecommissionamount") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view makeToast:LocalizationKey(@"commissionamountzero") duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                    
                    __weak TradeViewController*weakSelf=self;
                    EasyShowAlertView *showView =[EasyShowAlertView showActionSheetWithTitle:LocalizationKey(@"commissionsell") left1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName] right1message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_ObjectCoinName] left2message:[NSString stringWithFormat:@"%.8f%@",[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],_baseCoinName] right2message:[NSString stringWithFormat:@"%@%@",[ToolUtil stringFromNumber:[self.triggerTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName]];
                    showView.typeStr = LocalizationKey(@"Triggerprice");
                    [showView addItemWithTitle:LocalizationKey(@"confirm") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                        [weakSelf commitBuyCommission:@"SELL"];
                    }];
                    [showView addItemWithTitle:LocalizationKey(@"cancel") itemType:ShowAlertItemTypeBlack callback:^(EasyShowAlertView *showview) {
                    }];
                    [showView show];
                }
            }
        }
            break;
        case 106: //查看全部当前委托
        {
            if(![YLUserInfo isLogIn]){
                [self showLoginViewController];
                return;
            }
            if ([marketManager shareInstance].symbol) {
                EntrustmentRecordViewController *record = [[EntrustmentRecordViewController alloc] init];
                record.symbol = [marketManager shareInstance].symbol;
                [[AppDelegate sharedAppDelegate] pushViewController:record];
                return;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 触发价加减按钮事件方法
- (IBAction)triggerAction:(UIButton *)sender {
    if (sender.tag == 519) {
        //加
        if ([self.triggerTF.text doubleValue]>=0) {
            self.triggerTF.text= [ToolUtil stringFromNumber:[self.triggerTF.text doubleValue]+(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
            NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.triggerTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
        }
    }else if(sender.tag == 520){
        //减
        if ([self.triggerTF.text doubleValue]>0) {
            
            self.triggerTF.text=[ToolUtil stringFromNumber:[self.triggerTF.text doubleValue]-(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
            NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.triggerTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
        }
    }
}
#pragma mark-改变盘口显示个数
- (IBAction)platChange:(UIButton *)sender {
    NSArray *arrayTitle = @[LocalizationKey(@"trade_default"),LocalizationKey(@"buyplate"), LocalizationKey(@"sellplate")];
    [self.view createAlertViewTitleArray:arrayTitle textColor:QDThemeManager.currentTheme.themeTitleTextColor font:[UIFont systemFontOfSize:16] type:0 actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        [sender setTitle:button.currentTitle forState:UIControlStateNormal];
        [self.slider setIndex:0 animated:NO];
        self.platformType = didRow;
//        if (didRow==0) {
//            //默认
//
//            if (self.priceType == PriceType_Trigger) {
//                self.askTableViewHeightConstraint.constant = 150;
//                self.bidTableViewHeightConstraint.constant = 150;
//            }else{
//                self.askTableViewHeightConstraint.constant = 125;
//                self.bidTableViewHeightConstraint.constant = 125;
//            }
//        }else if (didRow==1){
//            //买盘
//            if (self.priceType == PriceType_Trigger) {
//                self.askTableViewHeightConstraint.constant = 0;
//                self.bidTableViewHeightConstraint.constant = 300;
//            }else{
//                self.askTableViewHeightConstraint.constant = 0;
//                self.bidTableViewHeightConstraint.constant = 250;
//            }
//
//        }else if (didRow==2){
//            //卖盘
//            if (self.priceType == PriceType_Trigger) {
//                self.askTableViewHeightConstraint.constant = 300;
//                self.bidTableViewHeightConstraint.constant = 0;
//            }else{
//                self.askTableViewHeightConstraint.constant = 250;
//                self.bidTableViewHeightConstraint.constant = 0;
//            }
//        }
        self.viewheights.constant = [self getviewheightspce];
        [self layoutSubviewsFrames];
    }];
}

#pragma mark-当前委托
- (IBAction)Currententrustmentaction:(id)sender {
    
    [self getCommissionData:[marketManager shareInstance].symbol];

    if ([YLUserInfo isLogIn]) {
        self.viewheights.constant = [self getviewheightspce];
        [self.entrusttableView reloadData];
    }
   
}

#pragma mark-提交委托
-(void)commitBuyCommission:(NSString*)str{
    if (self.priceType == PriceType_Market) {
        //市价提交
        [TradeNetManager SubmissionOfentrustmentWithsymbol:[marketManager shareInstance].symbol withPrice:@"0" withAmount:self.AmountTF.text WithDirection:str withType:@"MARKET_PRICE" withTrigger:@"" CompleteHandle:^(id resPonseObj, int code) {
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    self.PriceTF.text=LocalizationKey(@"Optimal");
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];

                    [self getCommissionData:[marketManager shareInstance].symbol];

                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
        }];
        
    }else if (self.priceType == PriceType_Fixed){
        //xianjia
        [TradeNetManager SubmissionOfentrustmentWithsymbol:[marketManager shareInstance].symbol withPrice:self.PriceTF.text withAmount:self.AmountTF.text WithDirection:str withType:@"LIMIT_PRICE" withTrigger:@"" CompleteHandle:^(id resPonseObj, int code) {
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    [self getCommissionData:[marketManager shareInstance].symbol];

                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }else{
        //止盈止损
        [TradeNetManager SubmissionOfentrustmentWithsymbol:[marketManager shareInstance].symbol withPrice:self.PriceTF.text withAmount:self.AmountTF.text WithDirection:str withType:@"CHECK_FULL_STOP" withTrigger:self.triggerTF.text CompleteHandle:^(id resPonseObj, int code) {
            NSLog(@"止盈止损委托 -- %@", resPonseObj);
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    self.triggerTF.text = @"";
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    [self getCommissionData:[marketManager shareInstance].symbol];
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }
    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getCommissionData:[marketManager shareInstance].symbol];//刷新表格
        [self getAllCoinData:[marketManager shareInstance].symbol];//重新获取钱包余额
    });
}
#pragma mark-获取所有交易币种缩略行情
-(void)getAllCoinData:(NSString*)symbol {
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取所有交易币种缩略行情 --- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    if ([model.symbol isEqualToString:symbol]) {
                        
                        if (model.change <0) {
                            self.chgLabel.backgroundColor = [RedColor colorWithAlphaComponent:0.3];
                            self.chgLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];
                            self.chgLabel.textColor = RedColor;
                        }else{
                            self.chgLabel.backgroundColor = [GreenColor colorWithAlphaComponent:0.3];
                            self.chgLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];
                            self.chgLabel.textColor = GreenColor;
                        }
                        
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        self.nowPrice.text=[ToolUtil stringFromNumber:[model.close doubleValue] withlimit:_baseCoinScale];
                        NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                        NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
                        NSDecimalNumber *baseUsdRate = [NSDecimalNumber decimalNumberWithDecimal:[model.baseUsdRate decimalValue]];
                        self.nowCNY.text=[NSString stringWithFormat:@"≈%.2f CNY",[[[close decimalNumberByMultiplyingBy:baseUsdRate] decimalNumberByMultiplyingBy:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate] doubleValue]];
                        _usdRate= [model.baseUsdRate doubleValue];
                        if (self.priceType == PriceType_Fixed) {
                            self.PriceTF.text=[ToolUtil stringFromNumber:[model.close doubleValue] withlimit:_baseCoinScale];
                            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                            self.heightConstant.constant=35;
                            
                        }else if(self.priceType == PriceType_Market){
                        self.heightConstant.constant=0;
                            self.PriceTF.text=LocalizationKey(@"Optimal");
                        }else{
                            self.PriceTF.text=[ToolUtil stringFromNumber:[model.close doubleValue] withlimit:_baseCoinScale];
                            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                            self.heightConstant.constant=35;
                        }
                        if (model.change <0) {
                            self.nowPrice.textColor=RedColor;
                        }else{
                            self.nowPrice.textColor=GreenColor;
                        }
                        if ([YLUserInfo isLogIn]) {
                            if (!_IsSell) {
                                [self getBasewalletwithcoin:[coinArray lastObject]];
                            }else{
                                [self getCoinwalletwithcoin:[coinArray firstObject]];
                            }
                        }else{
                            
                        }
                    }
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark-切换币种
-(void)reloadShowData:(NSNotification *)notif{
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@/%@",notif.userInfo[@"object"],notif.userInfo[@"base"]];
    [self.symbolBtn setTitle:[NSString stringWithFormat:@"%@/%@",notif.userInfo[@"object"],notif.userInfo[@"base"]] forState:UIControlStateNormal];

   [self getSingleAccuracy:[marketManager shareInstance].symbol];
   _baseCoinName=notif.userInfo[@"base"];
   _ObjectCoinName=notif.userInfo[@"object"];
     [self.slider setIndex:0 animated:NO];
    self.AmountTF.text=@"";
    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
    if (self.priceType == PriceType_Fixed) {
        //限价
         self.objectCoin.text=_ObjectCoinName;
    }else{
        //市价
        if (!_IsSell) {
            self.objectCoin.text=_baseCoinName;
        }else{
            self.objectCoin.text=_ObjectCoinName;
        }
    }
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [SocketManager share].delegate=self;
    NSString*kind=notif.userInfo[@"kind"];
    if ([kind isEqualToString:@"buy"]) {
        //买入
        UIButton*buyBtn=(UIButton*)[self.view viewWithTag:100];
        [self touchEvents:buyBtn];
        
    }else if ([kind isEqualToString:@"sell"]){
        //卖出
        UIButton*sellBtn=(UIButton*)[self.view viewWithTag:101];
        [self touchEvents:sellBtn];
    }else{
        if ([YLUserInfo isLogIn]) {
            [self getCommissionData:[marketManager shareInstance].symbol];
        }
    }
    [self getPersonAllCollection];
}
#pragma mark-查询当前委托
-(void)getCommissionData:(NSString*)symbol{
    if (!symbol) {
        return;
    }
    [TradeNetManager Querythecurrentdelegatesymbol:symbol withpageNo:1 withpageSize:10 CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"当前委托 --- %@",resPonseObj);
        if (code) {

            if (resPonseObj[@"content"]) {
                [self.contentArr removeAllObjects];
                NSArray*contentArray=resPonseObj[@"content"];
                if (contentArray.count==0) {
                    self.entrusttableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"nocurrentData")];
                    [self.contentArr removeAllObjects];
                    [self.entrusttableView reloadData];
                    return ;
                }
                
                for (int i=0; i<contentArray.count; i++) {
                    commissionModel*model = [commissionModel mj_objectWithKeyValues:contentArray[i]];
                    [self.contentArr addObject:model];
                }
                self.viewheights.constant = [self getviewheightspce];
                [self.entrusttableView reloadData];
                
            }else if ([resPonseObj[@"code"] intValue]==4000){
                [YLUserInfo logout];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 计算滑动高度
-(CGFloat)getviewheightspce{
    if (self.priceType == PriceType_Trigger) {
        self.upViewHeightConstraint.constant = 500;
        return 550 + (self.contentArr.count > 0 ? 115 * self.contentArr.count : 160);
    }else{
        self.upViewHeightConstraint.constant = 435;
        return 485 + (self.contentArr.count > 0 ? 115 * self.contentArr.count : 160);
    }
}

- (void)layoutSubviewsFrames{
    if (self.priceType == PriceType_Trigger) {
        if (self.platformType == 0) {
            self.bidTableViewHeightConstraint.constant = 150;
            self.askTableViewHeightConstraint.constant = 150;
        }else if (self.platformType == 1){
            self.bidTableViewHeightConstraint.constant = 300;
            self.askTableViewHeightConstraint.constant = 0;
        }else{
            self.bidTableViewHeightConstraint.constant = 0;
            self.askTableViewHeightConstraint.constant = 300;
        }
        
    }else{
        if (self.platformType == 0) {
            self.bidTableViewHeightConstraint.constant = 125;
            self.askTableViewHeightConstraint.constant = 125;
        }else if (self.platformType == 1){
            self.bidTableViewHeightConstraint.constant = 250;
            self.askTableViewHeightConstraint.constant = 0;
        }else{
            self.bidTableViewHeightConstraint.constant = 0;
            self.askTableViewHeightConstraint.constant = 250;
        }
    }
//    [self.bidtableView reloadData];
//    [self.asktableView reloadData];
//    [self.asktableView setContentOffset:CGPointMake(0, self.asktableView.contentSize.height - self.askTableViewHeightConstraint.constant) animated:NO];
//    NSLog(@"self.asktableView.contentSize.height -- %f",self.asktableView.contentSize.height);
//    NSLog(@"self.asktableView.frame.height -- %f",self.askTableViewHeightConstraint.constant);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.askcontentArr.count > 0) {
                [self.asktableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.askcontentArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
}



#pragma mark-查询盘口信息
-(void)getData:(NSString*)symbol{
    allDepthsellAmount=0;
    allDepthbuyAmount=0;
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [TradeNetManager getexchangeplate:symbol CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"查询盘口信息 ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            [self.askcontentArr removeAllObjects];
            [self.bidcontentArr removeAllObjects];
            if (resPonseObj) {
                NSArray*bidArray=resPonseObj[@"bid"];//买入
                for (int i=0; i<bidArray.count; i++) {
                    plateModel*model = [plateModel mj_objectWithKeyValues:bidArray[i]];
                    [self.bidcontentArr addObject:model];
                }
                
                for (int i=0;i< (self.bidcontentArr.count < Handicap ? self.bidcontentArr.count : Handicap);i++) {
                    plateModel*model=self.bidcontentArr[i];
                    allDepthbuyAmount = allDepthbuyAmount+model.amount;
                    model.totalAmount=allDepthbuyAmount;
                }
                if (self.bidcontentArr.count>=Handicap) {
                    self.bidcontentArr = [NSMutableArray arrayWithArray:[self.bidcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
                }else{
                    int amount=Handicap-(int)self.bidcontentArr.count;
                    for (int i=0; i<amount; i++) {
                        plateModel*model=[[plateModel alloc]init];
                        model.price=-1;
                        model.amount=-1;
                        model.totalAmount=-1;
                        [self.bidcontentArr insertObject:model atIndex:self.bidcontentArr.count];
                    }
                }
                NSArray*askArray=resPonseObj[@"ask"];//卖出
                for (int i=0; i<askArray.count; i++) {
                    plateModel*model = [plateModel mj_objectWithKeyValues:askArray[i]];
                    [self.askcontentArr addObject:model];
                }
                
                for (int i=0;i< (self.askcontentArr.count < Handicap ? self.askcontentArr.count : Handicap);i++) {
                    plateModel*model=self.askcontentArr[i];
                    allDepthsellAmount = allDepthsellAmount+model.amount;
                    model.totalAmount = allDepthsellAmount;
                }
                if (self.askcontentArr.count<Handicap) {
                    int amount = Handicap-(int)self.askcontentArr.count;
                    for (int i=0; i<amount; i++) {
                        plateModel*model=[[plateModel alloc]init];
                        model.price=-1;
                        model.amount=-1;
                        model.totalAmount=-1;
                        [self.askcontentArr insertObject:model atIndex:self.askcontentArr.count];
                    }
                }else{
                    self.askcontentArr = [NSMutableArray arrayWithArray:[self.askcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
                }
                [self.asktableView reloadData];
                [self.bidtableView reloadData];
                [self layoutSubviewsFrames];

            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark-获取单个交易对的精确度
-(void)getSingleAccuracy:(NSString*)symbol{
    [TradeNetManager getSingleSymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            _baseCoinScale=[resPonseObj[@"baseCoinScale"]intValue];
            _coinScale=[resPonseObj[@"coinScale"] intValue];
            [self getAllCoinData:[marketManager shareInstance].symbol];//币种行情
            [self getData:[marketManager shareInstance].symbol];//盘口信息
        }
    }];
  
}
- (IBAction)goLogin:(UIButton *)sender {
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
    }
}
#pragma mark-编辑输入框
- (IBAction)ValueChange:(UITextField *)sender {
    if (self.priceType == PriceType_Fixed) {
        self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"entrustment"),[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName];
        NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
        self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
    }
}
#pragma mark-UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==1) {
        //委托价格框
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = _baseCoinScale;//小数点后需要限制的个数
        for (int i = (int)futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
        return YES;
    }
    else{
     //委托数量框
        if (self.priceType == PriceType_Market) {
            if (!_IsSell) {
                //市价买入
                NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                [futureString  insertString:string atIndex:range.location];
                NSInteger flag=0;
                const NSInteger limited = _baseCoinScale;//小数点后需要限制的个数
                for (int i = (int)futureString.length-1; i>=0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
                return YES;
            }else{
                //市价卖出
                NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                [futureString  insertString:string atIndex:range.location];
                NSInteger flag=0;
                const NSInteger limited = _coinScale;//小数点后需要限制的个数
                for (int i = (int)futureString.length-1; i>=0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
                return YES;
                
            }
        }
        else{
            //限价买入或卖出
            NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
            [futureString  insertString:string atIndex:range.location];
            NSInteger flag=0;
            const NSInteger limited = _coinScale;//小数点后需要限制的个数
            for (int i = (int)futureString.length-1; i>=0; i--) {
                if ([futureString characterAtIndex:i] == '.') {
                    if (flag > limited) {
                        return NO;
                    }
                    break;
                }
                flag++;
            }
            return YES;
            
        }
    }
}

#pragma mark-查询base钱包情况
-(void)getBasewalletwithcoin:(NSString*)coin {
    [TradeNetManager getwallettWithcoin:coin CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary*dict=resPonseObj[@"data"];
                self.Useable.text=[NSString stringWithFormat:@"%@%@ %@",LocalizationKey(@"usabel"),[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_baseCoinScale],coin];
                if (self.priceType == PriceType_Fixed) {
                    //限价
                    NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                    NSString *coinStr = [coinArray firstObject];
                    self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue]/[self.PriceTF.text doubleValue] withlimit:_coinScale],coinStr];
                    self.priceLimitBuy = dict[@"balance"];
                }else if (self.priceType == PriceType_Market){
                   self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_coinScale],coin];
                }else{
                    NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                    NSString *coinStr = [coinArray firstObject];
                    self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue]/[self.PriceTF.text doubleValue] withlimit:_coinScale],coinStr];
                    self.priceLimitBuy = dict[@"balance"];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark-查询coin钱包情况
-(void)getCoinwalletwithcoin:(NSString*)coin {
    [TradeNetManager getwallettWithcoin:coin CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"查询coin钱包情况 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary*dict=resPonseObj[@"data"];
                self.Useable.text=[NSString stringWithFormat:@"%@%@ %@",LocalizationKey(@"usabelSell"),[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_baseCoinScale],coin];
                self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_coinScale],coin];
            }
            else if ([resPonseObj[@"code"] integerValue] ==4000){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate=[NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

kRemoveCellSeparator
- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr = [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd = [SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {
        if (endStr) {
            NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
//            NSLog(@"盘口信息-- PUSH_SYMBOL_THUMB--%@",dic);
            symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
            if ([model.symbol isEqualToString:[marketManager shareInstance].symbol]) {
                self.nowPrice.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[model.close doubleValue] withlimit:_baseCoinScale]];
                NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
                NSDecimalNumber *baseUsdRate = [NSDecimalNumber decimalNumberWithDecimal:[model.baseUsdRate decimalValue]];
                self.nowCNY.text=[NSString stringWithFormat:@"≈%.2f CNY",[[[close decimalNumberByMultiplyingBy:baseUsdRate] decimalNumberByMultiplyingBy:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate] doubleValue]];
                
                if (model.change <0) {
                    self.chgLabel.backgroundColor = [RedColor colorWithAlphaComponent:0.3];
                    self.chgLabel.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];
                    self.chgLabel.textColor = RedColor;
                }else{
                    self.chgLabel.backgroundColor = [GreenColor colorWithAlphaComponent:0.3];
                    self.chgLabel.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];
                    self.chgLabel.textColor = GreenColor;
                }
            }
        }
    }
    else if (cmd==PUSH_EXCHANGE_DEPTH || cmd==PUSH_EXCHANGE_PLATE)
    {
        
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        NSString *symbolstr = dic[@"symbol"];
        if (![symbolstr isEqualToString:[marketManager shareInstance].symbol]) {
            return;
        }
//        NSLog(@"盘口信息--PUSH_EXCHANGE_PLATE--%@",dic);

        if ([dic[@"direction"] isEqualToString:@"SELL"]) {
            [self.askcontentArr removeAllObjects];
            allDepthsellAmount=0;

          //卖
            NSArray*askArray=dic[@"items"];
            for (int i=0; i<askArray.count; i++) {
                plateModel*model = [plateModel mj_objectWithKeyValues:askArray[i]];
                [self.askcontentArr addObject:model];
            }
            for (int i=0;i< (self.askcontentArr.count < Handicap ? self.askcontentArr.count : Handicap);i++) {
                plateModel*model=self.askcontentArr[i];
                allDepthsellAmount=allDepthsellAmount+model.amount;
                model.totalAmount=allDepthsellAmount;
            }
            if (self.askcontentArr.count<Handicap) {
                int amount=Handicap-(int)self.askcontentArr.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.askcontentArr insertObject:model atIndex:self.askcontentArr.count];
                }
            }else{
                self.askcontentArr = [NSMutableArray arrayWithArray:[self.askcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
            }
            [self.asktableView reloadData];
            
        }else{
            [self.bidcontentArr removeAllObjects];
            allDepthbuyAmount=0;

            NSArray*bidArray=dic[@"items"];//买入
            for (int i=0; i<bidArray.count; i++) {
                plateModel*model = [plateModel mj_objectWithKeyValues:bidArray[i]];
                [self.bidcontentArr addObject:model];
            }
            for (int i=0;i< (self.bidcontentArr.count < Handicap ? self.bidcontentArr.count : Handicap);i++) {
                plateModel*model=self.bidcontentArr[i];
                allDepthbuyAmount=allDepthbuyAmount+model.amount;
                model.totalAmount=allDepthbuyAmount;
            }
            
            if (self.bidcontentArr.count>=Handicap) {
                self.bidcontentArr = [NSMutableArray arrayWithArray:[self.bidcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
            }else{
                int amount=Handicap-(int)self.askcontentArr.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.askcontentArr insertObject:model atIndex:self.askcontentArr.count];
                }
            }
            [self.bidtableView reloadData];
        }
    }else if (cmd==PUSH_EXCHANGE_ORDER_COMPLETED||cmd==PUSH_EXCHANGE_ORDER_CANCELED){
        //当前委托数据完成或取消
        [self getCommissionData:[marketManager shareInstance].symbol];
    }else if (cmd==PUSH_EXCHANGE_ORDER_TRADE){
        //当前委托数据变化
        [self getCommissionData:[marketManager shareInstance].symbol];
    }else{
        
        
    }
//    NSLog(@"交易消息-%@--%d",endStr,cmd);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [SocketManager share].delegate = nil;

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
