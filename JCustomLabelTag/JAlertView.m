//
//  JAlertView.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/13.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "JAlertView.h"

@interface JAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *alignLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *okButton;
@end

@implementation JAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.tagLabel];
        [self.backView addSubview:self.addLabel];
        [self.backView addSubview:self.alignLabel];
        [self.backView addSubview:self.okButton];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(self.backView.mas_top).offset(20);
        }];
        [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        }];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(self.addLabel.mas_bottom).offset(10);
        }];
        [self.alignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(self.tagLabel.mas_bottom).offset(10);
        }];
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@60);
            make.right.equalTo(@-60);
            make.height.equalTo(@40);
            make.top.equalTo(self.alignLabel.mas_bottom).offset(20);
            make.bottom.equalTo(self.backView).offset(-20);
        }];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.alpha = 0;
    }
    return self;
}

- (void)setModel:(JAlertModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.addLabel.text = model.desc;
    self.tagLabel.text = model.detail;
    self.alignLabel.text = model.alignText;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.center = self.center;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backView = nil;
    }];
}
//显示弹出框
- (void)show {
    UIView *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.center = self.center;
        self.alpha = 1;
    }];
}

- (void)okAction {
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.center = self.center;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backView = nil;
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.center = self.center;
        _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = MediumFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.textColor = [UIColor blackColor];
        _tagLabel.font = FONT(13);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UILabel *)addLabel {
    if (!_addLabel) {
        _addLabel = [UILabel new];
        _addLabel.textColor = [UIColor blackColor];
        _addLabel.font = FONT(13);
        
        _addLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addLabel;
}

- (UILabel *)alignLabel {
    if (!_alignLabel) {
        _alignLabel = [UILabel new];
        _alignLabel.textColor = [UIColor blackColor];
        _alignLabel.font = FONT(13);
        
        _alignLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alignLabel;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        _okButton.layer.cornerRadius = 8;
        _okButton.layer.masksToBounds = YES;
        [_okButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _okButton.backgroundColor = Color(255, 192, 203);
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = FONT(13);
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _okButton;
}

@end
