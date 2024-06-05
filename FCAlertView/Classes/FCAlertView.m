//
//  FCAlertView.m
//  ShiftRide
//
//  Created by Nima Tahami on 2016-07-10.
//  Copyright © 2016 Nima Tahami. All rights reserved.
//

#import "FCAlertView.h"

@implementation FCAlertView

- (id)init
{
    self = [super init];
    if (self) {
        
        // INITIALIZATIONS - Setting Up Basic UI Adjustments
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        self.frame = CGRectMake(0,
                                0,
                                result.width,
                                result.height);
        
        self.backgroundColor = [UIColor clearColor];
        
        // ALERTVIEW BACKGROUND - Setting up Background View
        
        self.alertBackground = [[UIView alloc] init];
        self.alertBackground.frame = CGRectMake(0,
                                            0,
                                            result.width,
                                            result.height);
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.35];
        
        [self addSubview:self.alertBackground];
        
        // PRESET FLAT COLORS - Setting up RGB of Flat Colors - Put in another file? REMOVE
        
        self.flatTurquoise = [UIColor colorWithRed:26.0/255.0f green:188.0/255.0f blue:156.0/255.0f alpha:1.0];
        self.flatGreen = [UIColor colorWithRed:39.0/255.0f green:174.0/255.0f blue:96.0/255.0f alpha:1.0];
        self.flatBlue = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0];
        self.flatMidnight = [UIColor colorWithRed:44.0/255.0f green:62.0/255.0f blue:80.0/255.0f alpha:1.0];
        self.flatPurple = [UIColor colorWithRed:142.0/255.0f green:68.0/255.0f blue:173.0/255.0f alpha:1.0];
        self.flatOrange = [UIColor colorWithRed:243.0/255.0f green:156.0/255.0f blue:18.0/255.0f alpha:1.0];
        self.flatRed = [UIColor colorWithRed:192.0/255.0f green:57.0/255.0f blue:43.0/255.0f alpha:1.0];
        self.flatSilver = [UIColor colorWithRed:189.0/255.0f green:195.0/255.0f blue:199.0/255.0f alpha:1.0];
        self.flatGray = [UIColor colorWithRed:127.0/255.0f green:140.0/255.0f blue:141.0/255.0f alpha:1.0];
        
        // CUSTOMIZATIONS - Setting Default Customization Settings & Checks
        
        self->alertButtons = [[NSMutableArray alloc] init];
        self->alertTextFields = [[NSMutableArray alloc] init];
        self->alertTextFieldHolder = [[NSMutableArray alloc] init];
        self->alertCustomFields = [[NSMutableArray alloc] init];
        self->alertCustomFieldHolder = [[NSMutableArray alloc] init];
        
        self.numberOfButtons = 0;
        self.autoHideSeconds = 0;
        self.cornerRadius = 18.0f;
        
        self.dismissOnOutsideTouch = NO;
        self.hideAllButtons = NO;
        self.hideDoneButton = NO;
        self.avoidCustomImageTint = NO;
        self.blurBackground = NO;
        self.bounceAnimations = NO;
        self.darkTheme = NO;
        self.detachButtons = NO;
        self.fullCircleCustomImage = NO;
        self.hideSeparatorLineView = NO;
        self.customImageScale = 1;
        self.titleFont = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        self.subtitleFont = nil;
        self->defaultSpacing = [self configureAVWidth];
        self->defaultHeight = [self configureAVHeight];
        
    }
    
    return self;
    
}

#pragma mark - Frame Configuration

- (CGFloat) configureAVWidth {
    
    if (self.customSpacing == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            if(result.height == 1366)
                return 105.0f + 600.0f;
            else
                return 105.0f + 350.0f;
        }
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // iPhone Classic
                return 55.0f;
                
            }
            if(result.height == 568)
            {
                // iPhone 5
                return 65.0f;
                
            }
            if (result.height == 736)
            {
                // iPhone 6/7 Plus
                return 130.0f;
            }
            else
            {
                return 105.0f;
            }
            
        }
    }
    
    return self.customSpacing;
    
}

- (CGFloat) configureAVHeight {
    
    if (self.customHeight == 0) {
        return 200.0f;
    } else {
        return self.customHeight;
    }
}

#pragma mark - FCAlertView Checks
#pragma mark - Customization Data Checkpoint

- (void) checkCustomizationValid {
    
    if (self.darkTheme) {
        if (self.titleColor == nil) {
            self.titleColor = [UIColor whiteColor];
        }
        if (self.subTitleColor == nil) {
            self.subTitleColor = [UIColor whiteColor];
        }
    }
    
    if (![self hasSubTitle])
        if (![self hasTitle])
            NSLog(@"FCAlertView Warning: Your Alert should have a title and/or subtitle.");
    
    if (self->doneTitle == nil || [self->doneTitle isEqualToString:@""]) {
        self->doneTitle = @"OK";
    }
    
    if (self.cornerRadius == 0.0f)
        self.cornerRadius = 18.0f;
    
    if (self->vectorImage != nil)
        self->alertViewWithVector = 1;
    
}

#pragma mark - Safety Close Check

- (void) safetyCloseCheck {
    
    if (self.hideDoneButton || self.hideAllButtons) {
        
        if (self.autoHideSeconds == 0 && !self.overrideForcedDismiss) {
            
            self.dismissOnOutsideTouch = YES;
            
            NSLog(@"Forced Dismiss on Outside Touch");
            
        }
        
    }
    
}

#pragma mark - Title Validation
-(BOOL)hasTitle {
    return (self.title != nil && self.title.length > 0) ||
    (self.attributedTitle != nil && self.attributedTitle.length > 0);
}

-(BOOL)hasSubTitle {
    return (self.subTitle != nil && self.subTitle.length > 0) ||
    (self.attributedSubTitle != nil && self.attributedSubTitle.length > 0);
}

#pragma mark - Touch Events

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self->alertTypeRatingStars || self->alertTypeRatingHearts) {
        UITouch *touch = [touches anyObject];
        
        if([self->item1 pointInside:[touch locationInView:self->item1] withEvent:nil])
            [self rate1Triggered];
        
        
        if([self->item2 pointInside:[touch locationInView:self->item2] withEvent:nil])
            [self rate2Triggered];
        
        
        if([self->item3 pointInside:[touch locationInView:self->item3] withEvent:nil])
            [self rate3Triggered];
        
        
        if([self->item4 pointInside:[touch locationInView:self->item4] withEvent:nil])
            [self rate4Triggered];
        
        if([self->item5 pointInside:[touch locationInView:self->item5] withEvent:nil])
            [self rate5Triggered];
        
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self->alertTypeRatingStars || self->alertTypeRatingHearts) {
        UITouch *touch = [touches anyObject];
        
        if([self->item1 pointInside:[touch locationInView:self->item1] withEvent:nil]){
            [self rate1Triggered];
        }
        if([self->item2 pointInside:[touch locationInView:self->item2] withEvent:nil]){
            [self rate2Triggered];
        }
        if([self->item3 pointInside:[touch locationInView:self->item3] withEvent:nil]){
            [self rate3Triggered];
        }
        if([self->item4 pointInside:[touch locationInView:self->item4] withEvent:nil]){
            [self rate4Triggered];
        }
        if([self->item5 pointInside:[touch locationInView:self->item5] withEvent:nil]){
            [self rate5Triggered];
        }
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.alertBackground];
    CGPoint touchPoint2 = [touch locationInView:self->alertViewContents];
    
    BOOL isPointInsideBackview = [self.alertBackground pointInside:touchPoint withEvent:nil];
    BOOL isPointInsideAlertView = [self->alertViewContents pointInside:touchPoint2 withEvent:nil];
    
    if (self.dismissOnOutsideTouch && isPointInsideBackview && !isPointInsideAlertView)
        [self dismissAlertView];
    
    if (self->alertTextFields.count > 0 && isPointInsideBackview && !isPointInsideAlertView)
        [self endEditing:YES];
    
}

