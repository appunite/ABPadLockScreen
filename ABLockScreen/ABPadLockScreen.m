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
    [self.view setFrame:CGRectMake(0.0f, [[UIApplication sharedApplication].delegate window].bounds.size.height, 330.0f, 220.0f)];//size of unlock pad
    
    [UIView animateWithDuration:0.27 animations:^{
        [self.view setFrame:CGRectMake(0.0f, [[UIApplication sharedApplication].delegate window].bounds.size.height - 213.0f, 330.0f, 220.0f)];//size of unlock pad
    }];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //Add buttons
    float buttonTop = 4.0f;
    float buttonHeight = 55.0f;
    float leftButtonWidth = 106.0f;
    float middleButtonWidth = 109.0f;
    float rightButtonWidth = 105.0f;
    
    UIButton *oneButton = [self getStyledButtonForNumber:1];
    [oneButton setFrame:CGRectMake(0.0f, buttonTop, leftButtonWidth, buttonHeight)];
    [self.view addSubview:oneButton];
    
    UIButton *twoButton = [self getStyledButtonForNumber:2];
    [twoButton setFrame:CGRectMake(oneButton.frame.origin.x + oneButton.frame.size.width, 
                                   oneButton.frame.origin.y, 
                                   middleButtonWidth, 
                                   buttonHeight)];
    [self.view addSubview:twoButton];
    
    UIButton *threeButton = [self getStyledButtonForNumber:3];
    [threeButton setFrame:CGRectMake(twoButton.frame.origin.x + twoButton.frame.size.width, 
                                     twoButton.frame.origin.y, 
                                     rightButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:threeButton];
    
    UIButton *fourButton = [self getStyledButtonForNumber:4];
    [fourButton setFrame:CGRectMake(oneButton.frame.origin.x, 
                                    oneButton.frame.origin.y + oneButton.frame.size.height - 1, 
                                    leftButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:fourButton];
    
    UIButton *fiveButton = [self getStyledButtonForNumber:5];
    [fiveButton setFrame:CGRectMake(twoButton.frame.origin.x, 
                                    fourButton.frame.origin.y, 
                                    middleButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:fiveButton];
    
    UIButton *sixButton = [self getStyledButtonForNumber:6];
    [sixButton setFrame:CGRectMake(threeButton.frame.origin.x, 
                                   fiveButton.frame.origin.y, 
                                   rightButtonWidth, 
                                   buttonHeight)];
    [self.view addSubview:sixButton];
    
    UIButton *sevenButton = [self getStyledButtonForNumber:7];
    [sevenButton setFrame:CGRectMake(oneButton.frame.origin.x, 
                                     fourButton.frame.origin.y + fourButton.frame.size.height - 1, 
                                     leftButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:sevenButton];
    
    UIButton *eightButton = [self getStyledButtonForNumber:8];
    [eightButton setFrame:CGRectMake(twoButton.frame.origin.x, 
                                     sevenButton.frame.origin.y, 
                                     middleButtonWidth, 
                                     buttonHeight)];
    [self.view addSubview:eightButton];
    
    UIButton *nineButton = [self getStyledButtonForNumber:9];
    [nineButton setFrame:CGRectMake(threeButton.frame.origin.x, 
                                    sevenButton.frame.origin.y, 
                                    rightButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:nineButton];
    
    UIButton *blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blankButton setBackgroundImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
    [blankButton setBackgroundImage:[UIImage imageNamed:@"blank-selected"] forState:UIControlStateHighlighted];
    [blankButton setFrame:CGRectMake(sevenButton.frame.origin.x, 
                                     sevenButton.frame.origin.y + sevenButton.frame.size.height - 1, 
                                     leftButtonWidth, 
                                     buttonHeight)];
    
    [blankButton addTarget:self action:@selector(xButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blankButton];
    
    UIButton *zeroButton = [self getStyledButtonForNumber:0];
    [zeroButton setFrame:CGRectMake(twoButton.frame.origin.x, 
                                    blankButton.frame.origin.y, 
                                    middleButtonWidth, 
                                    buttonHeight)];
    [self.view addSubview:zeroButton];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear-selected"] forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(backSpaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setFrame:CGRectMake(threeButton.frame.origin.x,
                                     zeroButton.frame.origin.y,
                                     rightButtonWidth,
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
	return YES;
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
    NSString *altImageName = [NSString stringWithFormat:@"%@-selected", imageName];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:altImageName] forState:UIControlStateHighlighted];
    [button setTag:number];
    [button addTarget:self action:@selector(digitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}
@end
