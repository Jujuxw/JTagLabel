//
//  JLabelView.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/12.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "JLabelView.h"

#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 10.0f
#define HORIZONTAL_PADDING_DEFAULT 8.0f
#define VERTICAL_PADDING_DEFAULT 6.0f
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor]
#define BORDER_WIDTH 1.0f

@implementation JLabelView {
    BOOL isSelect;
    BOOL isLeftAlign;
    NSMutableArray *array;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.view];
        array = [[NSMutableArray alloc] init];
    }
    return self;
}
//初始化标签数据
- (void)setLabel:(NSArray *)labelArray {
    self.tagArray = [[NSArray alloc] initWithArray:labelArray];
//    self.sizeFit = CGSizeZero;
    if (isLeftAlign) {
        [self display];
    }else {
        if (array.count > 0) {
            [array removeAllObjects];
        }
        [self rigthAlign];
    }
}
//改变对齐方式
- (void)setLeftAlign:(BOOL)leftAlign {
    isLeftAlign = leftAlign;
}

/*
 *右对齐
 *实现原理：
 *1、遍历标签数组，根据每一个text计算每个标签的宽高
 *2、每一个插入的标签靠右间距20，再将前面的标签向左位移当前标签的宽和margin
 *3、累计每个标签的宽度的总和，如果大于屏宽就换行
 */
- (void)rigthAlign {
//    如果页面有JLabel，则清除
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[JLabel class]]) {
        }
        [subview removeFromSuperview];
    }
//    页面添加标签
    for (id text in self.tagArray) {
        JLabel *label = [[JLabel alloc] init];
        label.label.text = text;
        [array addObject:label];
        [self addSubview:label];
    }
    NSInteger tag = 0;
    CGRect preRect = CGRectZero;
    CGRect newRect = CGRectZero;
    CGFloat width = 0.f;
    CGFloat originY = 0.f;
    int tmp = 0;
    for (int i = 0; i < array.count; i++) {
        JLabel *label = array[i];
        
        [label updateWithString:label.label.text
             constrainedToWidth:KSIZE.width - 40
                        padding:CGSizeMake(HORIZONTAL_PADDING_DEFAULT, VERTICAL_PADDING_DEFAULT)
                   minimumWidth:0.0
                      alignment:isLeftAlign];
        label.deleteLabel = ^(NSInteger tag) {
            if (self.deleteLabel) {
                self.deleteLabel(tag);
            }
        };
        newRect = label.frame;
        width += (newRect.size.width + LABEL_MARGIN_DEFAULT);
        if (width >= KSIZE.width) {
            tmp = i;
            width = newRect.size.width + LABEL_MARGIN_DEFAULT;
            originY += (newRect.size.height + BOTTOM_MARGIN_DEFAULT);
        }
        newRect.origin = CGPointMake(label.frame.origin.x, label.frame.origin.y + originY);
        [label setFrame:newRect];
        for (int j = tmp; j < i; j++) {
            JLabel *l = (JLabel *)[array objectAtIndex:j];
            preRect = l.frame;
            if (((JLabel *)array[j]).frame.origin.x - newRect.size.width - LABEL_MARGIN_DEFAULT > 0) {
                preRect.origin = CGPointMake(((JLabel *)array[j]).frame.origin.x - newRect.size.width - LABEL_MARGIN_DEFAULT, newRect.origin.y);
            }
            [l setFrame:preRect];
        }
        if (label.isSelected) {
            [label setBackgroundColor:Color(255, 255, 255)];
        }else {
            [label setBackgroundColor:[UIColor whiteColor]];
        }
        [label setTag:tag];
        tag++;
    }
}
/*
 *左对齐
 *实现原理：
 *1、遍历标签数组，根据每一个text计算每个标签的宽高
 *2、每一个插入的标签位置局上个标签右移当前标签的宽和margin
 *3、累计每个当前标签位置，如果大于屏宽就换行
 */
