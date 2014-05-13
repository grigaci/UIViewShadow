//
//  BIMainViewController.m
//  UIViewShadow
//
//  Created by Bogdan on 13/05/14.
//  Copyright (c) 2014 Bogdan Iusco. All rights reserved.
//

#import "BIMainViewController.h"
#import "BIMainView.h"

typedef NS_ENUM(NSUInteger, BIShadowAlignmentType) {
    BIShadowAlignmentTop = 0,
    BIShadowAlignmentBottom,
    BIShadowAlignmentLeft,
    BIShadowAlignmentRight
};

@interface BIMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) BIMainView *mainView;
@property(nonatomic, copy) NSString *cellIdentifier;

@end

@implementation BIMainViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainView];
    
    self.mainView.tableView.delegate = self;
    self.mainView.tableView.dataSource = self;
    [self.mainView.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellIdentifier];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self class] cellTextAtRow:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select an alignment";
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Property

- (BIMainView *)mainView {
    if (!_mainView) {
        _mainView = [[BIMainView alloc] initWithFrame:self.view.bounds];
    }
    return _mainView;
}

- (NSString *)cellIdentifier {
    if (!_cellIdentifier) {
        _cellIdentifier = NSStringFromClass([self class]);
    }
    return _cellIdentifier;
}

#pragma mark - Helper methods

+ (NSString *)cellTextAtRow:(NSUInteger)row {

    NSString *text;
    switch (row) {
        case BIShadowAlignmentTop:
            text = @"Top";
            break;
        case BIShadowAlignmentBottom:
            text = @"Bottom";
            break;
        case BIShadowAlignmentLeft:
            text = @"Left";
            break;
        case BIShadowAlignmentRight:
            text = @"Right";
            break;
        default:
            text = @"Unknown value";
            break;
    }
    return text;
}

@end