#pragma mark - Drawing AlertView

- (void)drawRect:(CGRect)rect {
    
    self->defaultSpacing = [self configureAVWidth];
    self->defaultHeight = [self configureAVHeight];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    self.alpha = 0;
    
    // Adjusting AlertView Frames
    
    if (self->alertViewWithVector) // Frames for when AlertView contains an image
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - (200.0f/2),
                                    result.width - self->defaultSpacing,
                                    self->defaultHeight);
    else
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - (170.0f/2),
                                    result.width - self->defaultSpacing,
                                    self->defaultHeight - 30);
    
    if (![self hasTitle]) // Frames for when AlertView doesn't contain a title
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50)/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height - 10);
    
    if (self.hideAllButtons) { // Frames for when AlertView has hidden all buttons
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50)/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height - 45);
        
    } else {
        if (self.hideDoneButton && self.numberOfButtons == 0) { // Frames for when AlertView has hidden the DONE/DISMISS button
            self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                        self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50)/2),
                                        result.width - self->defaultSpacing,
                                        self->alertViewFrame.size.height - 45);
        }
        if (!self.hideDoneButton && self.numberOfButtons >= 2) // Frames for AlertView with 2 added buttons (vertical buttons)
            self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                        self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50 + 140)/2),
                                        result.width - self->defaultSpacing,
                                        self->alertViewFrame.size.height - 50 + 140);
    }
    
    if (self->alertTextFields.count > 0)
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height + 45*(MIN(self->alertTextFields.count,4)))/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height + 45*(MIN(self->alertTextFields.count,4)));
    else
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50 + 140)/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height);
    
    if (self->alertCustomFields.count > 0)
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height + 45*(MIN(self->alertCustomFields.count,4)))/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height + 45*(MIN(self->alertCustomFields.count,4)));
    else
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50 + 140)/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height);
    
    if (self->alertTypeRatingStars || self->alertTypeRatingHearts)
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - ((result.width - self->defaultSpacing)/2),
                                    self.frame.size.height/2 - ((self->alertViewFrame.size.height - 50 + 140)/2),
                                    result.width - self->defaultSpacing,
                                    self->alertViewFrame.size.height + 50);
    
    // Landscape Orientation Width Fix
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        self->alertViewFrame = CGRectMake(self.frame.size.width/2 - (300/2),
                                    self.frame.size.height/2 - (self->alertViewFrame.size.height/2),
                                    300,
                                    self->alertViewFrame.size.height);
    }
    
    // Description Label
    
    NSInteger descriptionLevel = 45.0f;
    
    if (![self hasTitle]) {
        
        descriptionLevel = 15.0f;
        self->alertViewFrame = CGRectMake(self->alertViewFrame.origin.x,
                                    self->alertViewFrame.origin.y,
                                    self->alertViewFrame.size.width,
                                    self->alertViewFrame.size.height - 20);
    }
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f,
                                                                          descriptionLevel + (self->alertViewWithVector * 30),
                                                                          self->alertViewFrame.size.width - 50.0f,
                                                                          60.0f)];
    if (self.subtitleFont != nil)
        descriptionLabel.font = self.subtitleFont;
    else if (self.title != nil)
        descriptionLabel.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightLight];
    else
        descriptionLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular];
    
    descriptionLabel.textColor = self.subTitleColor;
    if (self.subTitle == nil)
        descriptionLabel.attributedText = self.attributedSubTitle;
    else
        descriptionLabel.text = self.subTitle;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.adjustsFontSizeToFitWidth = NO;
    
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // HEADER VIEW - With Title & Subtitle
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f,
                                                                    20.0f + (self->alertViewWithVector * 30),
                                                                    self->alertViewFrame.size.width - 30.0f,
                                                                    30.0f)];
    
    titleLabel.font = self.titleFont;
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = self.titleColor;
    if (self.title == nil)
        titleLabel.attributedText = self.attributedTitle;
    else
        titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Re-adjusting Frames based on height of title - Requirement is to not have over 2 lines of title

    CGSize size = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}];
    if (size.width > titleLabel.bounds.size.width) {
        titleLabel.numberOfLines = 2;
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, 60.0f);
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x,
                                            descriptionLabel.frame.origin.y + 30.0f,
                                            descriptionLabel.frame.size.width,
                                            descriptionLabel.frame.size.height);
        
        self->alertViewFrame = CGRectMake(self->alertViewFrame.origin.x,
                                    self->alertViewFrame.origin.y,
                                    self->alertViewFrame.size.width,
                                    self->alertViewFrame.size.height + 30.0f);
    }
    
    // Re-adjusting Frames based on height of subTitle - Requirement is to not have over 6 lines of subTitle
    
    CGSize constraint = CGSizeMake(descriptionLabel.frame.size.width, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [descriptionLabel.text boundingRectWithSize:constraint
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:descriptionLabel.font}
                                                             context:context].size;
    
    CGFloat heightDiff = descriptionLabel.frame.size.height - boundingBox.height;
    
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x,
                                        descriptionLabel.frame.origin.y + 7.5,
                                        descriptionLabel.frame.size.width,
                                        boundingBox.height);
    
    self->alertViewFrame = CGRectMake(self->alertViewFrame.origin.x,
                                self->alertViewFrame.origin.y + ((heightDiff + 15)/2),
                                self->alertViewFrame.size.width,
                                self->alertViewFrame.size.height - heightDiff + 15);
    
    self->descriptionLabelFrames = descriptionLabel.frame;
    
    // Setting Up Contents of AlertView
    
    self->alertViewContents = [[UIView alloc] initWithFrame:self->alertViewFrame];
    [self addSubview:self->alertViewContents];
    
    alertView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height)];
    
    // Setting Background Color of AlertView
    
    if (self->alertViewWithVector) {
        alertView.backgroundColor = [UIColor clearColor];
    } else {
        if (!self.alertBackgroundColor)
            alertView.backgroundColor = [UIColor whiteColor];
        else
            alertView.backgroundColor = self.alertBackgroundColor;
        if (self.darkTheme)
            alertView.backgroundColor = [UIColor colorWithWhite:48.0f/255.0f alpha:1.0];
    }
    
    [self->alertViewContents addSubview:alertView];
    
    // CREATING ALERTVIEW
    // CUSTOM SHAPING - Displaying Cut out circle for Vector Type Alerts
    
    int radius = alertView.frame.size.width;
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                                0,
                                                                                self.frame.size.width,
                                                                                alertView.bounds.size.height)
                                                        cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self->alertViewFrame.size.width/2 - 33.75f,
                                                                                  -33.75f,
                                                                                  67.5f,
                                                                                  67.5f)
                                                          cornerRadius:radius];
    [rectPath appendPath:circlePath];
    [rectPath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = rectPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    if (!self.alertBackgroundColor)
        fillLayer.fillColor = [UIColor whiteColor].CGColor;
    else
        fillLayer.fillColor = self.alertBackgroundColor.CGColor;
    if (self.darkTheme)
        fillLayer.fillColor = [UIColor colorWithWhite:48.0f/255.0f alpha:1.0].CGColor;
    fillLayer.opacity = 1.0;
    
    if (self->alertViewWithVector)
        [alertView.layer addSublayer:fillLayer];
    
    // SEPARATOR LINE - Seperating Header View with Button View
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         self->alertViewFrame.size.height - 47,
                                                                         self->alertViewFrame.size.width,
                                                                         2)];
    
    separatorLineView.backgroundColor = [UIColor colorWithWhite:100.0f/255.0f alpha:1.0]; // set color as you want.
    if (self.darkTheme)
        separatorLineView.backgroundColor = [UIColor colorWithWhite:58.0f/255.0f alpha:1.0];
    
    // TEXTFIELD VIEW - Section with TextField
    
    if (self->alertTextFields.count > 0) {
        
        for (int i = 0; i < MIN(self->alertTextFields.count,4); i++) {
            
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(12.5, descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y + 10.5 + 45*i, self->alertViewFrame.size.width - 25, 40)];
            
            if ([[self->alertTextFields objectAtIndex:i] objectForKey:@"field"] != nil &&
                [[[self->alertTextFields objectAtIndex:i] objectForKey:@"field"] isKindOfClass:[UITextField class]]) {
                
                tf = [[self->alertTextFields objectAtIndex:i] objectForKey:@"field"];
                tf.frame = CGRectMake(12.5, descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y + 10.5 + 45*i, self->alertViewFrame.size.width - 25, 40);
                
            }
            
            if (tf.layer.cornerRadius == 0)
                tf.layer.cornerRadius = 3.0f;
            tf.layer.masksToBounds = YES;
            tf.layer.borderColor = [[UIColor colorWithWhite:217.0f/255.0f alpha:1.0] CGColor];
            
            if (tf.layer.borderWidth == 0)
                tf.layer.borderWidth = 1.0f;
            
            tf.delegate = self;
            tf.tag = i;
            if (tf.placeholder.length == 0 &&
                [[self->alertTextFields objectAtIndex:i] objectForKey:@"placeholder"] != nil &&
                [[[self->alertTextFields objectAtIndex:i] objectForKey:@"placeholder"] length] > 0)
                tf.placeholder = [[self->alertTextFields objectAtIndex:i] objectForKey:@"placeholder"];
            
            if (self.darkTheme)
                tf.backgroundColor = [UIColor colorWithWhite:227.0f/255.0f alpha:1.0];
            else
                tf.backgroundColor = [UIColor whiteColor];
            
            if (i+1 == MIN(self->alertTextFields.count,4))
                [tf setReturnKeyType:UIReturnKeyDone];
            else
                [tf setReturnKeyType:UIReturnKeyNext];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            tf.leftView = paddingView;
            tf.leftViewMode = UITextFieldViewModeAlways;
            
            [self->alertTextFieldHolder addObject:tf];
            
            [alertView addSubview:tf];
            
        }
        
    }
    
    if (self->alertCustomFields.count > 0) {
        for (int i = 0; i < MIN(self->alertCustomFields.count,4); i++) {
            UIView *tf = [self->alertCustomFields objectAtIndex:i][@"field"];
            tf.frame = CGRectMake(12.5, descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y + 10.5 + 45*(i + MIN(self->alertCustomFields.count,4)), self->alertViewFrame.size.width - 25, 40);
        
            if (tf.layer.cornerRadius == 0)
                tf.layer.cornerRadius = 3.0f;
            tf.layer.masksToBounds = YES;
            tf.layer.borderColor = [[UIColor colorWithWhite:217.0f/255.0f alpha:1.0] CGColor];
            
            if (tf.layer.borderWidth == 0)
                tf.layer.borderWidth = 1.0f;
            
            tf.tag = i;
            
            if (self.darkTheme)
                tf.backgroundColor = [UIColor colorWithWhite:227.0f/255.0f alpha:1.0];
            else
                tf.backgroundColor = [UIColor whiteColor];
            
            [self->alertCustomFieldHolder addObject:tf];
            
            [alertView addSubview:tf];
        }
    }
    
    // BUTTON(S) VIEW - Section containing all Buttons
    
    if (self.numberOfButtons == 0) { // View only contains DONE/DISMISS Button
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (self.colorScheme == nil) {
            doneButton.backgroundColor = [UIColor whiteColor];
            if (self.detachButtons)
                doneButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
            if (self.darkTheme)
                doneButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        } else {
            doneButton.backgroundColor = self.colorScheme;
        }
        
        if (self.doneButtonHighlightedBackgroundColor)
            [doneButton setBackgroundImage:[self imageWithColor:self.doneButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        doneButton.frame = CGRectMake(0,
                                      self->alertViewFrame.size.height - 45,
                                      self->alertViewFrame.size.width,
                                      45);
        if (self.detachButtons) {
            doneButton.frame = CGRectMake(8,
                                          self->alertViewFrame.size.height - 50,
                                          self->alertViewFrame.size.width - 16,
                                          40);
            doneButton.layer.cornerRadius = MIN(self.cornerRadius, doneButton.frame.size.height/2);
            doneButton.layer.masksToBounds = YES;
        }
        
        [doneButton setTitle:self->doneTitle forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [doneButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        if (self.doneButtonCustomFont)
            doneButton.titleLabel.font = self.doneButtonCustomFont;
        if (self.colorScheme != nil || self.darkTheme)
            doneButton.tintColor = [UIColor whiteColor];
        if (self.doneButtonTitleColor != nil)
            doneButton.tintColor = self.doneButtonTitleColor;
        
        if (!self.hideAllButtons && !self.hideDoneButton)
            [alertView addSubview:doneButton];
        
    } else if (self.numberOfButtons == 1) { // View also contains OTHER (One) Button
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (self.colorScheme == nil) {
            doneButton.backgroundColor = [UIColor whiteColor];
            if (self.detachButtons)
                doneButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
            if (self.darkTheme)
                doneButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        } else {
            doneButton.backgroundColor = self.colorScheme;
        }
        
        if (self.doneButtonHighlightedBackgroundColor)
            [doneButton setBackgroundImage:[self imageWithColor:self.doneButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        doneButton.frame = CGRectMake(self->alertViewFrame.size.width/2,
                                      self->alertViewFrame.size.height - 45,
                                      self->alertViewFrame.size.width/2,
                                      45);
        if (self.detachButtons) {
            doneButton.frame = CGRectMake(self->alertViewFrame.size.width/2 + 6,
                                          doneButton.frame.origin.y - 5,
                                          doneButton.frame.size.width - 16,
                                          40);
            doneButton.layer.cornerRadius = MIN(self.cornerRadius, doneButton.frame.size.height/2);
            doneButton.layer.masksToBounds = YES;
        }
        
        [doneButton setTitle:self->doneTitle forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [doneButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
        if (self.doneButtonCustomFont)
            doneButton.titleLabel.font = self.doneButtonCustomFont;
        if (self.colorScheme != nil || self.darkTheme)
            doneButton.tintColor = [UIColor whiteColor];
        if (self.doneButtonTitleColor != nil)
            doneButton.tintColor = self.doneButtonTitleColor;
        
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeSystem];
        otherButton.backgroundColor = [UIColor whiteColor];
        if (self.detachButtons)
            otherButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
        if (self.darkTheme)
            otherButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        if (self.firstButtonBackgroundColor != nil)
            otherButton.backgroundColor = self.firstButtonBackgroundColor;
        
        if (self.firstButtonHighlightedBackgroundColor)
            [otherButton setBackgroundImage:[self imageWithColor:self.firstButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        otherButton.frame = CGRectMake(0,
                                       self->alertViewFrame.size.height - 45,
                                       self->alertViewFrame.size.width/2,
                                       45);
        if (self.hideDoneButton)
            otherButton.frame = CGRectMake(0,
                                           self->alertViewFrame.size.height - 45,
                                           self->alertViewFrame.size.width,
                                           45);
        
        if (self.detachButtons) {
            otherButton.frame = CGRectMake(self->alertViewFrame.size.width/2 - otherButton.frame.size.width + 16 - 6,
                                           otherButton.frame.origin.y - 5,
                                           otherButton.frame.size.width - 16,
                                           40);
            otherButton.layer.cornerRadius = MIN(self.cornerRadius, otherButton.frame.size.height/2);
            otherButton.layer.masksToBounds = YES;
        }
        
        [otherButton setTitle:[[self->alertButtons objectAtIndex:0] objectForKey:@"title"] forState:UIControlStateNormal];
        [otherButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [otherButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [otherButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        otherButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular];
        if (self.firstButtonCustomFont)
            otherButton.titleLabel.font = self.firstButtonCustomFont;
        otherButton.tintColor = self.colorScheme;
        if (self.colorScheme == nil && self.darkTheme)
            otherButton.tintColor = [UIColor whiteColor];
        if (self.firstButtonTitleColor != nil)
            otherButton.tintColor = self.firstButtonTitleColor;
        
        otherButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        otherButton.titleLabel.minimumScaleFactor = 0.8;
        
        if (!self.hideAllButtons) {
            [alertView addSubview:otherButton];
        }
        
        if (!self.hideAllButtons && !self.hideDoneButton)
            [alertView addSubview:doneButton];
        
        UIView *horizontalSeparator = [[UIView alloc] initWithFrame:CGRectMake(self->alertViewFrame.size.width/2 - 1,
                                                                               otherButton.frame.origin.y - 2,
                                                                               2,
                                                                               47)];
        
        horizontalSeparator.backgroundColor = [UIColor colorWithWhite:100.0f/255.0f alpha:1.0]; // set color as you want.
        if (self.darkTheme)
            horizontalSeparator.backgroundColor = [UIColor colorWithWhite:58.0f/255.0f alpha:1.0];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        if (self.darkTheme)
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView3;
        visualEffectView3 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView3.frame = horizontalSeparator.bounds;
        visualEffectView3.userInteractionEnabled = NO;
        [horizontalSeparator addSubview:visualEffectView3];
        
        if (!self.hideAllButtons && !self.hideDoneButton && !self.detachButtons && !self.hideSeparatorLineView) {
            [alertView addSubview:horizontalSeparator];
        }
        
    } else if (self.numberOfButtons >= 2) { // View  contains TWO OTHER Buttons - First & Second Button
        
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
        firstButton.backgroundColor = [UIColor whiteColor];
        if (self.detachButtons)
            firstButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
        if (self.darkTheme)
            firstButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        if (self.firstButtonBackgroundColor != nil)
            firstButton.backgroundColor = self.firstButtonBackgroundColor;
        
        if (self.firstButtonHighlightedBackgroundColor)
            [firstButton setBackgroundImage:[self imageWithColor:self.firstButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        firstButton.frame = CGRectMake(0,
                                       self->alertViewFrame.size.height - 135,
                                       self->alertViewFrame.size.width,
                                       45);
        
        if (self.hideDoneButton)
            firstButton.frame = CGRectMake(0,
                                           self->alertViewFrame.size.height - 45,
                                           self->alertViewFrame.size.width/2,
                                           45);
        
        if (self.detachButtons) {
            firstButton.frame = CGRectMake(firstButton.frame.origin.x + 8,
                                           firstButton.frame.origin.y - 5,
                                           firstButton.frame.size.width - 16,
                                           40);
            firstButton.layer.cornerRadius = MIN(self.cornerRadius, firstButton.frame.size.height/2);
            firstButton.layer.masksToBounds = YES;
        }
        
        [firstButton setTitle:[[self->alertButtons objectAtIndex:0] objectForKey:@"title"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [firstButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [firstButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        firstButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular];
        if (self.firstButtonCustomFont)
            firstButton.titleLabel.font = self.firstButtonCustomFont;
        firstButton.tintColor = self.colorScheme;
        if (self.colorScheme == nil && self.darkTheme)
            firstButton.tintColor = [UIColor whiteColor];
        if (self.firstButtonTitleColor != nil)
            firstButton.tintColor = self.firstButtonTitleColor;
        
        firstButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        firstButton.titleLabel.minimumScaleFactor = 0.8;
        firstButton.tag = 0;
        
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeSystem];
        secondButton.backgroundColor = [UIColor whiteColor];
        if (self.detachButtons)
            secondButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
        if (self.darkTheme)
            secondButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        if (self.secondButtonBackgroundColor != nil)
            secondButton.backgroundColor = self.secondButtonBackgroundColor;
        
        if (self.secondButtonHighlightedBackgroundColor)
            [secondButton setBackgroundImage:[self imageWithColor:self.secondButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        secondButton.frame = CGRectMake(0,
                                        self->alertViewFrame.size.height - 90,
                                        self->alertViewFrame.size.width,
                                        45);
        if (self.hideDoneButton)
            secondButton.frame = CGRectMake(self->alertViewFrame.size.width/2,
                                            self->alertViewFrame.size.height - 45,
                                            self->alertViewFrame.size.width/2,
                                            45);
        
        if (self.detachButtons) {
            secondButton.frame = CGRectMake(secondButton.frame.origin.x + 8,
                                            secondButton.frame.origin.y - 5,
                                            secondButton.frame.size.width - 16,
                                            40);
            secondButton.layer.cornerRadius = MIN(self.cornerRadius, secondButton.frame.size.height/2);
            secondButton.layer.masksToBounds = YES;
        }
        
        [secondButton setTitle:[[self->alertButtons objectAtIndex:1] objectForKey:@"title"] forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [secondButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [secondButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        secondButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular];
        if (self.secondButtonCustomFont)
            secondButton.titleLabel.font = self.secondButtonCustomFont;
        secondButton.tintColor = self.colorScheme;
        if (self.colorScheme == nil && self.darkTheme)
            secondButton.tintColor = [UIColor whiteColor];
        if (self.secondButtonTitleColor != nil)
            secondButton.tintColor = self.secondButtonTitleColor;
        
        secondButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        secondButton.titleLabel.minimumScaleFactor = 0.8;
        secondButton.tag = 1;
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (self.colorScheme == nil) {
            doneButton.backgroundColor = [UIColor whiteColor];
            if (self.detachButtons)
                doneButton.backgroundColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
            if (self.darkTheme)
                doneButton.backgroundColor = [UIColor colorWithWhite:78.0f/255.0f alpha:1.0];
        } else {
            doneButton.backgroundColor = self.colorScheme;
        }
        
        if (self.doneButtonHighlightedBackgroundColor)
            [doneButton setBackgroundImage:[self imageWithColor:self.doneButtonHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        
        doneButton.frame = CGRectMake(0,
                                      self->alertViewFrame.size.height - 45,
                                      self->alertViewFrame.size.width,
                                      45);
        if (self.detachButtons) {
            doneButton.frame = CGRectMake(8,
                                          self->alertViewFrame.size.height - 50,
                                          self->alertViewFrame.size.width - 16,
                                          40);
            doneButton.layer.cornerRadius = MIN(self.cornerRadius, doneButton.frame.size.height/2);
            doneButton.layer.masksToBounds = YES;
        }
        
        [doneButton setTitle:self->doneTitle forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchDown];
        [doneButton addTarget:self action:@selector(btnReleased) forControlEvents:UIControlEventTouchDragExit];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        if (self.doneButtonCustomFont)
            doneButton.titleLabel.font = self.doneButtonCustomFont;
        if (self.colorScheme != nil || self.darkTheme)
            doneButton.tintColor = [UIColor whiteColor];
        if (self.doneButtonTitleColor != nil)
            doneButton.tintColor = self.doneButtonTitleColor;
        
        if (!self.hideAllButtons) {
            [alertView addSubview:firstButton];
            [alertView addSubview:secondButton];
        }
        
        if (!self.hideAllButtons && !self.hideDoneButton)
            [alertView addSubview:doneButton];
        
        UIView *firstSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          firstButton.frame.origin.y - 2,
                                                                          self->alertViewFrame.size.width,
                                                                          2)];
        firstSeparator.backgroundColor = [UIColor colorWithWhite:100.0f/255.0f alpha:1.0]; // set color as you want.
        if (self.darkTheme)
            firstSeparator.backgroundColor = [UIColor colorWithWhite:58.0f/255.0f alpha:1.0];
        
        UIView *secondSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           secondButton.frame.origin.y - 2,
                                                                           self->alertViewFrame.size.width,
                                                                           2)];
        if (self.hideDoneButton)
            secondSeparator.frame = CGRectMake(self->alertViewFrame.size.width/2 - 1,
                                               secondButton.frame.origin.y,
                                               2,
                                               45);
        secondSeparator.backgroundColor = [UIColor colorWithWhite:100.0f/255.0f alpha:1.0]; // set color as you want.
        if (self.darkTheme)
            secondSeparator.backgroundColor = [UIColor colorWithWhite:58.0f/255.0f alpha:1.0];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        if (self.darkTheme)
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = firstSeparator.bounds;
        visualEffectView.userInteractionEnabled = NO;
        [firstSeparator addSubview:visualEffectView];
        
        UIVisualEffectView *visualEffectView2;
        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView2.frame = secondSeparator.bounds;
        visualEffectView2.userInteractionEnabled = NO;
        [secondSeparator addSubview:visualEffectView2];
        
        if (!self.hideAllButtons && !self.detachButtons && !self.hideSeparatorLineView) {
            [alertView addSubview:firstSeparator];
            [alertView addSubview:secondSeparator];
        }
        
    }
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    if (self.darkTheme)
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = separatorLineView.bounds;
    visualEffectView.userInteractionEnabled = NO;
    [separatorLineView addSubview:visualEffectView];
    
    if (!self.fullCircleCustomImage) {
        self->circleLayer = [CAShapeLayer layer];
        [self->circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self->alertViewContents.frame.size.width/2 - 30.0f, -30.0f, 60.0f, 60.0f)] CGPath]];
        if (!self.alertBackgroundColor)
            [self->circleLayer setFillColor:[UIColor whiteColor].CGColor];
        else
            [self->circleLayer setFillColor:self.alertBackgroundColor.CGColor];
    }
    
    if (self.darkTheme)
        self->circleLayer.fillColor = [UIColor colorWithWhite:48.0f/255.0f alpha:1.0].CGColor;
    if ([self->alertType isEqualToString:@"Progress"] && self.colorScheme != nil)
        [self->circleLayer setFillColor:[self.colorScheme CGColor]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self->alertViewContents.frame.size.width/2 - 30.0f, -30.0f, 60.0f, 60.0f)];
    if (self->circleLayer.fillColor == [UIColor whiteColor].CGColor)
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    else
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    
    UIImageView *alertViewVector;
    
    if (self.avoidCustomImageTint && self->alertType.length == 0) {
        alertViewVector = [[UIImageView alloc] init];
        alertViewVector.image = self->vectorImage;
    } else {
        alertViewVector = [[UIImageView alloc] init];
        alertViewVector.image = [self->vectorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    if (self.fullCircleCustomImage)
        self.customImageScale = 2;
    
    if (self.customImageScale <= 0) {
        self.customImageScale = 1;
    }
    
    CGFloat vectorSize = 30.0f * MIN(2, self.customImageScale);
    
    alertViewVector.frame = CGRectMake(self->alertViewContents.frame.size.width/2 - (vectorSize/2),
                                       -(vectorSize/2) - 0.5,
                                       vectorSize,
                                       vectorSize);
    
    alertViewVector.contentMode = UIViewContentModeScaleAspectFit;
    alertViewVector.userInteractionEnabled = 0;
    alertViewVector.tintColor = self.colorScheme;
    
    // VIEW BORDER - Rounding Corners of AlertView
    
    alertView.layer.cornerRadius = self.cornerRadius;
    alertView.layer.masksToBounds = YES;
    
    // ADDING CONTENTS - Contained in Header and Separator Views
    
    [self->alertViewContents addSubview:titleLabel];
    [self->alertViewContents addSubview:descriptionLabel];
    
    if (!self.hideAllButtons && !self.hideSeparatorLineView) {
        if (self.numberOfButtons == 1 && !self.detachButtons)
            [self->alertViewContents addSubview:separatorLineView];
        else if (!self.hideDoneButton && !self.detachButtons)
            [self->alertViewContents addSubview:separatorLineView];
    }
    
    if (self->alertViewWithVector) {
        [self->alertViewContents.layer addSublayer:self->circleLayer];
        [self->alertViewContents addSubview:alertViewVector];
        if ([self->alertType isEqualToString:@"Progress"])
            [self->alertViewContents addSubview:spinner];
        
    }
    
    // SCALING ALERTVIEW - Before Animation
    
    if (!self.animateAlertInFromTop && !self.animateAlertInFromLeft && !self.animateAlertInFromRight && !self.animateAlertInFromBottom) {
        self->alertViewContents.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } else {
        if (self.animateAlertInFromTop)
            self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                 0 - self->alertViewFrame.size.height - 15,
                                                 self->alertViewFrame.size.width,
                                                 self->alertViewFrame.size.height);
        if (self.animateAlertInFromRight)
            self->alertViewContents.frame = CGRectMake(self.frame.size.width + self->alertViewFrame.size.width + 15,
                                                 self->alertViewFrame.origin.y,
                                                 self->alertViewFrame.size.width,
                                                 self->alertViewFrame.size.height);
        if (self.animateAlertInFromBottom)
            self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                 self.frame.size.height + self->alertViewFrame.size.height + 15,
                                                 self->alertViewFrame.size.width,
                                                 self->alertViewFrame.size.height);
        if (self.animateAlertInFromLeft)
            self->alertViewContents.frame = CGRectMake(0 - self->alertViewFrame.size.width - 15,
                                                 self->alertViewFrame.origin.y,
                                                 self->alertViewFrame.size.width,
                                                 self->alertViewFrame.size.height);
    }
    
    // ADDING RATING SYSTEM
    
    UITextField *tf = [self->alertTextFieldHolder firstObject];
    
    self->ratingController = [[UIView alloc] initWithFrame:CGRectMake(20,
                                                                descriptionLevel + self->descriptionLabelFrames.size.height + 32.5 + 15+ (MAX(1, MIN(self->alertTextFields.count,4))*(tf.frame.size.height + 7.5)),
                                                                self->alertViewFrame.size.width - 40,
                                                                40)];
    
    CGFloat spacingBetween = (self->ratingController.frame.size.width - (40*4))/5;
    
    UIImage *starImage = [[self loadImageFromResourceBundle:@"star.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *heartImage = [[self loadImageFromResourceBundle:@"heart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self->item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self->item1.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item1.frame = CGRectMake(40*0 + spacingBetween, 0, 40.0f, 40.0f);
    self->item1.userInteractionEnabled = 0;
    
    self->item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self->item2.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item2.frame = CGRectMake(40*1 + spacingBetween, 0, 40.0f, 40.0f);
    self->item2.userInteractionEnabled = 0;
    
    self->item3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self->item3.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item3.frame = CGRectMake(40*2 + spacingBetween, 0, 40.0f, 40.0f);
    self->item3.userInteractionEnabled = 0;
    
    self->item4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self->item4.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item4.frame = CGRectMake(40*3 + spacingBetween, 0, 40.0f, 40.0f);
    self->item4.userInteractionEnabled = 0;
    
    self->item5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self->item5.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item5.frame = CGRectMake(40*4 + spacingBetween, 0, 40.0f, 40.0f);
    self->item5.userInteractionEnabled = 0;
    
    if (self->alertTypeRatingHearts) {
        [self->item1 setImage:heartImage forState:UIControlStateNormal];
        [self->item2 setImage:heartImage forState:UIControlStateNormal];
        [self->item3 setImage:heartImage forState:UIControlStateNormal];
        [self->item4 setImage:heartImage forState:UIControlStateNormal];
        [self->item5 setImage:heartImage forState:UIControlStateNormal];
    }
    
    if (self->alertTypeRatingStars) {
        [self->item1 setImage:starImage forState:UIControlStateNormal];
        [self->item2 setImage:starImage forState:UIControlStateNormal];
        [self->item3 setImage:starImage forState:UIControlStateNormal];
        [self->item4 setImage:starImage forState:UIControlStateNormal];
        [self->item5 setImage:starImage forState:UIControlStateNormal];
    }
    
    self->item1.adjustsImageWhenHighlighted = NO;
    self->item2.adjustsImageWhenHighlighted = NO;
    self->item3.adjustsImageWhenHighlighted = NO;
    self->item4.adjustsImageWhenHighlighted = NO;
    self->item5.adjustsImageWhenHighlighted = NO;
    
    [self->ratingController addSubview:self->item1];
    [self->ratingController addSubview:self->item2];
    [self->ratingController addSubview:self->item3];
    [self->ratingController addSubview:self->item4];
    [self->ratingController addSubview:self->item5];
    
    if (self->alertTypeRatingHearts || self->alertTypeRatingStars)
        [self->alertViewContents addSubview:self->ratingController];
    
    // APPLYING SHADOW
    
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.10f];
    [self.layer setShadowRadius:10.0f];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    
    if (self.bounceAnimations) {
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-22.5);
        horizontalMotionEffect.maximumRelativeValue = @(22.5);
        
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-22.5);
        verticalMotionEffect.maximumRelativeValue = @(22.5);
        
        [self->alertViewContents addMotionEffect:horizontalMotionEffect];
        [self->alertViewContents addMotionEffect:verticalMotionEffect];
        
    }
    
    [self showAlertView];
    
}

#pragma mark - Create Image with Color

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Getting Resources from Bundle

+(NSBundle *)getResourcesBundle
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"FCAlertView" withExtension:@"bundle"]];
    return bundle;
}

-(UIImage *)loadImageFromResourceBundle:(NSString *)imageName
{
    UIImage *icon = [UIImage imageNamed:imageName];
    
    CGImageRef cgref = [icon CGImage];
    CIImage *cim = [icon CIImage];
    
    if (cim == nil && cgref == NULL)
    {
        NSBundle *bundle = [FCAlertView getResourcesBundle];
        NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
        UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
        return image;
    }
    
    return icon;
}

#pragma  mark - Default Types of Alerts

- (void) makeAlertTypeWarning {
    self->vectorImage = [self loadImageFromResourceBundle:@"close-round.png"];
    self->alertViewWithVector = 1;
    self.colorScheme = self.flatRed;
    self->alertType = @"Warning";
}

- (void) makeAlertTypeCaution {
    self->vectorImage = [self loadImageFromResourceBundle:@"alert-round.png"];
    self->alertViewWithVector = 1;
    self.colorScheme = self.flatOrange;
    self->alertType = @"Caution";
}

- (void) makeAlertTypeSuccess {
    self->vectorImage = [self loadImageFromResourceBundle:@"checkmark-round.png"];
    self->alertViewWithVector = 1;
    self.colorScheme = self.flatGreen;
    self->alertType = @"Success";
}

- (void) makeAlertTypeProgress {
    [self->circleLayer setFillColor:[self.colorScheme CGColor]];
    self->alertViewWithVector = 1;
    self->alertType = @"Progress";
}

- (void) makeAlertTypeRateHearts:(FCRatingBlock)ratingBlock {
    self.ratingBlock = ratingBlock;
    self->vectorImage = [self loadImageFromResourceBundle:@"heart.png"];
    self->alertViewWithVector = 1;
    self->alertTypeRatingHearts = 1;
    self->alertTypeRatingStars = 0;
    self.colorScheme = [UIColor colorWithRed:228.0f/255.0f green:77.0f/255.0f blue:65.0f/255.0f alpha:1.0];
}

- (void) makeAlertTypeRateStars:(FCRatingBlock)ratingBlock {
    self.ratingBlock = ratingBlock;
    self->vectorImage = [self loadImageFromResourceBundle:@"star.png"];
    self->alertViewWithVector = 1;
    self->alertTypeRatingStars = 1;
    self->alertTypeRatingHearts = 0;
    self.colorScheme = [UIColor colorWithRed:234.0f/255.0f green:201.0f/255.0f blue:77.0f/255.0f alpha:1.0];
}

#pragma mark - Play Sound with Alert

- (void) setAlertSoundWithFileName:(NSString *)filename {
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@",
                               [[NSBundle mainBundle] resourcePath], filename];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self->player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                    error:nil];
    self->player.numberOfLoops = 0;
    
}

#pragma  mark - Presenting AlertView

- (void) showAlertInView:(UIViewController *)view withTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons {
    
    // Blur Effect
    
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = view.view.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [view.view addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [self setAlertViewAttributes:title withSubtitle:subTitle withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    [view.view.window addSubview:self];
    
}

- (void) showAlertInWindow:(UIWindow *)window withTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons {
    
    // Blur Effect
    
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = window.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [window addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [self setAlertViewAttributes:title withSubtitle:subTitle withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    [window addSubview:self];
    
}

- (void) showAlertWithTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons{
    
    [self setAlertViewAttributes:title withSubtitle:subTitle withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Blur Effect
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = window.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [window addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
}

- (void) showAlertWithAttributedTitle:(NSAttributedString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons {
    
    self.attributedTitle = title;
    [self setAlertViewAttributes:nil withSubtitle:subTitle withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Blur Effect
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = window.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [window addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void) showAlertWithTitle:(NSString *)title withAttributedSubtitle:(NSAttributedString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons {
    
    self.attributedSubTitle = subTitle;
    [self setAlertViewAttributes:title withSubtitle:nil withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Blur Effect
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = window.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [window addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void) showAlertWithAttributedTitle:(NSAttributedString *)title withAttributedSubtitle:(NSAttributedString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons {
    
    self.attributedTitle = title;
    self.attributedSubTitle = subTitle;
    [self setAlertViewAttributes:nil withSubtitle:nil withCustomImage:image withDoneButtonTitle:done andButtons:buttons];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Blur Effect
    if (self.blurBackground && NSClassFromString(@"UIVisualEffectView") != nil) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self->backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self->backgroundVisualEffectView.frame = window.bounds;
        self.alertBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        [window addSubview:self->backgroundVisualEffectView];
    }
    
    // Adding Alert
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
}


- (void)setAlertViewAttributes:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons{
    
    self.title = title;
    self.subTitle = subTitle;
    
    for (int i = 0; i < buttons.count; i++) {
        NSDictionary *btnDict = @{@"title" : [buttons objectAtIndex:i],
                                  @"action" : @0};
        [self->alertButtons addObject:btnDict];
    }
    
    self.numberOfButtons = self->alertButtons.count;
    self->doneTitle = done;
    
    if (!self->alertViewWithVector)
        self->vectorImage = image;
    
    // Checks prior to presenting View
    
    [self checkCustomizationValid];
    [self safetyCloseCheck];
    
}

#pragma  mark - Showing and Hiding AlertView Animations

- (void) showAlertView {
    
    id<FCAlertViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(FCAlertViewWillAppear:)]) {
        [strongDelegate FCAlertViewWillAppear:self];
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        if (self.bounceAnimations) {
            if (!self.animateAlertInFromTop && !self.animateAlertInFromLeft && !self.animateAlertInFromRight && !self.animateAlertInFromBottom)
                self->alertViewContents.transform = CGAffineTransformMakeScale(0.95, 0.95);
            if (self.animateAlertInFromTop)
                self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                     self->alertViewFrame.origin.y + 7.5,
                                                     self->alertViewFrame.size.width,
                                                     self->alertViewFrame.size.height);
            if (self.animateAlertInFromRight)
                self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x - 7.5,
                                                     self->alertViewFrame.origin.y,
                                                     self->alertViewFrame.size.width,
                                                     self->alertViewFrame.size.height);
            if (self.animateAlertInFromBottom)
                self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                     self->alertViewFrame.origin.y - 7.5,
                                                     self->alertViewFrame.size.width,
                                                     self->alertViewFrame.size.height);
            if (self.animateAlertInFromLeft)
                self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x + 7.5,
                                                     self->alertViewFrame.origin.y,
                                                     self->alertViewFrame.size.width,
                                                     self->alertViewFrame.size.height);
        } else {
            self->alertViewContents.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                 self->alertViewFrame.origin.y,
                                                 self->alertViewFrame.size.width,
                                                 self->alertViewFrame.size.height);
        }
        
    } completion:^(BOOL finished) {
        if (self.bounceAnimations)
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if (!self.animateAlertInFromTop && !self.animateAlertInFromLeft && !self.animateAlertInFromRight && !self.animateAlertInFromBottom)
                    self->alertViewContents.transform = CGAffineTransformMakeScale(1.00, 1.00);
                self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                     self->alertViewFrame.origin.y,
                                                     self->alertViewFrame.size.width,
                                                     self->alertViewFrame.size.height);
            } completion:nil];
        if (self.autoHideSeconds != 0) {
            [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:self.autoHideSeconds];
        }
    }];
    
    // Playing Sound for Alert (when there is one)
    
    [self->player play];
    
}

- (void) dismissAlertView {
    
    [UIView animateWithDuration:0.175 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (!self.animateAlertOutToTop && !self.animateAlertOutToLeft && !self.animateAlertOutToRight && !self.animateAlertOutToBottom) {
            self.alpha = 0;
            self->backgroundVisualEffectView.alpha = 0;
            self->alertViewContents.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } else {
            
            if (self.bounceAnimations) {
                if (self.animateAlertOutToTop)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                         self->alertViewFrame.origin.y + 7.5,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToRight)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x - 7.5,
                                                         self->alertViewFrame.origin.y,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToBottom)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                         self->alertViewFrame.origin.y - 7.5,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToLeft)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x + 7.5,
                                                         self->alertViewFrame.origin.y,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
            } else {
                self.alpha = 0;
                self->backgroundVisualEffectView.alpha = 0;
                
                if (self.animateAlertOutToTop)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                         0 - self->alertViewFrame.size.height - 15,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToRight)
                    self->alertViewContents.frame = CGRectMake(self.frame.size.width + self->alertViewFrame.size.width + 15,
                                                         self->alertViewFrame.origin.y,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToBottom)
                    self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                         self.frame.size.height + self->alertViewFrame.size.height + 15,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
                if (self.animateAlertOutToLeft)
                    self->alertViewContents.frame = CGRectMake(0 - self->alertViewFrame.size.width - 15,
                                                         self->alertViewFrame.origin.y,
                                                         self->alertViewFrame.size.width,
                                                         self->alertViewFrame.size.height);
            }
        }
        
    } completion:^(BOOL finished) {
        
        if (!self.animateAlertOutToTop && !self.animateAlertOutToLeft && !self.animateAlertOutToRight && !self.animateAlertOutToBottom) {
            id<FCAlertViewDelegate> strongDelegate = self.delegate;
            
            if ([strongDelegate respondsToSelector:@selector(FCAlertViewDismissed:)]) {
                [strongDelegate FCAlertViewDismissed:self];
            }
            
            [self->backgroundVisualEffectView removeFromSuperview];
            [self removeFromSuperview];
        } else {
            if (self.bounceAnimations) {
                [UIView animateWithDuration:0.175 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    self.alpha = 0;
                    self->backgroundVisualEffectView.alpha = 0;
                    
                    if (self.animateAlertOutToTop)
                        self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                             0 - self->alertViewFrame.size.height - 15,
                                                             self->alertViewFrame.size.width,
                                                             self->alertViewFrame.size.height);
                    if (self.animateAlertOutToRight)
                        self->alertViewContents.frame = CGRectMake(self.frame.size.width + self->alertViewFrame.size.width + 15,
                                                             self->alertViewFrame.origin.y,
                                                             self->alertViewFrame.size.width,
                                                             self->alertViewFrame.size.height);
                    if (self.animateAlertOutToBottom)
                        self->alertViewContents.frame = CGRectMake(self->alertViewFrame.origin.x,
                                                             self.frame.size.height + self->alertViewFrame.size.height + 15,
                                                             self->alertViewFrame.size.width,
                                                             self->alertViewFrame.size.height);
                    if (self.animateAlertOutToLeft)
                        self->alertViewContents.frame = CGRectMake(0 - self->alertViewFrame.size.width - 15,
                                                             self->alertViewFrame.origin.y,
                                                             self->alertViewFrame.size.width,
                                                             self->alertViewFrame.size.height);
                }completion:^(BOOL finished) {
                    id<FCAlertViewDelegate> strongDelegate = self.delegate;
                    
                    if ([strongDelegate respondsToSelector:@selector(FCAlertViewDismissed:)]) {
                        [strongDelegate FCAlertViewDismissed:self];
                    }
                    
                    [self->backgroundVisualEffectView removeFromSuperview];
                    [self removeFromSuperview];
                }];
            } else {
                id<FCAlertViewDelegate> strongDelegate = self.delegate;
                
                if ([strongDelegate respondsToSelector:@selector(FCAlertViewDismissed:)]) {
                    [strongDelegate FCAlertViewDismissed:self];
                }
                
                [self->backgroundVisualEffectView removeFromSuperview];
                [self removeFromSuperview];
            }
        }
        
    }];
    
}

