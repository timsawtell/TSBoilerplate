/*
 Copyright (c) 2013 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "AlertView.h"

static const CGFloat kSpaceFromTitleToContent   = 15.0f;
static const CGFloat kSpaceFromContentToBottom  = 15.0f;
static const CGFloat kSpaceFromEdgeToButtons    = 5.0f;
static const CGFloat kHeightOfButtons           = 35.0f;

@interface AlertView()

- (CGSize)desiredTitleSize;
- (CGSize)desiredContentSize;

@end

@implementation AlertView

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat runningY = 0.0f;
    // The title label
    CGSize desiredTitleSize = [self desiredTitleSize];
    CGSize desiredContentSize = [self desiredContentSize];
    
    if (desiredTitleSize.height > 46) {
        self.titleLabel.frame = CGRectSetHeight(self.titleLabel.frame, desiredTitleSize.height);
        self.titleBackgroundImageView.frame = CGRectSetHeight(self.titleBackgroundImageView.frame, desiredTitleSize.height + kSpaceFromTitleToContent);
    }
    self.contentLabel.frame = CGRectSetHeight(self.contentLabel.frame, desiredContentSize.height);
    
    runningY = self.titleBackgroundImageView.frame.origin.y + self.titleBackgroundImageView.frame.size.height + 5;
    self.contentLabel.frame = CGRectSetY(self.contentLabel.frame, self.titleBackgroundImageView.frame.origin.y + self.titleBackgroundImageView.frame.size.height + 5);
    runningY += desiredContentSize.height + 5;
    
    self.buttonsView.frame = CGRectSetY(self.buttonsView.frame, runningY);
    // loop through the subviews of self.buttonsView (i.e the buttons). Rule is to expand the alertview so that it can show all the buttons horizontally.
    CGFloat totalWidth = 0.0f;
    NSMutableArray *buttons = [NSMutableArray array];
    for (UIView *view in self.buttonsView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            totalWidth += [self desiredWidthOfButton:btn];
            [buttons addObject:btn];
        } else {
            continue;
        }
    }
    
    runningY += self.buttonsView.frame.size.height + kSpaceFromContentToBottom;
    // add the buttons up next to each other
    CGFloat runningX = 0;
    for (UIButton *btn in buttons) {
        CGFloat desiredWidth = [self desiredWidthOfButton:btn];
        // put all the buttons in the view, centered in buttonsView
        btn.frame = CGRectMake(runningX, (self.buttonsView.frame.size.height - kHeightOfButtons) / 2, desiredWidth, kHeightOfButtons);
        runningX += desiredWidth + kSpaceFromEdgeToButtons;
    }
    runningX -= kSpaceFromEdgeToButtons; // get ride of that last padding
    runningX += kSpaceFromEdgeToButtons * 2; // put some padding on either size
    
    self.containerView.frame = CGRectSetHeight(self.containerView.frame, runningY);
    if (runningX > self.containerView.frame.size.width) {
        self.containerView.frame = CGRectSetWidth(self.containerView.frame, runningX);
    }
    
    runningX -= kSpaceFromEdgeToButtons * 2; // remove that padding so we can center the buttons in the parent
    self.buttonsView.frame = CGRectSetWidth(self.buttonsView.frame, runningX);
    CGFloat xOffset = (self.containerView.frame.size.width - self.buttonsView.frame.size.width) / 2;
    self.buttonsView.frame = CGRectSetX(self.buttonsView.frame, xOffset);
    self.buttonsBackgroundView.frame = CGRectSetY(self.buttonsBackgroundView.frame, self.buttonsView.frame.origin.y);
    self.containerView.frame = CGRectSetHeight(self.containerView.frame, self.buttonsBackgroundView.frame.origin.y + self.buttonsBackgroundView.frame.size.height + 2);
    // Note: If containerView is smaller than self frame, then [self frame] it will still be there, sticking out under teh content label, however it's clear so you can't see it.
}

- (CGFloat)desiredWidthOfButton:(UIButton *)button
{
    CGSize size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    
    return MAX(size.width + 10, 100.0f);
}

- (CGSize)desiredTitleSize
{
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    return size;
}

- (CGSize)desiredContentSize
{
    CGSize size = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName: self.contentLabel.font}];
    return size;
}

@end
