//
//  QDThemeManager.h
//  qmuidemo
//
//  Created by QMUI Team on 2017/5/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDThemeProtocol.h"

/// 简单对 QMUIThemeManager 做一层业务的封装，省去类型转换的工作量
@interface QDThemeManager : NSObject

@property(class, nonatomic, readonly, nullable) NSObject<QDThemeProtocol> *currentTheme;
@end

@interface UIColor (QDTheme)

@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColorLighten;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColorHighlighted;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_tintColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_titleTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_mainTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_descriptionTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_placeholderColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_codeColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_separatorColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_gridItemTintColor;
@end

@interface UIImage (QDTheme)

@property(class, nonatomic, strong, readonly) UIImage * _Nullable qd_searchBarTextFieldBackgroundImage;
@property(class, nonatomic, strong, readonly) UIImage * _Nullable qd_searchBarBackgroundImage;
@end

@interface UIVisualEffect (QDTheme)

@property(class, nonatomic, strong, readonly) UIVisualEffect * _Nullable qd_standardBlurEffect;
@end
