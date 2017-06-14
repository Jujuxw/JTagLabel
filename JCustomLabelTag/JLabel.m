//
//  JLabel.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/12.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "JLabel.h"

@interface JLabel ()
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation JLabel

- (instancetype)init {
    if (self) {
        self.isSelected = NO;
        self.backgroundColor = Color(154, 166, 181);
        self.textAlignment = NSTextAlignmentCenter;
        self.font = FONT(13);
        self.textColor = [UIColor blackColor];
        self.layer.cornerRadius = 4;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseLabel:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)chooseLabel:(UITapGestureRecognizer *)gesture {
    if (!self.isSelected) {
        self.backgroundColor = Color(28, 0, 120);
        self.textColor = [UIColor whiteColor];
        self.isSelected = YES;
    }else {
        self.backgroundColor = Color(154, 166, 181);
        self.textColor = [UIColor blackColor];
        self.isSelected = NO;
    }
    
    if (self.clickLabel) {
        self.clickLabel(self.tag);
    }
}

- (CGSize)updateWithString:(id)text constrainedToWidth:(CGFloat)maxWidth padding:(CGSize)padding minimumWidth:(CGFloat)minimumWidth {
    CGSize textSize = CGSizeZero;
    BOOL isTextAttributedStr = [text isKindOfClass:[NSAttributedString class]];
    
    if (isTextAttributedStr) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [attributedString addAttributes:@{NSFontAttributeName: FONT(13)} range:NSMakeRange(0, ((NSAttributedString *)text).string.length)];
        textSize = [attributedString boundingRectWithSize:CGSizeMake(self.frame.size.width, 30) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.attributedText = [attributedString copy];
    }else {
        textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FONT(13)} context:nil].size;
        self.text = text;
    }
    textSize.width = MAX(textSize.width, minimumWidth);
    textSize.height += padding.height*2;
    
    [self setFrame:CGRectMake(padding.width, 0, MIN(textSize.width, KSIZE.width), textSize.height)];
    return textSize;
}

@end
