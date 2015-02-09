//
//  ViewController.m
//  Tic Tac Snow
//
//  Created by helenwang on 2/6/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "ViewController.h"
#import "infoView.h"
#import "XOImageView.h"
@import AudioToolbox;
@import AVFoundation;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet infoView *infoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // if info button is pressed
    [self.info addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.moveCount = 0; // initialize move count (used to toggle between turns)
    self.initialPlayer = 0; // 0 = X, 1 = O
    
    self.gridTracker = [[NSMutableArray alloc] initWithCapacity:9]; // keep track of if spaces in grid are taken
    for (int i=0; i<10; i++){
        [self.gridTracker addObject:@"0"]; // initialize
    }
    
    self.xArray = [[NSMutableArray alloc] init];
    [self.xArray addObject:@"10"];
    self.oArray = [[NSMutableArray alloc] init];
    [self.oArray addObject:@"10"];
    
    [self toggleTurn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoPressed:(id)sender {
    NSLog(@"Button pressed");
    
    [self animateInfo];
    
    /*
    self.infoView.hidden = NO;
    
    self.infoTitle.text = @"HOW TO PLAY";
    self.infoText.text = @"This is a test.";
    
    
    // resize text view
    // reference: http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
    CGFloat fixedWidth = self.infoText.frame.size.width;
    CGSize newSize = [self.infoText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.infoText.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.infoText.frame = newFrame;
    [self.infoDismiss setTitle:@"OK" forState:UIControlStateNormal];
    [self.infoDismiss addTarget:self action:@selector(closeInfo:) forControlEvents:UIControlEventTouchDown];
     */
    
    //[self resizeToFitSubviews];
    //[self.infoView sizeToFit]; // doesn't work
}

- (void)animateInfo {
    NSLog(@"Animation called");
    
    //CGRect offscreen = CGRectMake(360, -100, self.infoView.frame.size.width, self.infoView.frame.size.height);
    self.infoView.center = CGPointMake(360,-100);
    self.infoView.hidden = NO;
    self.infoView.title.text = @"HOW TO PLAY";
    self.infoView.info.text = @"The rules go here.";
    [self.infoView.dismiss setTitle:@"Got it!" forState:UIControlStateNormal];
    
    /*infoView *instructions = [[infoView alloc] initWithFrame:offscreen];
    instructions.hidden = NO;
    instructions.title.text = @"HOW TO PLAY";
    instructions.info.text = @"This is a test hello hello";
    [instructions.dismiss setTitle:@"GOT IT" forState:UIControlStateNormal];*/
    
    // resize text view
    // reference: http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
    /*CGFloat fixedWidth = self.infoText.frame.size.width;
    CGSize newSize = [self.infoText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.infoText.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.infoText.frame = newFrame;*/
    
    [self.view addSubview:self.infoView];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.infoView.center = CGPointMake(self.view.center.x, self.view.center.y);
    }
     completion:^(BOOL finished) {
         NSLog(@"Animation complete");
     }];
}

