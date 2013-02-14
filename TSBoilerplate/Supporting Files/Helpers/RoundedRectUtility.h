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

#import <Foundation/Foundation.h>

@interface RoundedRectUtility : NSObject
{
	UIColor *fillColor;
	UIColor *borderColor;
	NSNumber *insetX;
	NSNumber *insetY;
	NSInteger cornerRadius;
	CGFloat borderInset;
	CGFloat borderWidth;
}

typedef enum {
    RectCornerNone = 0,
    RectCornerTopLeft = 1,
    RectCornerTopRight = RectCornerTopLeft << 1,
    RectCornerBottomRight = RectCornerTopLeft << 2,
    RectCornerBottomLeft = RectCornerTopLeft << 3,
    RectCornerTop = RectCornerTopLeft | RectCornerTopRight,
    RectCornerBottom = RectCornerBottomLeft | RectCornerBottomRight,
    RectCornerLeft = RectCornerTopLeft | RectCornerBottomLeft,
    RectCornerRight = RectCornerTopRight | RectCornerBottomRight,
    RectCornerAll = RectCornerTopLeft | RectCornerTopRight | RectCornerBottomRight | RectCornerBottomLeft
} RectCorner;

typedef enum {
    RectSizeNone = 0,
    RectSideLeft = 1,
    RectSideTop = RectSideLeft << 1,
    RectSideRight = RectSideLeft << 2,
    RectSideBottom = RectSideLeft << 3,
    RectSideAll = RectSideLeft | RectSideTop | RectSideRight | RectSideBottom
} RectSide;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) NSNumber *insetX;
@property (nonatomic, strong) NSNumber *insetY;
@property (nonatomic, assign) NSInteger insetXValue;
@property (nonatomic, assign) NSInteger insetYValue;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, assign) CGFloat borderInset;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) RectCorner roundedCorners;
@property (nonatomic, assign) RectSide rectSides;
@property (nonatomic, assign) BOOL useMinimumSizeImage;

- (void) configure;


+ (RoundedRectUtility *)roundedRectWithHeight:(CGFloat)height;
+ (RoundedRectUtility *)roundedRectWithHeight:(CGFloat)height width:(CGFloat)width;


- (void)setHeight:(CGFloat)height;

- (UIImage*) roundedRectImage;


@end