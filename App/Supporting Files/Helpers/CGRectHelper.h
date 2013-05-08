#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


CG_INLINE CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

CG_INLINE CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

CG_INLINE CGRect CGRectSetX(CGRect rect, CGFloat x)
{
	CGRect r = rect;
	r.origin.x = x;
	return r;
}

CG_INLINE CGPoint CGRectCenter(CGRect rect)
{
	return CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
}

CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y)
{
	CGRect r = rect;
	r.origin.y = y;
	return r;
}

CG_INLINE CGRect CGRectSetOrigin(CGRect rect, CGPoint origin)
{
	CGRect r = rect;
	r.origin = origin;
	return r;
}

CG_INLINE CGRect CGRectSetSize(CGRect rect, CGSize size)
{
	CGRect r = rect;
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectSetWidth(CGRect rect, CGFloat width)
{
	CGRect r = rect;
	r.size.width = width;
	return r;
}

CG_INLINE CGRect CGRectSetHeight(CGRect rect, CGFloat height)
{
	CGRect r = rect;
	r.size.height = height;
	return r;
}

CG_INLINE CGRect CGRectMakeWithPointAndSize(CGPoint origin, CGSize size)
{
	CGRect r;
	r.origin = origin;
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectCenteredInnerRect(CGPoint centrePoint, CGSize size)
{
	CGRect r;
	r.origin = CGPointMake(centrePoint.x - (size.width / 2), centrePoint.y - (size.height / 2));
	r.size = size;
	return r;
}

CG_INLINE CGRect CGRectCenteredInsideRect(CGRect outerRect, CGRect innerRect)
{
	return CGRectCenteredInnerRect(CGRectCenter(outerRect), innerRect.size);
}

CG_INLINE CGRect CGRectSwapXY(CGRect rect)
{
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}

CG_INLINE CGRect CGRectSwapOrigin(CGRect rect)
{
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.width, rect.size.height);
}

CG_INLINE CGRect CGRectSubtract(CGRect rect1, CGRect rect2)
{
	CGRect r = rect1;
	if (CGRectGetWidth(rect1) == CGRectGetWidth(rect2)) {
		if (CGRectGetMinY(rect1) == CGRectGetMinY(rect2)) {
			r.origin.y += CGRectGetHeight(rect2);
			r.size.height -= CGRectGetHeight(rect2);
		} else if (CGRectGetMaxY(rect1) == CGRectGetMaxY(rect2)) {
			r.size.height -= CGRectGetHeight(rect2);
		}
	} else if (CGRectGetHeight(rect1) == CGRectGetHeight(rect2)) {
		if (CGRectGetMinX(rect1) == CGRectGetMinX(rect2)) {
			r.origin.x += CGRectGetWidth(rect2);
			r.size.width -= CGRectGetWidth(rect2);
		} else if (CGRectGetMaxX(rect1) == CGRectGetMaxX(rect2)) {
			r.size.width -= CGRectGetWidth(rect2);
		}
	}
	
	return r;
}

// Creates the smallest possible rect that contains both p1 and p2
CG_INLINE CGRect CGRectMakeContainingPoints(CGPoint p1, CGPoint p2)
{
    CGFloat minX = MIN(p1.x, p2.x);
    CGFloat maxX = MAX(p1.x, p2.x);
    CGFloat minY = MIN(p1.y, p2.y);
    CGFloat maxY = MAX(p1.y, p2.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

// Creates the smallest possible rect that contains both r and p
CG_INLINE CGRect CGRectUnionPoint(CGRect r, CGPoint p)
{
    CGFloat minX = MIN(r.origin.x, p.x);
    CGFloat maxX = MAX(r.origin.x + r.size.width, p.x);
    CGFloat minY = MIN(r.origin.y, p.y);
    CGFloat maxY = MAX(r.origin.y + r.size.height, p.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

CG_INLINE CGPoint CGPointRoundToInt(CGPoint point)
{
	return CGPointMake(round(point.x), round(point.y));
}

CG_INLINE CGSize CGSizeRoundToInt(CGSize size)
{
	return CGSizeMake(round(size.width), round(size.height));
}

CG_INLINE CGRect CGRectRoundToInt(CGRect rect)
{
    return CGRectMake(round(rect.origin.x), round(rect.origin.y), round(rect.size.width), round(rect.size.height));
}

CG_INLINE CGRect CGRectMakeAroundCenterPoint(CGPoint center, CGSize size)
{
	return CGRectMake(center.x - (size.width/2), center.y - (size.height/2), size.width, size.height);
}

CG_INLINE CGSize CGSizeSwap(CGSize rect)
{
	return CGSizeMake(rect.height, rect.width);
}



CG_INLINE NSString* NSStringFromCATransform3D(CATransform3D t)
{
	return [NSString stringWithFormat: @"%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f",
			t.m11, t.m12, t.m13, t.m14,
			t.m21, t.m22, t.m23, t.m24,
			t.m31, t.m32, t.m33, t.m34,
			t.m41, t.m42, t.m43, t.m44];
	
}
