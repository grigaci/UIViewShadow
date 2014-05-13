//
//  BIMainView.m
//  UIViewShadow
//
//  Created by Bogdan on 13/05/14.
//  Copyright (c) 2014 Bogdan Iusco. All rights reserved.
//

#import "BIMainView.h"

@implementation BIMainView

#pragma mark - UIView methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self addSubview:self.shadowView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = [self tableViewFrame];
    self.shadowView.frame = [self shadowViewFrame];
}

#pragma mark - Property

- (UIView *)shadowView {
    if (!_shadowView) {
        CGRect frame = [self shadowViewFrame];
        _shadowView = [[UIView alloc] initWithFrame:frame];
        _shadowView.backgroundColor = [UIColor blueColor];
    }
    return _shadowView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = [self tableViewFrame];
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.allowsMultipleSelection = YES;
    }
    return _tableView;
}

#pragma mark - Frame methods

- (CGRect)shadowViewFrame {
    const CGFloat minValue = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.0);
    const CGFloat width =  minValue / 2.0;
    const CGFloat height = width;
    const CGFloat offsetX = (CGRectGetWidth(self.bounds) - width) / 2.0;
    const CGFloat offsetY = (CGRectGetHeight(self.bounds) / 2.0 - height) / 2.0;
    return CGRectMake(offsetX, offsetY, width, height);
}

- (CGRect)tableViewFrame {
    const CGFloat offsetY = CGRectGetHeight(self.bounds) / 2.0;
    const CGFloat height = offsetY;
    return CGRectMake(0.0, offsetY, CGRectGetWidth(self.bounds), height);
}

@end