- (void)display {
    NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[JLabel class]]) {
            [tagViews addObject:subview];
        }
        [subview removeFromSuperview];
    }
    
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    NSInteger tag = 0;
    for (id labelText in self.tagArray) {
        JLabel *label;
        if (tagViews.count > 0) {
            label = [tagViews lastObject];
            [tagViews removeLastObject];
        }else {
            label = [[JLabel alloc] init];
        }
        
        [label updateWithString:labelText
             constrainedToWidth:KSIZE.width - 40
                        padding:CGSizeMake(HORIZONTAL_PADDING_DEFAULT, VERTICAL_PADDING_DEFAULT)
                   minimumWidth:0.0
                      alignment:isLeftAlign];
        
        label.deleteLabel = ^(NSInteger tag) {
            if (self.deleteLabel) {
                self.deleteLabel(tag);
            }
        };
        
        if (gotPreviousFrame) {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + label.frame.size.width + LABEL_MARGIN_DEFAULT > self.frame.size.width) {
                newRect.origin = CGPointMake(20, previousFrame.origin.y + label.frame.size.height + BOTTOM_MARGIN_DEFAULT);
            }else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN_DEFAULT, previousFrame.origin.y);
            }
            newRect.size = label.frame.size;
            [label setFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setBackgroundColor:Color(255, 255, 255)];
        [label setTag:tag];
        if (label.isSelected) {
            [label setBackgroundColor:Color(255, 255, 255)];
        }else {
            [label setBackgroundColor:[UIColor whiteColor]];
        }
        tag++;
        [self addSubview:label];
    }
}

@end

@interface JLabel ()<UIGestureRecognizerDelegate>
@end

@implementation JLabel
{
    NSArray *array;
}
/*
 *
 *初始化每个标签
 *
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSelected = NO;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setTextColor:TEXT_COLOR];
        [_label setShadowColor:TEXT_SHADOW_COLOR];
        [_label setShadowOffset:TEXT_SHADOW_OFFSET];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setFont:FONT(13)];
        [self addSubview:_label];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5];
        [self.layer setBorderColor:BORDER_COLOR.CGColor];
        [self.layer setBorderWidth:BORDER_WIDTH];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseLabel:)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteLabel:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:longPress];
    }
    return self;
}
/*
 *
 *点击每个label的响应事件
 *
 */
- (void)chooseLabel:(UITapGestureRecognizer *)gesture {
    JLabel *label = (JLabel *)gesture.view;
    if (self.clickLabel) {
        self.clickLabel(label.label.text, self.isSelected);
    }
    if (!self.isSelected) {
        self.backgroundColor = Color(255, 181, 197);
        self.isSelected = YES;
    }else {
        self.backgroundColor = Color(255, 255, 255);
        self.isSelected = NO;
    }
}
/*
 *
 *删除标签方法
 *
 */
- (void)deleteLabel:(UILongPressGestureRecognizer *)gesture {
    JLabel *label = (JLabel *)gesture.view;
    if (self.deleteLabel) {
        self.deleteLabel(label.tag);
    }
}
/*
 *
 *根据每个标签的text计算宽高位置
 *
 */
- (void)updateWithString:(id)text constrainedToWidth:(CGFloat)maxWidth padding:(CGSize)padding minimumWidth:(CGFloat)minimumWidth alignment:(BOOL)leftAlign{
    CGSize textSize = CGSizeZero;
    BOOL isTextAttributedStr = [text isKindOfClass:[NSAttributedString class]];
    
    if (isTextAttributedStr) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [attributedString addAttributes:@{NSFontAttributeName: FONT(13)} range:NSMakeRange(0, ((NSAttributedString *)text).string.length)];
        textSize = [attributedString boundingRectWithSize:CGSizeMake(KSIZE.width - 40, 25) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.label.attributedText = [attributedString copy];
    }else {
        textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FONT(13)} context:nil].size;
        self.label.text = text;
    }
    textSize.width = MAX(textSize.width, minimumWidth);
    textSize.height += padding.height*2;
    
    if (!leftAlign) {
        self.frame = CGRectMake(KSIZE.width - 20 - textSize.width - padding.width * 2, 0, textSize.width+padding.width*2, textSize.height);
        self.label.frame = CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    }else {
        self.frame = CGRectMake(20, 0, textSize.width+padding.width*2, textSize.height);
        self.label.frame = CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    }
}

@end
