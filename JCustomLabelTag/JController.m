//
//  ViewController.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/12.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "ViewController.h"
#import "JLabelView.h"
@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) JLabelView *labelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField addSubview:self.view];
    [self.addButton addSubview:self.view];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(self.addButton.mas_left).offset(20);
        make.top.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textField);
        make.right.equalTo(@20);
        make.left.equalTo(self.textField.mas_right).offset(20);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addLabelWithTag:(NSInteger)tag {
    
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        _addButton.layer.cornerRadius = 5;
        [_addButton setTitle:@"添加标签" forState: UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addLabelWithTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
