/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.
 */

#import "Appearances.h"
#import "UIColor+Extensions.h"

@implementation Appearances

+ (void)globalAppearances
{
    NSMutableDictionary *navBarTitleAttributes = [NSMutableDictionary dictionary];
    [navBarTitleAttributes setValue:[Appearances titleBarFont] forKey:UITextAttributeFont];
    [navBarTitleAttributes setValue:[UIColor blackColor] forKey:UITextAttributeTextColor];
    [navBarTitleAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_navigation_bar_button"]];
    [[UIBarButtonItem appearance] setTintColor:color];
    
}

+ (UIColor *)navButtonColor 
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_navigation_bar_button"]];
}

+ (UIImage *)backgroundImage
{
    return [[UIImage imageNamed:@"bgBoxSquare"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
}

+ (UIFont *)titleBarFont 
{
    return [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17.0f];
}


@end
