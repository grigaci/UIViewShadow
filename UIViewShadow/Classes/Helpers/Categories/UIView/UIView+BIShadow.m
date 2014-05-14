//
//  UIView+BIShadow.m
//  UIViewShadow
//
//  Created by Bogdan on 13/05/14.
//  Copyright (c) 2014 Bogdan Iusco. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+BIShadow.h"

const struct UIViewShadowOffset UIViewShadowOffset = {
	.top    = @"top",
	.right  = @"right",
	.bottom = @"bottom",
    .left   = @"left"
};

@implementation UIView (BIShadow)

#pragma mark - Constants

static void *kShadowAlignmentKey;
static void *kShadowTopOffsettKey;
static void *kShadowBottomOffetKey;
static void *kShadowRightOffsetKey;
static void *kShadowLeftOffsetKey;

const CGFloat kHideShadowValue = 0.0;

#pragma mark - Public methods

- (void)updateShadowPath {

    [self recalculateShadow:nil];
}

- (void)setShadow:(UIViewShadowAlignment)shadowAlignment
      withOffsets:(NSDictionary *)offsets {
    
    [self setShadowAlignment:shadowAlignment];
    [self recalculateShadow:offsets];
}

- (void)setShadowColor:(UIColor *)color {

    self.layer.shadowColor = color.CGColor;
}