#pragma mark - Action Block Methods

- (void)addButton:(NSString *)title withActionBlock:(FCActionBlock)action {
    
    if (self->alertButtons.count < 2) {
        if (action != nil)
            [self->alertButtons addObject:@{@"title" : title,
                                      @"action" : action}];
        else
            [self->alertButtons addObject:@{@"title" : title,
                                      @"action" : @0}];
    }
    
    self.numberOfButtons = self->alertButtons.count;
    
}

- (void)doneActionBlock:(FCActionBlock)action {
    
    if (action != nil)
        self.doneBlock = action;
    
}

#pragma  mark - ACTIONS
#pragma mark Button Selection

- (void)handleButton:(id)sender {
    
    id<FCAlertViewDelegate> strongDelegate = self.delegate;
    
    // Return Text from TextField to Block
    
    for (int i = 0; i < self->alertTextFields.count; i ++) {
        
        FCTextReturnBlock textReturnBlock = [[self->alertTextFields objectAtIndex:i] objectForKey:@"action"];
        UITextField *tf = [self->alertTextFieldHolder objectAtIndex:i];
        if (textReturnBlock)
            textReturnBlock(tf.text);
        
    }
    
    for (int i = 0; i < self->alertCustomFields.count; i ++) {
        FCTextReturnBlock textReturnBlock = [[self->alertCustomFields objectAtIndex:i] objectForKey:@"action"];
        UIView *cf = [self->alertCustomFieldHolder objectAtIndex:i];
        if (textReturnBlock && [cf respondsToSelector:@selector(FCAlertCustomFieldProtocolStringValue)]) {
            textReturnBlock([cf performSelector:@selector(FCAlertCustomFieldProtocolStringValue)]);
        }
    }
    
    
    // Handling Button Block
    
    UIButton *clickedButton = (UIButton*)sender;
    
    NSDictionary *btnDict = [self->alertButtons objectAtIndex:[sender tag]];
    
    if (btnDict != nil) {
        if ([btnDict objectForKey:@"action"] != nil && ![[btnDict objectForKey:@"action"] isEqual:@0]) {
            FCActionBlock block = [btnDict objectForKey:@"action"];
            if (block)
                block();
        }
    }
    
    if ([strongDelegate respondsToSelector:@selector(FCAlertView:clickedButtonIndex:buttonTitle:)]) {
        [strongDelegate FCAlertView:self clickedButtonIndex:[sender tag] buttonTitle:clickedButton.titleLabel.text];
    }
    
    // Return Rating from Rating Controller
    
    if (self.ratingBlock)
        self.ratingBlock(self->currentRating);
    
    [self dismissAlertView];
    
}

