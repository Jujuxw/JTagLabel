//
//  JAlertModel.m
//  JCustomLabelTag
//
//  Created by juju on 2017/6/13.
//  Copyright © 2017年 juju. All rights reserved.
//

#import "JAlertModel.h"

@implementation JAlertModel

- (NSString *)title {
    if (!_title) {
        self.title = @"啦啦啦啦";
    }
    return _title;
}

- (NSString *)desc {
    if (!_desc) {
        _desc = @"点击右上角图标，可以添加标签";
    }
    return _desc;
}

- (NSString *)detail {
    if (!_detail) {
        _detail = @"点击标签可以响应方法，长按标签可以删除标签";
    }
    return _detail;
}

- (NSString *)alignText {
    if (!_alignText) {
        _alignText = @"啦啦啦";
    }
    return _alignText;
}

@end