- (UIColor *)shadowColor {

    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowOpacity:(CGFloat)opacity {

    self.layer.shadowOpacity = opacity;
}

- (CGFloat)shadowOpacity {

    return self.layer.shadowOpacity;
}

#pragma mark - Private methods

#pragma mark - Shadow drawing methods

- (void)recalculateShadow:(NSDictionary *)offsetData {

    const CGFloat width = CGRectGetWidth(self.bounds) - kHideShadowValue;
    const CGFloat height = CGRectGetHeight(self.bounds) - kHideShadowValue;
    UIViewShadowAlignment shadowAlignment = [ self shadowAlignment];
    
    CGPoint topLeftCornerPoint = CGPointMake(kHideShadowValue, kHideShadowValue);
    CGPoint topRightCornerPoint = CGPointMake(width, kHideShadowValue);
    CGPoint bottomRightCornerPoint = CGPointMake(width, height);
    CGPoint bottomLeftCornerPoint = CGPointMake(kHideShadowValue, height);
    
    CGFloat topOffset = [self shadowTopOffsetFromDictionary:offsetData];
    CGFloat rightOffset = [self shadowRightOffsetFromDictionary:offsetData];
    CGFloat bottomOffset = [self shadowBottomOffsetFromDictionary:offsetData];
    CGFloat leftOffset = [self shadowLeftOffsetFromDictionary:offsetData];
    
    if (shadowAlignment & UIViewShadowTop) {
        topLeftCornerPoint.y -= (topOffset + kHideShadowValue);
        topRightCornerPoint.y -= (topOffset + kHideShadowValue);
    }
    
    if (shadowAlignment & UIViewShadowRight) {
        topRightCornerPoint.x += (rightOffset + kHideShadowValue);
        bottomRightCornerPoint.x += (rightOffset + kHideShadowValue);
    }
    
    if (shadowAlignment & UIViewShadowBottom) {
        bottomLeftCornerPoint.y +=  (bottomOffset + kHideShadowValue);
        bottomRightCornerPoint.y +=  (bottomOffset + kHideShadowValue);
    }
    
    if (shadowAlignment & UIViewShadowLeft) {
        topLeftCornerPoint.x -= (leftOffset + kHideShadowValue);
        bottomLeftCornerPoint.x -= (leftOffset + kHideShadowValue);
    }
    
    NSArray *points = @[[NSValue valueWithCGPoint:topLeftCornerPoint],
                        [NSValue valueWithCGPoint:topRightCornerPoint],
                        [NSValue valueWithCGPoint:bottomRightCornerPoint],
                        [NSValue valueWithCGPoint:bottomLeftCornerPoint]];
    [self drawShadowForPoints:points];
}

- (void)drawShadowForPoints:(NSArray *)points {

    NSMutableArray *pointsMutable = [points mutableCopy];
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSValue *firstPointValue = [points firstObject];
    CGPoint firstPoint = [firstPointValue CGPointValue];
    [path moveToPoint:firstPoint];
    [pointsMutable removeObject:firstPointValue];
    
    for (NSValue *pointValue in pointsMutable) {
        CGPoint point = [pointValue CGPointValue];
        [path addLineToPoint:point];
    }
    [path closePath];
    self.layer.shadowPath = path.CGPath;
}

#pragma mark - Store values methods

- (void)setShadowAlignment:(UIViewShadowAlignment)shadowAlignment {

    NSInteger _shadowAlignment = [self shadowAlignment];
    if (_shadowAlignment != shadowAlignment) {
        [self setObjectAssociatedValue:@(shadowAlignment) forKey:&kShadowAlignmentKey];
    }
}

- (UIViewShadowAlignment)shadowAlignment {

    NSNumber *shadowAlignmentNumber = [self objectAssociatedValueForKey:&kShadowAlignmentKey];
    NSInteger shadowAlignment = [shadowAlignmentNumber integerValue];
    return shadowAlignment;
}

- (void)setShadowTopOffset:(NSNumber *)topOffset {

    [self setObjectAssociatedValue:topOffset forKey:&kShadowTopOffsettKey];
}

- (NSNumber *)shadowTopOffset {

    NSNumber *topOffset = [self objectAssociatedValueForKey:&kShadowTopOffsettKey];
    topOffset = topOffset ? topOffset : @(0);
    return topOffset;
}

- (void)setShadowLeftOffset:(NSNumber *)leftOffset {

    [self setObjectAssociatedValue:leftOffset forKey:&kShadowLeftOffsetKey];
}

- (NSNumber *)shadowLeftOffset {

    NSNumber *leftOffset = [self objectAssociatedValueForKey:&kShadowLeftOffsetKey];
    leftOffset = leftOffset ? leftOffset : @(0);
    return leftOffset;
}

- (void)setShadowRightOffset:(NSNumber *)rightOffset {

    [self setObjectAssociatedValue:rightOffset forKey:&kShadowRightOffsetKey];
}

- (NSNumber *)shadowRightOffset {

    NSNumber *rightOffset = [self objectAssociatedValueForKey:&kShadowRightOffsetKey];
    rightOffset = rightOffset ? rightOffset : @(0);
    return rightOffset;
}

- (void)setShadowBottomOffset:(NSNumber *)bottomOffset {

    [self setObjectAssociatedValue:bottomOffset forKey:&kShadowBottomOffetKey];
}

- (NSNumber *)shadowBottomOffset {

    NSNumber *bottomOffset = [self objectAssociatedValueForKey:&kShadowBottomOffetKey];
    bottomOffset = bottomOffset ? bottomOffset : @(0);
    return bottomOffset;
}

#pragma mark - Utility methods

- (CGFloat)shadowTopOffsetFromDictionary:(NSDictionary *)dictionary {

    CGFloat topOffset;
    NSNumber *number = dictionary[UIViewShadowOffset.top];
    if (number) {
        topOffset = [number floatValue];
        [self setShadowTopOffset:number];
    } else {
        topOffset = [[self shadowTopOffset] floatValue];
    }
    
    return topOffset;
}

- (CGFloat)shadowBottomOffsetFromDictionary:(NSDictionary *)dictionary {

    CGFloat bottomOffset;
    NSNumber *number = dictionary[UIViewShadowOffset.bottom];
    if (number) {
        bottomOffset = [number floatValue];
        [self setShadowBottomOffset:number];
    } else {
        bottomOffset = [[self shadowBottomOffset] floatValue];
    }
    
    return bottomOffset;
}

- (CGFloat)shadowRightOffsetFromDictionary:(NSDictionary *)dictionary {

    CGFloat rightOffset;
    NSNumber *number = dictionary[UIViewShadowOffset.right];
    if (number) {
        rightOffset = [number floatValue];
        [self setShadowRightOffset:number];
    } else {
        rightOffset = [[self shadowRightOffset] floatValue];
    }
    
    return rightOffset;
}

- (CGFloat)shadowLeftOffsetFromDictionary:(NSDictionary *)dictionary {

    CGFloat leftOffset;
    NSNumber *number = dictionary[UIViewShadowOffset.left];
    if (number) {
        leftOffset = [number floatValue];
        [self setShadowLeftOffset:number];
    } else {
        leftOffset = [[self shadowLeftOffset] floatValue];
    }
    
    return leftOffset;
}

#pragma mark - Associated objects methods

- (id)objectAssociatedValueForKey:(void *)key {
    
    return objc_getAssociatedObject(self, key);
}

- (void)setObjectAssociatedValue:(id)value forKey:(void *)key {

    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

@end