#pragma mark - Button Actions

- (void) btnTouched {
    
    if (self.bounceAnimations) {
        
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1;
            if (self.bounceAnimations)
                self->alertViewContents.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:nil];
        
    }
    
}

- (void) donePressed {
    
    id<FCAlertViewDelegate> strongDelegate = self.delegate;

    // Return Text from TextField to Block
    
    for (int i = 0; i < self->alertTextFields.count; i ++) {
        
        FCTextReturnBlock textReturnBlock = [[self->alertTextFields objectAtIndex:i] objectForKey:@"action"];
        UITextField *tf = [self->alertTextFieldHolder objectAtIndex:i];
        if (textReturnBlock)
            textReturnBlock(tf.text);
        
    }
    
    for (int i = 0; i < self->alertCustomFields.count; i ++) {
        FCTextReturnBlock textReturnBlock = [[self->alertCustomFields objectAtIndex:i] objectForKey:@"action"];
        UIView *cf = [self->alertCustomFieldHolder objectAtIndex:i];
        if (textReturnBlock && [cf respondsToSelector:@selector(FCAlertCustomFieldProtocolStringValue)]) {
            textReturnBlock([cf performSelector:@selector(FCAlertCustomFieldProtocolStringValue)]);
        }
    }
    
    // Handling Done Button Block

    if (self.doneBlock)
        self.doneBlock();
    
    if ([strongDelegate respondsToSelector:@selector(FCAlertDoneButtonClicked:)]) {
        [strongDelegate FCAlertDoneButtonClicked:self];
    }
    
    // Return Rating from Rating Controller
    
    if (self.ratingBlock)
        self.ratingBlock(self->currentRating);
    
    [self dismissAlertView];
    
}

