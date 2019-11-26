//
//  AddTask.m
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

#import "AddTaskView.h"
#import <UIKit/UIKit.h>

@interface TaskCreationView ()

@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) UITextField *descText;

@end

@implementation TaskCreationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Create translucent view to highlight the layer
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.alpha = 0.5;
        backgroundView.backgroundColor = [UIColor colorWithRed:0.72 green:0.63 blue:0.69 alpha:1.0];
        
        // Pop-Up window view
        UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
        windowView.center = self.center;
        windowView.backgroundColor = [UIColor colorWithRed:0.93 green:0.90 blue:0.92 alpha:1.0];
        
        // Title field setup
        self.titleText = [[UITextField alloc] initWithFrame:CGRectMake(6, 6, windowView.frame.size.width - 12, 35)];
        self.titleText.layer.cornerRadius = 15;
        self.titleText.backgroundColor = UIColor.whiteColor;
        self.titleText.textColor = [UIColor colorWithRed:0.02 green:0.03 blue:0.18 alpha:1.0];
        self.titleText.textAlignment = NSTextAlignmentCenter;
        //        self.titleText.textAlignment = NSTextAlignmentLeft + 5;
        NSTextAlignment alignment = NSTextAlignmentCenter;
        NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
        alignmentSetting.alignment = alignment;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName : alignmentSetting};
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Title" attributes: attributes];
        self.titleText.attributedPlaceholder = str1;
        
        // Description field setup
        self.descText = [[UITextField alloc] initWithFrame:CGRectMake(6,
                                                                      47,
                                                                      windowView.frame.size.width - 12,
                                                                      windowView.frame.size.height - 95)];
        [self.descText setFont:self.titleText.font];
        self.descText.textColor = [UIColor colorWithRed:0.02 green:0.03 blue:0.18 alpha:1.0];
        self.descText.textAlignment = NSTextAlignmentCenter;
        self.descText.backgroundColor = UIColor.whiteColor;
        self.descText.layer.cornerRadius = 15;
        alignmentSetting.alignment = alignment;
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Description" attributes: attributes];
        self.descText.attributedPlaceholder = str2;
        
        // Buttons setup
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(4,
                                                                        windowView.frame.size.height - 44,
                                                                        windowView.frame.size.width / 2 - 6,
                                                                        38)];
        [okButton setTitleColor:[UIColor colorWithRed:0.63 green:0.72 blue:0.69 alpha:1.0] forState:UIControlStateNormal];
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(windowView.frame.size.width / 2 + 2,
                                                                            windowView.frame.size.height - 44,
                                                                            windowView.frame.size.width / 2 - 6,
                                                                            38)];
        [cancelButton setTitleColor:[UIColor colorWithRed:0.72 green:0.63 blue:0.69 alpha:1.0] forState:UIControlStateNormal];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        // Add subviews to Pop-Up view
        [windowView addSubview:self.titleText];
        [windowView addSubview:self.descText];
        [windowView addSubview:okButton];
        [windowView addSubview:cancelButton];
        
        // Add subviews to the root view
        [self addSubview:backgroundView];
        [self addSubview:windowView];
    }
    return self;
}

- (void)makeViewVisible
{
    self.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){
        self.alpha = 1;
    }];
}

/**
 When OK button is tapped, call delegate to create new task cell; close the view
 */
- (void)okButtonTapped
{
    [self.delegate taskDidCreatedWithTitle:self.titleText.text desc:self.descText.text];
    [self hideViewWithAnimation];
}

/**
 Remove the view without any data changes
 */
- (void)cancelButtonTapped
{
    [self hideViewWithAnimation];
    [self.delegate taskCreationDidCanceled];
}

/**
 Hide view with animation and remove from superview at the end
 */
- (void)hideViewWithAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
