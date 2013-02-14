/*
 Copyright (c) 2012 Tyrone Trevorrow
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.
 */

#import "RoundedRectUtility.h"

#pragma mark -

@interface RoundedRectUtility ()
@property (nonatomic, readonly) CGSize minimumSize;
@property (nonatomic, readonly) UIEdgeInsets stretchableCaps;

+ (CGPathRef)newPathForRounding:(RectCorner)rounding forSides:(RectSide)sides withBounds:(CGRect)bounds withCornerRadius:(CGFloat)radius;


@end

@implementation RoundedRectUtility

@synthesize fillColor;
@synthesize borderColor;
@synthesize insetX, insetY;
@synthesize cornerRadius;
@synthesize borderInset;
@synthesize borderWidth;
@synthesize size;
@synthesize roundedCorners, rectSides;
@synthesize useMinimumSizeImage;


- (id) init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void) configure
{
    self.insetXValue =  0.0f;
    self.insetYValue = 0.0f;
    self.cornerRadius = 8.0f;
    self.borderInset = 0.0f;
    self.borderWidth = 1.0f;
    self.roundedCorners = RectCornerAll;
    self.borderColor = [UIColor blackColor];
    self.fillColor = [UIColor whiteColor];
    self.useMinimumSizeImage = YES;
    self.rectSides = RectSideAll;
}

- (void) setInsetXValue:(NSInteger)insetXValue
{
    self.insetX = [NSNumber numberWithInteger: insetXValue];
}

- (void) setInsetYValue:(NSInteger)insetYValue
{
    self.insetY = [NSNumber numberWithInteger: insetYValue];
}

- (NSInteger) insetXValue
{
    return [self.insetX integerValue];
}

- (NSInteger) insetYValue
{
    return [self.insetY integerValue];
}

+ (CGPathRef)newPathForRounding:(RectCorner)rounding forSides:(RectSide)sides withBounds:(CGRect)bounds withCornerRadius:(CGFloat)radius
{
    CGFloat minx = CGRectGetMinX(bounds), maxx = CGRectGetMaxX(bounds);
    CGFloat miny = CGRectGetMinY(bounds), maxy = CGRectGetMaxY(bounds);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Optimisation
    if (rounding == RectCornerNone || radius == 0) {
        CGPathAddRect(path, NULL, bounds);
        return path;
    }
    
    // Draw the arcs, handle paths
    CGPathMoveToPoint(path, NULL, minx, miny+radius);
    
    BOOL borderLeft = DrawLeft(sides);
    BOOL borderRight = DrawRight(sides);
    BOOL borderTop = DrawTop(sides);
    BOOL borderBottom = DrawBottom(sides);
    BOOL cornerTopLeft = DrawTopLeft(rounding);
    BOOL cornerTopRight = DrawTopRight(rounding);
    BOOL cornerBottomRight = DrawBottomRight(rounding);
    BOOL cornerBottomLeft = DrawBottomLeft(rounding);
    
    
    // Top left
    if ((borderLeft || borderTop)) {
        if (cornerTopLeft) {
            CGPathAddArcToPoint(path, NULL, minx, miny, minx+radius, miny, radius);
        } else {
            if (borderLeft) {
                CGPathAddLineToPoint(path, NULL, minx, miny);
            } else {
                CGPathMoveToPoint(path, NULL, minx, miny);
            }
            if (borderTop) {
                CGPathAddLineToPoint(path, NULL, minx+radius, miny);
            } else {
                CGPathMoveToPoint(path, NULL, minx+radius, miny);
            }
        }
    } else {
        CGPathMoveToPoint(path, NULL, minx+radius, miny);
    }
    
    // Top
    if (borderTop) {
        CGPathAddLineToPoint(path, NULL, maxx-radius, miny);
    } else {
        CGPathMoveToPoint(path, NULL, maxx-radius, miny);
    }
    
    // Top right
    if ((borderRight || borderTop)) {
        if (cornerTopRight) {
            CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, miny+radius, radius);
        } else {
            if (borderTop) {
                CGPathAddLineToPoint(path, NULL, maxx, miny);
            } else {
                CGPathMoveToPoint(path, NULL, maxx, miny);
            }
            if (borderRight) {
                CGPathAddLineToPoint(path, NULL, maxx, miny+radius);
            } else {
                CGPathMoveToPoint(path, NULL, maxx, miny+radius);
            }
        }
    } else {
        CGPathMoveToPoint(path, NULL, maxx, miny+radius);
        
    }
    
    // Right
    if (borderRight) {
        CGPathAddLineToPoint(path, NULL, maxx, maxy-radius);
    } else {
        CGPathMoveToPoint(path, NULL, maxx, maxy-radius);
    }
    
    // Bottom right
    if ((borderRight || borderBottom)) {
        if (cornerBottomRight) {
            CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx-radius, maxy, radius);
        } else {
            if (borderRight) {
                CGPathAddLineToPoint(path, NULL, maxx, maxy);
            } else {
                CGPathMoveToPoint(path, NULL, maxx, maxy);
            }
            if (borderBottom) {
                CGPathAddLineToPoint(path, NULL, maxx-radius, maxy);
            } else {
                CGPathMoveToPoint(path, NULL, maxx-radius, maxy);
            }
        }
    } else {
        CGPathMoveToPoint(path, NULL, maxx-radius, maxy);
    }
    
    // Bottom
    if (borderBottom) {
        CGPathAddLineToPoint(path, NULL, minx+radius, maxy);
    } else {
        CGPathMoveToPoint(path, NULL, minx+radius, maxy);
    }
    
    // Bottom left
    if ((borderLeft || borderBottom)) {
        if (cornerBottomLeft) {
            CGPathAddArcToPoint(path, NULL, minx, maxy, minx, maxy-radius, radius);
        } else {
            if (borderBottom) {
                CGPathAddLineToPoint(path, NULL, minx, maxy);
            } else {
                CGPathMoveToPoint(path, NULL, minx, maxy);
            }
            if (borderLeft) {
                CGPathAddLineToPoint(path, NULL, minx, maxy-radius);
            } else {
                CGPathMoveToPoint(path, NULL, minx, maxy-radius);
            }
        }
    } else {
        CGPathMoveToPoint(path, NULL, minx, maxy-radius);
    }
    
    // Left
    if (borderLeft) {
        CGPathAddLineToPoint(path, NULL, minx, miny+radius);
    } else {
        CGPathMoveToPoint(path, NULL, minx, miny+radius);
    }
    
    //    CGPathCloseSubpath(path);
    
    return path;
}