- (void) btnReleased {
    
    if (self.bounceAnimations) {
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->alertViewContents.transform = CGAffineTransformMakeScale(1.05, 1.05);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->alertViewContents.transform = CGAffineTransformMakeScale(1.00, 1.00);
            }completion:nil];
        }];
        
    }
    
}

#pragma mark - TEXT FIELD METHODS
#pragma mark - Text Field Begin Editing

#pragma mark - Adding Alert TextField Block Method

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder andTextReturnBlock:(FCTextReturnBlock)textReturn {
    
    if (textReturn != nil)
        [self->alertTextFields addObject:@{@"placeholder" : placeholder,
                                     @"action" : textReturn}];
    else
        [self->alertTextFields addObject:@{@"placeholder" : placeholder,
                                     @"action" : @0}];
    
}

- (void)addTextFieldWithCustomTextField:(UITextField *)field andPlaceholder:(NSString *)placeholder andTextReturnBlock:(FCTextReturnBlock)textReturn {
    
    if (placeholder == nil)
        placeholder = @"";
    
    if (textReturn != nil)
        [self->alertTextFields addObject:@{@"field" : field,
                                     @"placeholder" : placeholder,
                                     @"action" : textReturn}];
    else
        [self->alertTextFields addObject:@{@"field" : field,
                                     @"placeholder" : placeholder,
                                     @"action" : @0}];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self->currentAVCFrames = self->alertViewContents.frame;
    
    [UIView animateWithDuration:0.30 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->alertViewContents.frame = CGRectMake(self->currentAVCFrames.origin.x,
                                             self->currentAVCFrames.origin.y - 80,
                                             self->currentAVCFrames.size.width,
                                             self->currentAVCFrames.size.height);
    } completion:nil];
    
}

