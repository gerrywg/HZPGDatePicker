//
//  PGDatePickManager.m
//
//  Created by piggybear on 2018/1/7.
//  Copyright © 2018年 piggybear. All rights reserved.
//

#import "PGPickViewController.h"
#import "PGDatePickManagerHeaderView.h"
#import "UIColor+PGHex.h"

@interface PGPickViewController ()
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) PGDatePickManagerHeaderView *headerView;
@property (nonatomic, weak) UIView *dismissView;

@end

@implementation PGPickViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self setupDismissViewTapHandler];
        [self headerViewButtonHandler];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //self.headerView.language = self.datePicker.language;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.headerView.style = self.style;
    self.dismissView.frame = self.view.bounds;
    self.contentView.backgroundColor = self.pickView.backgroundColor;
    if (self.style == PGDatePickManagerStyle1) {
        [self setupStyle1];
    }else if (self.style == PGDatePickManagerStyle2) {
        [self setupStyle2];
    }else {
        [self setupStyle3];
    }
    [self.view bringSubviewToFront:self.contentView];
}

- (void)setupDismissViewTapHandler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewTapMonitor)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)headerViewButtonHandler {
    __weak id weak_self = self;
    self.headerView.cancelButtonHandlerBlock = ^{
        __strong PGPickViewController *strong_self = weak_self;
        [strong_self dismiss];
        //[strong_self cancelButtonHandler];
        if (strong_self.cancelButtonMonitor) {
            strong_self.cancelButtonMonitor();
        }
    };
    self.headerView.confirmButtonHandlerBlock =^{
        __strong PGPickViewController *strong_self = weak_self;
        if (strong_self.confirmButtonHandlerBlock) {
            strong_self.confirmButtonHandlerBlock(strong_self.pickView, strong_self);
        }
        //[strong_self.datePicker tapSelectedHandler];
        //[strong_self cancelButtonHandler];
    };
}

- (void)cancelButtonHandler {
    if (self.style == PGDatePickManagerStyle1) {
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.origin.y = self.view.bounds.size.height;
        __weak typeof (self)weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            weakSelf.contentView.frame = contentViewFrame;
        }completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:false completion:nil];
        }];
    }else {
        [self dismissViewControllerAnimated:false completion:nil];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissViewTapMonitor {
    [self dismiss];
    //[self cancelButtonHandler];
    if (self.cancelButtonMonitor) {
        self.cancelButtonMonitor();
    }
}

- (void)setupStyle1 {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    CGFloat rowHeight = self.pickView.rowHeight==0?44:self.pickView.rowHeight;//默认44高度
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewHeight = rowHeight * 5 + headerViewHeight;
    CGFloat datePickerHeight = contentViewHeight - headerViewHeight - bottom;
    CGRect contentViewFrame = CGRectMake(0,
                                         self.view.bounds.size.height - contentViewHeight,
                                         self.view.bounds.size.width,
                                         contentViewHeight);
    CGRect headerViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight);
    CGRect datePickerFrame = CGRectMake(0,
                                        CGRectGetMaxY(headerViewFrame),
                                        self.view.bounds.size.width,
                                        datePickerHeight);
    
    self.contentView.frame = CGRectMake(0,
                                        self.view.bounds.size.height,
                                        self.view.bounds.size.width,
                                        contentViewHeight);
    self.headerView.frame = headerViewFrame;
    self.pickView.frame = datePickerFrame;
    self.headerView.backgroundColor = self.headerViewBackgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isShadeBackgroud) {
            self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        }
        self.contentView.frame = contentViewFrame;
        self.headerView.frame = headerViewFrame;
        self.pickView.frame = datePickerFrame;
    }];
}

