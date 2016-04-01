//
//  WDAlertView.m
//  IOS-WeidaiCreditLoan
//
//  Created by yaoqi on 16/3/25.
//  Copyright © 2016年 . All rights reserved.
//

#import "XXAlertView.h"
#import "Masonry.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0)
#define MainRGBColor RGB(68, 178, 247)

@interface XXAlertView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation XXAlertView

+ (instancetype)sharedAlertView {
    static XXAlertView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XXAlertView alloc] init];
    });
    return _instance;
}

- (void)showAlertViewWithTextString:(NSString *)textString {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    self.maskView = [[UIView alloc] initWithFrame:window.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window addSubview:self.maskView];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 3.f;

    [window addSubview:contentView];
    self.containerView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(101);
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
    }];

    UILabel *titleLabel = ({
        UILabel *_titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _titleLabel.text = @"提示信息";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = MainRGBColor;
        _titleLabel;
    });

    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView.mas_leading).offset(10);
        make.trailing.equalTo(contentView.mas_trailing).offset(-10);
        make.top.equalTo(contentView.mas_top).offset(10);
        make.height.mas_equalTo(21);
    }];

    UIView *lineView = ({
        UIView *_lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MainRGBColor;
        _lineView;
    });
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLabel.mas_leading);
        make.trailing.equalTo(titleLabel.mas_trailing);
        make.height.mas_equalTo(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];

    UILabel *contentLabel = ({
        UILabel *_contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
        _contentLabel.text = textString;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel;
    });

    CGSize textSize = [self boundingRectWithSize:CGSizeMake(180, 0) textString:textString font:contentLabel.font];

    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLabel.mas_leading);
        make.trailing.equalTo(titleLabel.mas_trailing);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(textSize.height);
    }];

    UIButton *sureButton = ({
        UIButton *_sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = MainRGBColor;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 3.0;
        [_sureButton addTarget:self action:@selector(sureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton;
    });

    [contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentLabel.mas_leading);
        make.trailing.equalTo(contentLabel.mas_trailing);
        make.top.equalTo(contentLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(101 + textSize.height);
    }];
    [contentView.superview layoutIfNeeded];

    [window addSubview:self];

    self.containerView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1;
        self.containerView.alpha = 1;
        self.alpha = 1;
    }];
}

- (void)dimiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        self.alpha = 0;
        self.maskView.alpha = 0;
        self.containerView.alpha = 0;
    }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.maskView removeFromSuperview];
            [self.containerView removeFromSuperview];
        }];
}

- (void)sureButtonTapped:(UIButton *)button {
    if (self.sureButtonTapped) {
        self.sureButtonTapped();
    }
    [self dimiss];
}

- (CGSize)boundingRectWithSize:(CGSize)size textString:(NSString *)textString font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [textString boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return retSize;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
