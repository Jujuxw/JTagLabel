//
//  ViewController.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/12.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "JController.h"
#import "JLabelView.h"
#import "JAddLabelController.h"
#import "JAlertView.h"
#import "JAlertModel.h"
@interface JController ()
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) JLabelView *labelView;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) UIImageView *leftAlign;
@property (nonatomic, strong) UIImageView *rightAlign;
@end

@implementation JController {
    BOOL isLeftAlign;
    NSString *filePath;
}

- (void)viewDidLoad {
    
    self.title = @"自定义标签";
    [super viewDidLoad];
    isLeftAlign = YES; //默认左对齐
    [self initLabelArray];//初始化标签数组,存储本地
    [self setAddButton];//设置添加标签button
    [self setChangeAlign];//改变对齐方式
    [self addLabelView:isLeftAlign];//初始化签标签view
    [self setAlertView];//设置弹窗
}

- (void)initLabelArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    filePath = [cachesDir stringByAppendingPathComponent:@"test.txt"];
    self.labelArray = [[NSMutableArray alloc] initWithObjects:@"全部（1162）",
                       @"满意（1155）",
                       @"不满意（7）",
                       @"有图（20）",
                       @"送货快（144）",
                       @"未到好（110）",
                       @"服务不错（72）",
                       @"分量足（64）",
                       @"食材新鲜(57)",
                       @"包装精美（50）",
                       @"物美价廉(49)", nil];
    
    if([self.labelArray writeToFile:filePath atomically:YES]){
        NSLog(@"存入成功");
    }
    NSLog(@"%@",[NSMutableArray arrayWithContentsOfFile:filePath]);
}

- (void)setAddButton {
    [self.view addSubview:self.addImageView];
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-30);
        make.top.equalTo(@100);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
}

- (void)setChangeAlign {
    
    self.leftAlign.highlighted = YES;
    self.leftAlign.userInteractionEnabled = NO;
    [self.view addSubview:self.leftAlign];
    [self.view addSubview:self.rightAlign];
    
    [self.rightAlign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addImageView);
        make.right.equalTo(self.addImageView.mas_left).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.leftAlign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addImageView);
        make.right.equalTo(self.rightAlign.mas_left).offset(-5);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
}

- (void)changeAlign:(UITapGestureRecognizer *)gesture{
    UIView *view = gesture.view;
    if (view.tag == 201) {
        [self.labelView removeFromSuperview];
        [self addLabelView:NO];
        self.leftAlign.highlighted = NO;
        self.rightAlign.highlighted = YES;
        self.rightAlign.userInteractionEnabled = NO;
        self.leftAlign.userInteractionEnabled = YES;
    }else {
        [self.labelView removeFromSuperview];
        [self addLabelView:YES];
        self.leftAlign.highlighted = YES;
        self.rightAlign.highlighted = NO;
        self.leftAlign.userInteractionEnabled = NO;
        self.rightAlign.userInteractionEnabled = YES;
    }
}

- (void)setAlertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        JAlertModel *model = [[JAlertModel alloc] init];
        model.title = @"通知";
        model.alignText = @"灰色为选中状态，不可再点击；点击黑色切换对齐方式";
        JAlertView *alertView = [[JAlertView alloc] init];
        alertView.model = model;
        [alertView show];
    });
}

- (void)addLabelView:(BOOL)leftAlign {
    self.labelView = [[JLabelView alloc] initWithFrame:CGRectMake(0, 150, KSIZE.width, KSIZE.height)];
    
    [self.labelView setLeftAlign:leftAlign];
    [self.labelView setLabel:[NSMutableArray arrayWithContentsOfFile:filePath]];
    [self.view addSubview:self.labelView];
    WS(weakSelf);
    __weak NSString *path = filePath;
    self.labelView.deleteLabel = ^(NSInteger tag) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除确定删除吗？" message:@"确定就删了哟！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            __weak NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:path];
            [arr removeObjectAtIndex:tag];
            [weakSelf.labelView setLabel:arr];
            [arr writeToFile:path atomically:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
/*
 *
 *增加标签的响应事件
 *
 */
- (void)addLabelMethod:(UITapGestureRecognizer *)gesture {
    JAddLabelController *add = [[JAddLabelController alloc] init];
    add.returnText = ^(NSString *text) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filePath];
        if ([text length]) {
            [arr addObject:text];
        }
        [self.labelView setLabel:arr];
        [arr writeToFile:filePath atomically:YES];
        NSLog(@"%@",[NSMutableArray arrayWithContentsOfFile:filePath]);
    };
    [self.navigationController pushViewController:add animated:YES];
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
        _addImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLabelMethod:)];
        [_addImageView addGestureRecognizer:tap];
    }
    return _addImageView;
}

- (UIImageView *)leftAlign {
    if (!_leftAlign) {
        _leftAlign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"align_left"] highlightedImage:[UIImage imageNamed:@"leftAlign_highlighted"]];
        _leftAlign.tag = 200;
        _leftAlign.userInteractionEnabled = YES;
        _leftAlign.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAlign:)];
        [_leftAlign addGestureRecognizer:tap];
    }
    return _leftAlign;
}

- (UIImageView *)rightAlign {
    if (!_rightAlign) {
        _rightAlign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"align_right"] highlightedImage:[UIImage imageNamed:@"rightAlign_highlighted"]];
        _rightAlign.tag = 201;
        _rightAlign.userInteractionEnabled = YES;
        _rightAlign.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAlign:)];
        [_rightAlign addGestureRecognizer:tap];
    }
    return _rightAlign;
}

- (JLabelView *)labelView {
    if (!_labelView) {
        _labelView = [[JLabelView alloc] init];
        _labelView.backgroundColor = [UIColor greenColor];
    }
    return _labelView;
}
@end