- (void)setupStyle2 {
    CGFloat rowHeight = self.pickView.rowHeight==0?44:self.pickView.rowHeight;//默认44高度
    CGFloat datePickerHeight = rowHeight * 5;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewMarginLeft = 30;
    CGFloat contentViewWidth = self.view.bounds.size.width - contentViewMarginLeft * 2;
    CGFloat contentViewHeight = datePickerHeight  + headerViewHeight;
    self.contentView.frame = CGRectMake(contentViewMarginLeft,
                                        self.view.center.y - contentViewHeight / 2,
                                        contentViewWidth,
                                        contentViewHeight);
    self.headerView.frame = CGRectMake(0, 0, contentViewWidth, headerViewHeight);
    
    CGRect datePickerFrame = self.contentView.bounds;
    datePickerFrame.origin.y = CGRectGetMaxY(self.headerView.frame);
    datePickerFrame.size.height = datePickerHeight;
    self.contentView.layer.cornerRadius = 10;
    self.pickView.layer.cornerRadius = 10;
    self.pickView.frame = datePickerFrame;
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.05
                     animations:^{
                         if (self.isShadeBackgroud) {
                             self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                         }
                         self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

- (void)setupStyle3 {
    CGFloat rowHeight = self.pickView.rowHeight==0?44:self.pickView.rowHeight;//默认44高度
    CGFloat datePickerHeight = rowHeight * 5;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat contentViewMarginLeft = 30;
    CGFloat contentViewWidth = self.view.bounds.size.width - contentViewMarginLeft * 2;
    CGFloat contentViewHeight = datePickerHeight  + headerViewHeight;
    self.contentView.frame = CGRectMake(contentViewMarginLeft,
                                        self.view.center.y - contentViewHeight / 2,
                                        contentViewWidth,
                                        contentViewHeight);
    self.headerView.frame = CGRectMake(0,
                                       self.contentView.bounds.size.height - headerViewHeight,
                                       contentViewWidth,
                                       headerViewHeight);
    CGRect datePickerFrame = self.contentView.bounds;
    datePickerFrame.size.height = datePickerHeight;
    self.pickView.frame = datePickerFrame;
    self.contentView.layer.cornerRadius = 10;
    self.pickView.layer.cornerRadius = 10;
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.05
                     animations:^{
                         if (self.isShadeBackgroud) {
                             self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                         }
                         self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

#pragma Setter

- (void)setIsShadeBackgroud:(BOOL)isShadeBackgroud {
    _isShadeBackgroud = isShadeBackgroud;
    if (isShadeBackgroud) {
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }else {
        self.dismissView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _cancelButtonFont = cancelButtonFont;
    self.headerView.cancelButtonFont = cancelButtonFont;
}

- (void)setCancelButtonText:(NSString *)cancelButtonText {
    _cancelButtonText = cancelButtonText;
    self.headerView.cancelButtonText = cancelButtonText;
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    _cancelButtonTextColor = cancelButtonTextColor;
    self.headerView.cancelButtonTextColor = cancelButtonTextColor;
}

- (void)setConfirmButtonFont:(UIFont *)confirmButtonFont {
    _confirmButtonFont = confirmButtonFont;
    self.headerView.confirmButtonFont = confirmButtonFont;
}

- (void)setConfirmButtonText:(NSString *)confirmButtonText {
    _confirmButtonText = confirmButtonText;
    self.headerView.confirmButtonText = confirmButtonText;
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor {
    _confirmButtonTextColor = confirmButtonTextColor;
    self.headerView.confirmButtonTextColor = confirmButtonTextColor;
}

#pragma Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _contentView =view;
    }
    return _contentView;
}

- (PGPickerView *)pickView {
    if (!_pickView) {
        PGPickerView *datePicker = [[PGPickerView alloc]init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:datePicker];
        
        _pickView = datePicker;
    }
    return _pickView;
}

- (PGDatePickManagerHeaderView *)headerView {
    if (!_headerView) {
        PGDatePickManagerHeaderView *view = [[PGDatePickManagerHeaderView alloc]init];
        [self.contentView addSubview:view];
        _headerView = view;
    }
    return _headerView;
}

- (UIColor *)headerViewBackgroundColor {
    if (!_headerViewBackgroundColor) {
        _headerViewBackgroundColor = [UIColor pg_colorWithHexString:@"#F1EDF6"];
    }
    return _headerViewBackgroundColor;
}

- (CGFloat)headerHeight {
    if (!_headerHeight) {
        _headerHeight = 50;
    }
    return _headerHeight;
}



- (UIView *)dismissView {
    if (!_dismissView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _dismissView = view;
    }
    return _dismissView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = self.headerView.titleLabel;
    }
    return _titleLabel;
}


@end
