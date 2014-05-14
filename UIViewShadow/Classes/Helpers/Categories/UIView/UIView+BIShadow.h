//
//  UIView+BIShadow.h
//  UIViewShadow
//
//  Created by Bogdan on 13/05/14.
//  Copyright (c) 2014 Bogdan Iusco. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const struct UIViewShadowOffset {
	__unsafe_unretained NSString *top;
	__unsafe_unretained NSString *right;
	__unsafe_unretained NSString *bottom;
    __unsafe_unretained NSString *left;
} UIViewShadowOffset;


typedef NS_OPTIONS(NSUInteger, UIViewShadowAlignment) {
    UIViewShadowNone = 0,
    UIViewShadowTop = 1 << 0,
    UIViewShadowBottom = 1 << 1,
    UIViewShadowLeft = 1 << 2,
    UIViewShadowRight = 1 << 3,
    UIViewShadowOnX = UIViewShadowLeft | UIViewShadowRight,
    UIViewShadowOnY = UIViewShadowTop  | UIViewShadowBottom,
    UIViewShadowAll = UIViewShadowOnX | UIViewShadowOnY
};

@interface UIView (BIShadow)

/**
 * Set shadow path. Uses view's layer to draw it.
 * @param shadowAlignment Alignment of the shadow.
 * @param offsets Pairs of:
 *       - key: Any of the UIViewShadowOffset constants.
 *       - value: NSNumber object. The offset associated with the given key.
 * Examples:
 *      - [self setShadow:UIViewShadowRight withOffsets:@{UIViewShadowOffset.right:@(-5)}];
 *        will place the right shadow with 5 points inside the view.
 *      - [self setShadow:UIViewShadowTop withOffsets:@{UIViewShadowOffset.top:@(30)}];
 *        will place the top shadow with 30 points outside of the view.
 */
- (void)setShadow:(UIViewShadowAlignment)shadowAlignment
      withOffsets:(NSDictionary *)offsets;

/**
 * Updates the shadow's path.
 * These method needs to be called each time the view's bounds value changes.
 */
- (void)updateShadowPath;

/**
 * Set or get the shadow color.
 * Wrapper over the CALayer methods.
 */
@property(nonatomic, strong) UIColor *shadowColor;

/**
 * Set or get the shadow opacity.
 * Wrapper over the CALayer methods.
 * Value should be between [0, 1].
 */
@property(nonatomic, assign) CGFloat shadowOpacity;

@end
