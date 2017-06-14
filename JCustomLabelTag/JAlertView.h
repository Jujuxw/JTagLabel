//
//  JAlertView.h
//  JCustomLabelTag
//
//  Created by juju on 2017/6/13.
//  Copyright © 2017年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAlertModel.h"
@interface JAlertView : UIView

@property (nonatomic, strong) JAlertModel *model;
- (void)show;
@end
