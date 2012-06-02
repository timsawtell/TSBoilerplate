//
//  Appearances.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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
