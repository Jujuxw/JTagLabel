//
//  JLabelView.h
//  JCustomLabelTag
//
//  Created by juju on 2017/6/12.
//  Copyright © 2017年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLabel;
@interface JLabelView : UIScrollView

@property (nonatomic, strong) UIView  *view;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, strong) void(^deleteLabel)(NSInteger tag);

- (void)setLabel:(NSArray *)labelArray;
- (void)setLeftAlign:(BOOL)leftAlign;
@end


@interface JLabel : UIView

@property (nonatomic, copy) void(^ clickLabel)(NSString *text, BOOL isSelected);
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) void(^deleteLabel)(NSInteger tag);

- (void)updateWithString:(id)text
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth
               alignment:(BOOL)leftAlign;

@end