#pragma mark - Text Field End Editing

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.30 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->alertViewContents.frame = CGRectMake(self->currentAVCFrames.origin.x,
                                             self->currentAVCFrames.origin.y,
                                             self->currentAVCFrames.size.width,
                                             self->currentAVCFrames.size.height);
    } completion:nil];
    
}

#pragma mark - Text Field Returned

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag+1 == self->alertTextFieldHolder.count) {
        [textField endEditing:YES];
    } else {
        UITextField *tf = [self->alertTextFieldHolder objectAtIndex:(textField.tag+1)];
        [tf becomeFirstResponder];
    }
    
    return TRUE;
}

#pragma mark - Rating System Trigger Methods

- (void) rate1Triggered {
    if (self->currentRating != 1) {
        self->currentRating = 1;
        [self setActiveRating:self->currentRating];
    } else {
        self->currentRating = 0;
        [self setActiveRating:self->currentRating];
    }
    
    if (self.bounceAnimations) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->item1.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->item1.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
    }
    
}

- (void) rate2Triggered {
    self->currentRating = 2;
    [self setActiveRating:self->currentRating];
    
    if (self.bounceAnimations) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->item2.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->item2.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
    }
}

- (void) rate3Triggered {
    self->currentRating = 3;
    [self setActiveRating:self->currentRating];
    
    if (self.bounceAnimations) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->item3.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->item3.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
    }
}