// reference: http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // when finger is lifted
    // reference: http://stackoverflow.com/questions/6467638/detecting-pan-gesture-end
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended.");
        
        // determine if view frames are intersecting
        for (int i=1; i<10; i++){
            if (CGRectIntersectsRect(self.xView.frame, [self.view viewWithTag:i].frame)) {
                // check the area of overlap (must be >5000 to continue)
                // this is to ensure that only one frame is filled (adjacent ones aren't affected)
                // reference: http://www.bignerdranch.com/blog/rectangles-part-2/
                CGRect intersection = CGRectIntersection(self.xView.frame, [self.view viewWithTag:i].frame);
                NSInteger area = intersection.size.width * intersection.size.height;
                if (area > 5000){
                    // add image
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                    imageView.tag = 200+i; // tag each image view
                
                    // reference: http://stackoverflow.com/questions/6325849/how-to-test-for-an-empty-uiimageview
                    if ([[self.gridTracker objectAtIndex:(i-1)] isEqual:@"0"]){
                        imageView.image = [UIImage imageNamed:@"X"];
                        [[self.view viewWithTag:i] addSubview:imageView];
                        [self successX];
                        self.moveCount++;
                        [self.gridTracker replaceObjectAtIndex:(i-1) withObject:@"X"];
                        [self toggleTurn];
                        NSLog(@"Placed piece at: %d", i);
                        NSLog(@"Move count: %ld", (long)self.moveCount);
                    } else {
                        NSLog(@"There's already a piece there!");
                        [self resetX];
                    }
                } else {
                    [self resetX];
                }
            }
            
            if (CGRectIntersectsRect(self.oView.frame, [self.view viewWithTag:i].frame)) {
                // check the area of overlap (must be >5000 to continue)
                // this is to ensure that only one frame is filled (adjacent ones aren't affected)
                CGRect intersection = CGRectIntersection(self.oView.frame, [self.view viewWithTag:i].frame);
                NSInteger area = intersection.size.width * intersection.size.height;
                if (area > 5000){
                
                    // add image
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                    imageView.tag = 200+i;
                
                    // reference: http://stackoverflow.com/questions/6325849/how-to-test-for-an-empty-uiimageview
                    if ([[self.gridTracker objectAtIndex:(i-1)] isEqual:@"0"]){
                        imageView.image = [UIImage imageNamed:@"O"];
                        [[self.view viewWithTag:i] addSubview:imageView];
                        [self successO];
                        self.moveCount++;
                        [self.gridTracker replaceObjectAtIndex:(i-1) withObject:@"O"];
                        [self toggleTurn];
                        NSLog(@"Move count: %ld", (long)self.moveCount);
                    } else {
                        NSLog(@"There's already a piece there!");
                        [self resetO];
                    }
                } else {
                    [self resetO];
                }
            }
        }
    }
    [self checkForWin];
    if ((self.moveCount == 9 && self.initialPlayer == 0)||(self.moveCount == 10 && self.initialPlayer == 1)){
        [self resetBoard];
    }
}

- (IBAction)closeInfo:(id)sender {
    self.infoView.hidden = YES;
}

// toggle between turns
- (void)toggleTurn {
    if (self.moveCount%2==0) {
        self.xView.alpha = 1;
        self.xView.userInteractionEnabled = true;
        self.oView.alpha = 0.5;
        self.oView.userInteractionEnabled = false;
        
        // animation to indicate turn
        [UIView animateWithDuration:2.0 animations:^{
            self.xView.transform = CGAffineTransformScale(self.xView.transform, 2, 2);
            self.xView.transform = CGAffineTransformScale(self.xView.transform, 0.5, 0.5);
        }];
        
    } else {
        self.xView.alpha = 0.5;
        self.xView.userInteractionEnabled = false;
        self.oView.alpha = 1;
        self.oView.userInteractionEnabled = true;
        
        // animation to indicate turn
        [UIView animateWithDuration:2.0 animations:^{
            self.oView.transform = CGAffineTransformScale(self.oView.transform, 2, 2);
            self.oView.transform = CGAffineTransformScale(self.oView.transform, 0.5, 0.5);
        }];
    }
}

- (void)successX {
    [UIView animateWithDuration:0 animations:^{
        self.xView.center = CGPointMake(66,600);
    }];
}

- (void)successO {
    [UIView animateWithDuration:0 animations:^{
        self.oView.center = CGPointMake(309,597);
    }];
}

// "return" X into original position
- (void)resetX {
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.xView.center = CGPointMake(66,600);
                     }
                     completion:^(BOOL complete){
                         NSLog(@"RESET PIECE");
                     }
     ];
}

// "return" O into original position
- (void)resetO {
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.oView.center = CGPointMake(309,597);
                     }
                     completion:^(BOOL complete){
                         NSLog(@"RESET PIECE");
                     }
     ];
}

