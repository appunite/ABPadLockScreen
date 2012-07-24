//
//  ABPadLockScreen.m
//
//  Version 1.2
//
//  Created by Aron Bury on 09/09/2011.
//  Copyright 2011 Aron Bury. All rights reserved.
//
//  Get the latest version of ABLockScreen from this location:
//  https://github.com/abury/ABPadLockScreen
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//
#import "ABPadLockScreen.h"

#import <AUKit/AUKit.h>
#import <AUKit/DeviceInfo.h>

@interface ABPadLockScreen()

- (void)digitButtonPressed:(id)sender;
- (void)backSpaceButtonTapped:(id)sender;
- (void)digitInputted:(int)digit;
- (void)checkPin;
- (void)lockPad;
- (void)xButtonPressed;
- (UIButton *)getStyledButtonForNumber:(int)number;
@end

@implementation ABPadLockScreen
@synthesize delegate;

- (id)initWithDelegate:(id<ABPadLockScreenDelegate>)aDelegate
{
    self = [super init];
    if (self) 
    {
        [self setDelegate:aDelegate];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self.view setFrame:CGRectMake(0.0f, [[UIApplication sharedApplication].delegate window].bounds.size.height, 330.0f, 270.0f)];//size of unlock pad

    if (!IS_IPAD()) {
        [UIView animateWithDuration:0.27 animations:^{
            [self.view setFrame:CGRectMake(0.0f, [[UIApplication sharedApplication].delegate window].bounds.size.height - 213.0f, 330.0f, 270.0f)];//size of unlock pad
        }];
    }
    
        
    [self.view setBackgroundColor:HTML(0x404040)];
    
    //Add buttons
    float buttonTop = 1.0f;
    float buttonHeight = 53.0f;
    float leftButtonWidth = 105.0f;
    float middleButtonWidth = 108.0f;
    float rightButtonWidth = 105.0f;
    
    UIButton *oneButton = [self getStyledButtonForNumber:1];
    if (!IS_IPAD()) {
        [oneButton setFrame:CGRectMake(0.0f, buttonTop, leftButtonWidth, buttonHeight)];
    } else {
        [oneButton setFrame:CGRectMake(219.0f, buttonTop, leftButtonWidth, buttonHeight)];        
    }
    [self.view addSubview:oneButton];
    
    UIButton *twoButton = [self getStyledButtonForNumber:2];
    [twoButton setFrame:CGRectMake(CGRectGetMaxX(oneButton.frame) + 1.0, 
                                   oneButton.frame.origin.y, 
                                   middleButtonWidth, 
                                   buttonHeight)];
    [self.view addSubview:twoButton];
    
    UIButton *threeButton = [self getStyledButtonForNumber:3];
    [threeButton setFrame:CGRectMake(CGRectGetMaxX(twoButton.frame) + 1.0, 
                                     twoButton.frame.origin.y, 
                                     rightButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:threeButton];
    
    UIButton *fourButton = [self getStyledButtonForNumber:4];
    [fourButton setFrame:CGRectMake(CGRectGetMinX(oneButton.frame), 
                                    CGRectGetMaxY(oneButton.frame) + 1, 
                                    leftButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:fourButton];
    
    UIButton *fiveButton = [self getStyledButtonForNumber:5];
    [fiveButton setFrame:CGRectMake(CGRectGetMaxX(fourButton.frame) + 1, 
                                    CGRectGetMinY(fourButton.frame), 
                                    middleButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:fiveButton];
    
    UIButton *sixButton = [self getStyledButtonForNumber:6];
    [sixButton setFrame:CGRectMake(CGRectGetMaxX(fiveButton.frame) + 1, 
                                   CGRectGetMinY(fiveButton.frame), 
                                   rightButtonWidth, 
                                   buttonHeight)];
    [self.view addSubview:sixButton];
    
    UIButton *sevenButton = [self getStyledButtonForNumber:7];
    [sevenButton setFrame:CGRectMake(CGRectGetMinX(fourButton.frame), 
                                     CGRectGetMaxY(fourButton.frame) + 1, 
                                     leftButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:sevenButton];
    
    UIButton *eightButton = [self getStyledButtonForNumber:8];
    [eightButton setFrame:CGRectMake(CGRectGetMaxX(sevenButton.frame) + 1, 
                                     CGRectGetMinY(sevenButton.frame), 
                                     middleButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:eightButton];
    
    UIButton *nineButton = [self getStyledButtonForNumber:9];
    [nineButton setFrame:CGRectMake(CGRectGetMaxX(eightButton.frame) + 1.0, 
                                    CGRectGetMinY(eightButton.frame), 
                                    rightButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:nineButton];
    
    UIButton *sign978Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [sign978Button setBackgroundImage:[UIImage imageNamed:@"978"] forState:UIControlStateNormal];
    [sign978Button setBackgroundImage:[UIImage imageNamed:@"978p"] forState:UIControlStateHighlighted];
    [sign978Button setFrame:CGRectMake(CGRectGetMinX(sevenButton.frame), 
                                     CGRectGetMaxY(sevenButton.frame) + 1.0, 
                                     leftButtonWidth, 
                                     buttonHeight)];
    
    [sign978Button addTarget:self action:@selector(sign978Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sign978Button];
    
    UIButton *zeroButton = [self getStyledButtonForNumber:0];
    [zeroButton setFrame:CGRectMake(CGRectGetMaxX(sign978Button.frame) + 1.0, 
                                    CGRectGetMinY(sign978Button.frame), 
                                    middleButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:zeroButton];
    
    
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setBackgroundImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [xButton setBackgroundImage:[UIImage imageNamed:@"xp"] forState:UIControlStateHighlighted];
    [xButton setFrame:CGRectMake(CGRectGetMaxX(zeroButton.frame) + 1, 
                                       CGRectGetMinY(zeroButton.frame), 
                                       rightButtonWidth, 
                                       buttonHeight)];
    
    [xButton addTarget:self action:@selector(xButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xButton];    
    
    
    UIButton *blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blankButton setBackgroundImage:[UIImage imageNamed:@"blank_button"] forState:UIControlStateNormal];
    [blankButton setBackgroundImage:[UIImage imageNamed:@"blank_button_selected"] forState:UIControlStateHighlighted];
    [blankButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
    [blankButton setTitle:NSLocalizedString(@"Search", nil) forState:UIControlStateNormal];
    [blankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [blankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [blankButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 3.0, 0.0)];
    [blankButton setFrame:CGRectMake(CGRectGetMinX(sign978Button.frame), CGRectGetMaxY(sign978Button.frame) + 1, leftButtonWidth, buttonHeight)];
    [self.view addSubview:blankButton];

    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear_button"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear_button_selected"] forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(backSpaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setFrame:CGRectMake(CGRectGetMaxX(blankButton.frame) + 1,
                                     CGRectGetMinY(blankButton.frame),
                                     middleButtonWidth + rightButtonWidth,
                                     buttonHeight)];
    [self.view addSubview:clearButton];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

- (void)backSpaceButtonTapped:(id)sender {
    if ([delegate respondsToSelector:@selector(backspaceInputed)]) {
        [delegate backspaceInputed];
    }
}

- (void)digitButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [self digitInputted:button.tag];
}

- (void)xButtonPressed:(id)sender {
    if ([delegate respondsToSelector:@selector(xSignInputed)]) {
        [delegate xSignInputed];
    }
}

- (void)sign978Pressed:(id)sender {
    if ([delegate respondsToSelector:@selector(sign978Inputed)]) {
        [delegate sign978Inputed];
    }
}

- (void)digitInputted:(int)digit {
    if ([delegate respondsToSelector:@selector(digitInputed:)]) {
        [delegate digitInputed:digit];
    }
}

- (void)lockPad
{
    UIView *lockView = [[UIView alloc] initWithFrame:CGRectMake(-5.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [lockView setBackgroundColor:[UIColor blackColor]];
    [lockView setAlpha:0.5];
    [self.view addSubview:lockView];
}

#pragma mark - private methods
- (UIButton *)getStyledButtonForNumber:(int)number
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName = [NSString stringWithFormat:@"%i", number];
    NSString *altImageName = [NSString stringWithFormat:@"%@p", imageName];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:altImageName] forState:UIControlStateHighlighted];
    [button setTag:number];
    [button addTarget:self action:@selector(digitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}
@end