- (UIImage*) roundedRectImage
{
    CGRect rect;
    if (self.useMinimumSizeImage) {
        rect = CGRectMake(0, 0, self.minimumSize.width, self.minimumSize.height);
    } else {
        rect = CGRectMake(0, 0, self.size.width, self.size.height);
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, borderWidth);
	if (borderColor != nil) {
		CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
	} else {
		CGContextSetStrokeColorWithColor(context, self.fillColor.CGColor);
	}
	CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    NSInteger insetX_ = self.insetXValue;
	NSInteger insetY_ = self.insetYValue;
    CGRect roundedRectBounds = CGRectMake(insetX_+borderInset, insetY_+borderInset, rect.size.width - (insetX_ * 2.0) - (borderInset * 2.0), rect.size.height - (insetY_ * 2.0) - (borderInset * 2.0));
    roundedRectBounds = CGRectInset(roundedRectBounds, self.borderWidth / 2.0f, self.borderWidth / 2.0f);
    CGPathRef roundedRectPath = [RoundedRectUtility newPathForRounding: self.roundedCorners
                                                              forSides: self.rectSides
                                                            withBounds: roundedRectBounds
                                                      withCornerRadius: self.cornerRadius];
    CGContextAddPath(context, roundedRectPath);
    CGPathRelease(roundedRectPath);
	CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets caps = self.stretchableCaps;
    image = [image stretchableImageWithLeftCapWidth: caps.left topCapHeight: caps.top];
    UIGraphicsEndImageContext();
    return image;
}

NS_INLINE BOOL DrawTopLeft(NSInteger corners)
{
	if ((corners & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawTopRight(NSInteger corners)
{
	if (((corners >> 1) & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawBottomRight(NSInteger corners)
{
	if (((corners >> 2) & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawBottomLeft(NSInteger corners)
{
	if (((corners >> 3) & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawLeft(NSInteger sides)
{
	if ((sides & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawRight(NSInteger sides)
{
	if (((sides >> 1) & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawTop(NSInteger sides)
{
	if (((sides >> 2) & 1) == 1) {
		return YES;
	}
	return NO;
}

NS_INLINE BOOL DrawBottom(NSInteger sides)
{
	if (((sides >> 3) & 1) == 1) {
		return YES;
	}
	return NO;
}

- (CGSize) minimumSize
{
    CGSize minSize = CGSizeMake(0, 0);
    minSize.width += ((self.insetXValue+borderInset) * 2.0);
    minSize.height += ((self.insetYValue+borderInset) * 2.0);
    
    if (DrawTopLeft(self.roundedCorners) || 
        DrawTopRight(self.roundedCorners) || 
        DrawBottomLeft(self.roundedCorners) || 
        DrawBottomRight(self.roundedCorners)) 
    {
        minSize.width += self.cornerRadius * 2.0f;
        minSize.height += self.cornerRadius * 2.0f;
    }
    
    minSize.width = ceilf(minSize.width);
    minSize.height = ceilf(minSize.height);
    
    if ((int)minSize.width % 2 == 0) {
        minSize.width += 1.0f;
    }
    if ((int)minSize.height %2 == 0) {
        minSize.height += 1.0f;
    }
    
    minSize.width = MAX(minSize.width, self.borderWidth * 2 + 3);
    minSize.height = MAX(minSize.height, self.borderWidth * 2 + 3);
    
    return minSize;
}

- (UIEdgeInsets) stretchableCaps
{
    UIEdgeInsets caps = UIEdgeInsetsMake(0, 0, 0, 0);
    caps.left += (self.insetXValue+borderInset);
    caps.top += (self.insetYValue+borderInset);
    
    if (DrawTopLeft(self.roundedCorners) || 
        DrawTopRight(self.roundedCorners) || 
        DrawBottomLeft(self.roundedCorners) || 
        DrawBottomRight(self.roundedCorners)) 
    {
        caps.top += self.cornerRadius;
        caps.left += self.cornerRadius;
    }
    caps.top = MAX(caps.top, self.borderWidth);
    caps.left = MAX(caps.left, self.borderWidth);
    return caps;
}

+ (RoundedRectUtility *)roundedRectWithHeight:(CGFloat)height
{
	RoundedRectUtility *utility = [RoundedRectUtility new];
    utility.size = CGSizeMake(320.0f, height);
    return utility;
}

+ (RoundedRectUtility *)roundedRectWithHeight:(CGFloat)height width:(CGFloat)width
{
    RoundedRectUtility *utility = [RoundedRectUtility new];
    utility.size = CGSizeMake(width, height);
    return utility;
}
 
- (void)setHeight:(CGFloat)height
{
	self.size = CGSizeMake(self.size.width, height);
}


@end