- (void)checkForWin {
    NSLog(@"Check for win is working");
    
    for (int i=0; i<10; i++){
        NSLog(@"Here's what is recorded in grid tracker at %d: %@", i, [self.gridTracker objectAtIndex:i]);
        
        if ([[self.gridTracker objectAtIndex:i] isEqual:@"X"]){
            [self.xArray addObject:[NSString stringWithFormat:@"%d",i]]; // add index to X array
        }
        if ([[self.gridTracker objectAtIndex:i] isEqual:@"O"]){
            [self.oArray addObject:[NSString stringWithFormat:@"%d",i]]; // add index to O array
        }
    }
    
    if (([self.xArray containsObject:@"0"] && [self.xArray containsObject:@"1"] && [self.xArray containsObject:@"2"]) ||
        ([self.xArray containsObject:@"3"] && [self.xArray containsObject:@"4"] && [self.xArray containsObject:@"5"]) ||
        ([self.xArray containsObject:@"6"] && [self.xArray containsObject:@"7"] && [self.xArray containsObject:@"8"]) ||
        ([self.xArray containsObject:@"0"] && [self.xArray containsObject:@"3"] && [self.xArray containsObject:@"6"]) ||
        ([self.xArray containsObject:@"1"] && [self.xArray containsObject:@"4"] && [self.xArray containsObject:@"7"]) ||
        ([self.xArray containsObject:@"2"] && [self.xArray containsObject:@"5"] && [self.xArray containsObject:@"8"]) ||
        ([self.xArray containsObject:@"0"] && [self.xArray containsObject:@"4"] && [self.xArray containsObject:@"8"]) ||
        ([self.xArray containsObject:@"2"] && [self.xArray containsObject:@"4"] && [self.xArray containsObject:@"6"])) {
        NSLog(@"X WINS!");
        [self resetBoard];
    }
    
    if (([self.oArray containsObject:@"0"] && [self.oArray containsObject:@"1"] && [self.oArray containsObject:@"2"]) ||
        ([self.oArray containsObject:@"3"] && [self.oArray containsObject:@"4"] && [self.oArray containsObject:@"5"]) ||
        ([self.oArray containsObject:@"6"] && [self.oArray containsObject:@"7"] && [self.oArray containsObject:@"8"]) ||
        ([self.oArray containsObject:@"0"] && [self.oArray containsObject:@"3"] && [self.oArray containsObject:@"6"]) ||
        ([self.oArray containsObject:@"1"] && [self.oArray containsObject:@"4"] && [self.oArray containsObject:@"7"]) ||
        ([self.oArray containsObject:@"2"] && [self.oArray containsObject:@"5"] && [self.oArray containsObject:@"8"]) ||
        ([self.oArray containsObject:@"0"] && [self.oArray containsObject:@"4"] && [self.oArray containsObject:@"8"]) ||
        ([self.oArray containsObject:@"2"] && [self.oArray containsObject:@"4"] && [self.oArray containsObject:@"6"])) {
        NSLog(@"O WINS!");
        [self resetBoard];
    }
    
    if (self.moveCount==9){
        NSLog(@"TIE!");
    }
}

- (void)resetBoard {
    NSLog(@"RESET BOARD");
    
    if (self.initialPlayer == 0) {
        self.moveCount = 1; // O begins
        self.initialPlayer = 1;
    } else {
        self.moveCount = 0; // X begins
        self.initialPlayer = 0;
    }
    
    for (int i=1; i<10; i++){
        // create a copy of all UIViews in grid to animate off screen
        UIView *copy = [[UIView alloc] initWithFrame:CGRectMake([self.view viewWithTag:i].frame.origin.x, [self.view viewWithTag:i].frame.origin.y, 100, 100)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        [self.view addSubview:copy];
        
        for (UIImageView *subview in [[self.view viewWithTag:i] subviews]) {
            imageView.image = subview.image;
        }
        [copy addSubview:imageView];
        
        [UIView animateWithDuration:2.0 animations:^{
            copy.center = CGPointMake(500,500);
        }completion:^(BOOL complete){
            NSLog(@"FLY AWAY");
        }];
    }
    
    for (int i=1; i<10; i++){
        for (UIImageView *subview in [[self.view viewWithTag:i] subviews]) {
                [subview removeFromSuperview];
        }
    }
    
    for (int i=0; i<10; i++){
        [self.gridTracker replaceObjectAtIndex:i withObject:@"0"]; // reinitialize
    }
    
    [self.xArray removeAllObjects];
    [self.xArray addObject:@"10"];
    
    [self.oArray removeAllObjects];
    [self.oArray addObject:@"10"];
}

// NOTE: NOT WORKING PROPERLY
- (void)resizeToFitSubviews {
    float w = 0;
    float h = 0;
    
    float fw = self.infoView.frame.origin.x + self.infoText.frame.size.width;
    float fh = self.infoView.frame.origin.y + self.infoTitle.frame.size.height + self.infoText.frame.size.height + self.infoDismiss.frame.size.height;
    w = MAX(fw, w);
    h = MAX(fh, h);
    
    [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x, self.infoView.frame.origin.y, w, h)];
}

@end
