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

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define ASSIGN_NOT_NIL(property, val) ({id __val = (val); if (__val != [NSNull null] && __val != nil) { property = val;}})
#define _A_CELL_HEIGHT 50

extern NSString * const kLongDateFormat;
extern NSString * const kTestFlightSDKKey;
extern NSString * const kDateFormat;
extern NSString * const kRegexForEmail;
extern NSString * const kModelSavedDataFileName;

extern CGFloat const kSecondsPerDay;
extern CGFloat const kSecondsPerHour;
extern CGFloat const kPaddingRightOnImportWaitingAnimation;

extern NSString * const kTwitterTimelineBaseURL;
extern NSString * const kIncludeEntities;
extern NSString * const kIncludeReTweets;
extern NSString * const kTweetCount;
extern NSString * const kTwitterScreenName;
extern NSString * const kTwitterUser;
extern NSString * const kTwitterName;
extern NSString * const kTweetText;

@end
