//
//  AlertView.h
//  BrisbaneAirport
//
//  Created by Local Dev User on 17/10/12.
//  Copyright (c) 2012 Speedwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (nonatomic, weak) IBOutlet UIView *containerView; /** the reason there is a container view is so that we dont try and modify [self view] in the layoutSubviews method */
@property (nonatomic, weak) IBOutlet UIImageView *titleBackgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonsView; /** a view that will add buttons as subviews depending on how many params the user passed in */
@property (weak, nonatomic) IBOutlet UIView *buttonsBackgroundView;

@end
