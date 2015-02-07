//
//  ViewController.h
//  Tic Tac Snow
//
//  Created by helenwang on 2/6/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XOImageView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *grid;
@property (weak, nonatomic) IBOutlet UIView *leftTop;
@property (weak, nonatomic) IBOutlet UIView *centerTop;
@property (weak, nonatomic) IBOutlet UIView *rightTop;
@property (weak, nonatomic) IBOutlet UIView *leftMiddle;
@property (weak, nonatomic) IBOutlet UIView *centerMiddle;
@property (weak, nonatomic) IBOutlet UIView *rightMiddle;
@property (weak, nonatomic) IBOutlet UIView *leftBottom;
@property (weak, nonatomic) IBOutlet UIView *centerBottom;
@property (weak, nonatomic) IBOutlet UIView *rightBottom;

@property (weak, nonatomic) IBOutlet XOImageView *xView;
@property (weak, nonatomic) IBOutlet XOImageView *oView;

@property (weak, nonatomic) IBOutlet UIButton *info;

// info view properties
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UIButton *infoDismiss;

@property NSInteger moveCount;

@property NSMutableArray *gridTracker;
@property NSMutableArray *xArray;
@property NSMutableArray *oArray;

- (IBAction)infoPressed:(id)sender;
- (IBAction)closeInfo:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)resizeToFitSubviews;

@end

