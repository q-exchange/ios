//
//  MyPromoteViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/5/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyPromoteViewController.h"
#import "MyPromotePublicViewController.h"
#import "MyPromoteShareView.h"
#import "ZJScrollPageView.h"

@interface MyPromoteViewController ()<ZJScrollPageViewDelegate>{
    MyPromoteShareView *_shareView;
}
@property (nonatomic, strong)  NSArray *menuList;
@property(nonatomic,copy)NSString *promoteLink;//推广链接
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) UIView *headView;
@end

@implementation MyPromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"myPromotion");
    [self.view addSubview:self.headView];
    self.menuList = @[LocalizationKey(@"promoteFriends"),LocalizationKey(@"Myreward")];

    self.promoteLink= [NSString stringWithFormat:@"%@%@",[YLUserInfo shareUserInfo].promotionPrefix,[YLUserInfo shareUserInfo].promotionCode];
    [self loadSegMent];
    [self.view addSubview:self.bottomView];
}

-(void)shareView{
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"MyPromoteShareView" owner:nil options:nil].firstObject;
        _shareView.frame=[UIScreen mainScreen].bounds;
        [_shareView.saveImageButton addTarget:self action:@selector(saveImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        CIImage *codeCIImage = [self createQRForString:self.promoteLink];
        _shareView.QRImage.image = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    }
    [UIApplication.sharedApplication.keyWindow addSubview:_shareView];
}

//MARK:--复制推广链接
-(void)pasteBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.promoteLink;
    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"pastePromoteLink" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
}
//MARK:--复制推广码
- (void)copyFereeCode:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [YLUserInfo shareUserInfo].promotionCode;
    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"pastePromoteCode" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
}
//MARK:--字符串生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:@""];
    [waterimage drawInRect:CGRectMake((size-waterimage.size.width)/2.0, (size-waterimage.size.height)/2.0, waterimage.size.width, waterimage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
//MARK:--取消点击事件
-(void)cancelBtnClick{
    [_shareView removeFromSuperview];
}
//MARK:--保存图片点击事件
-(void)saveImageBtnClick{
    UIImage *saveImage = [self convertViewToImage:_shareView.bgView];
    [self saveImage:saveImage];
}
//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}
//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [_shareView makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"savePhotoFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }
    else {
        [_shareView makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"savePhotoSuccess" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }
}
- (UIImage *)convertViewToImage:(UIView *)view
{
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSInteger)numberOfChildViewControllers {
    return self.menuList.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    MyPromotePublicViewController *childVc = reuseViewController;
    
    if (!childVc) {
        if (index == 0) {
            childVc = [[MyPromotePublicViewController alloc] init];
            childVc.index = index;
        }else if (index == 1){
            childVc = [[MyPromotePublicViewController alloc] init];
            childVc.index = index;
        }
    }
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)loadSegMent{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    //颜色渐变
    style.gradualChangeTitleColor = YES;
    //背景色
    style.segBackgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
    //字体默认颜色
    style.normalTitleColor = QDThemeManager.currentTheme.themeTitleTextColor;
    //字体选中颜色
    style.selectedTitleColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    //线条颜色
    style.scrollLineColor = QDThemeManager.currentTheme.themeSelectedTitleColor;
    style.contentViewBounces = NO;
    style.autoAdjustTitlesWidth = YES;
    
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, kWindowH - Height_NavBar - 160 - self.bottomView.frame.size.height) segmentStyle:style titles:self.menuList parentViewController:self delegate:self];
    
    [self.view addSubview:_scrollPageView];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        if (IS_IPHONE_X_All) {
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH - Height_NavBar - 90 - SafeAreaBottomHeight, kWindowW, 90 + SafeAreaBottomHeight)];
        }else{
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH - Height_NavBar - 90, kWindowW, 90)];
        }
        _bottomView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWindowW / 2, 35)];
        label.font = [UIFont systemFontOfSize:14];
        NSString *str1 = LocalizationKey(@"fereecode");
        NSString *str2 = [YLUserInfo shareUserInfo].promotionCode;
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",str1, str2]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str1.length + 1)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(str1.length + 1, str2.length)];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:QDThemeManager.currentTheme.themeTitleTextColor range:NSMakeRange(0, str1.length + 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(str1.length + 1, str2.length)];
        label.attributedText = attStr;
        [_bottomView addSubview:label];
        
        UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cBtn.frame = CGRectMake(kWindowW - 85, 5, 75, 25);
        [cBtn setTitle:LocalizationKey(@"copy") forState:UIControlStateNormal];
        [cBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [cBtn setBackgroundColor:QDThemeManager.currentTheme.themeBackgroundDescriptionColor];
        [cBtn addTarget:self action:@selector(copyFereeCode:) forControlEvents:UIControlEventTouchUpInside];
        cBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:cBtn];
        
        NSArray *titles = @[LocalizationKey(@"Copylink"), LocalizationKey(@"QRCode")];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 10 * i + i * ((kWindowW - 30) / 2), CGRectGetMaxY(label.frame) + 10, (kWindowW - 30) / 2, 35)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:QDThemeManager.currentTheme.themeTitleTextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            if (i == 0) {
                [btn setBackgroundColor:baseColor];
                [btn addTarget:self action:@selector(pasteBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btn setBackgroundColor:RGBACOLOR(146, 190, 240, 1)];
                [btn addTarget:self action:@selector(shareView) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_bottomView addSubview:btn];
        }

    }
    return _bottomView;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 160)];
        _headView.backgroundColor = QDThemeManager.currentTheme.themeBackgroundColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWindowW - 20, 140)];
        imageView.image = [UIImage imageNamed:@"bg1"];
        imageView.layer.cornerRadius = 10;
        [_headView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, kWindowW - 50, 20)];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        label.text = LocalizationKey(@"inviteFriendJoin");
        [_headView addSubview:label];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame) + 10, kWindowW - 50, 160 - 90)];
        label1.numberOfLines = 0;
        label1.textColor = QDThemeManager.currentTheme.themeTitleTextColor;
        label1.text = [NSString stringWithFormat:@"%@\n%@",LocalizationKey(@"promoteShareTip1"),LocalizationKey(@"promoteShareTip2")];
        label1.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:label1];
        
    }
    return _headView;
}

@end