- (void) rate4Triggered {
    self->currentRating = 4;
    [self setActiveRating:self->currentRating];
    
    if (self.bounceAnimations) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->item4.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->item4.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
    }
}

- (void) rate5Triggered {
    self->currentRating = 5;
    [self setActiveRating:self->currentRating];
    
    if (self.bounceAnimations) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->item5.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->item5.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
    }
}

- (void) setActiveRating:(NSInteger)rating {
    
    self->item1.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item2.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item3.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item4.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    self->item5.tintColor = [UIColor colorWithWhite:228.0f/255.0f alpha:1.0];
    
    if (rating == 1) {
        self->item1.tintColor = self.colorScheme;
    }
    
    if (rating == 2) {
        self->item1.tintColor = self.colorScheme;
        self->item2.tintColor = self.colorScheme;
    }
    
    if (rating == 3) {
        self->item1.tintColor = self.colorScheme;
        self->item2.tintColor = self.colorScheme;
        self->item3.tintColor = self.colorScheme;
    }
    
    if (rating == 4) {
        self->item1.tintColor = self.colorScheme;
        self->item2.tintColor = self.colorScheme;
        self->item3.tintColor = self.colorScheme;
        self->item4.tintColor = self.colorScheme;
    }
    
    if (rating == 5) {
        self->item1.tintColor = self.colorScheme;
        self->item2.tintColor = self.colorScheme;
        self->item3.tintColor = self.colorScheme;
        self->item4.tintColor = self.colorScheme;
        self->item5.tintColor = self.colorScheme;
    }
    
}

- (void)addCustomField:(UIView *)field andPlaceholder:(NSString *)placeholder andTextReturnBlock:(FCTextReturnBlock)textReturn {
    
    if ([field respondsToSelector:@selector(FCAlertCustomFieldProtocolSetPlaceholder:)]) {
        [field performSelector:@selector(FCAlertCustomFieldProtocolSetPlaceholder:) withObject:placeholder];
    }
    
    if (textReturn != nil)
        [self->alertCustomFields addObject:@{@"field" : field,
                                       @"placeholder" : placeholder ? placeholder : @"",
                                       @"action" : textReturn}];
    else
        [self->alertCustomFields addObject:@{@"field" : field,
                                       @"placeholder" : placeholder ? placeholder : @"",
                                       @"action" : @0}];
}

@end
