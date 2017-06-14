//
//  JAddLabelController.m
//  
//
//  Created by juju on 2017/6/12.
//
//

#import "JAddLabelController.h"

@interface JAddLabelController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation JAddLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.addButton];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@150);
        make.height.equalTo(@40);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.right.equalTo(@-80);
        make.left.equalTo(@80);
        make.height.equalTo(@40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

- (void)addLabelWithTag:(id)sender {
    if (self.returnText) {
        self.returnText(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [_textField becomeFirstResponder];
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        _addButton.layer.cornerRadius = 5;
        _addButton.backgroundColor = [UIColor whiteColor];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addButton.layer.borderWidth = 1.f;
        _addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_addButton setTitle:@"添加标签" forState: UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addLabelWithTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
