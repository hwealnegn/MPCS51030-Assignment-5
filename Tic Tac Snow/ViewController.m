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
    
    /*infoView *instructions = [[infoView alloc] init];
    instructions.title.text = @"HOW TO PLAY";
    instructions.info.text = @"This is a test hello hello";
    [instructions.dismiss setTitle:@"GOT IT" forState:UIControlStateNormal];*/
    
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
    
    //[self resizeToFitSubviews];
    
    [self.infoView sizeToFit];
    
    
    //[self.infoDismiss setTitle:@"OK" forState:UIControlStateNormal];
    [self.infoDismiss addTarget:self action:@selector(closeInfo:) forControlEvents:UIControlEventTouchDown];
}

// reference: http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // when finger is lifted
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended.");
        
        // determine if view frames are intersecting
        for (int i=1; i<10; i++){
            if (CGRectIntersectsRect(self.xView.frame, [self.view viewWithTag:i].frame)) {
                // check the area of overlap (must be >5000 to continue)
                // this is to ensure that only one frame is filled (adjacent ones aren't affected)
                CGRect intersection = CGRectIntersection(self.xView.frame, [self.view viewWithTag:i].frame);
                NSInteger area = intersection.size.width * intersection.size.height;
                if (area > 5000){
                    // add image
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                    imageView.tag = 200+i; // tag each image view
                
                    // reference: http://stackoverflow.com/questions/6325849/how-to-test-for-an-empty-uiimageview
                    //if (imageView.image == nil){ // can only place piece if there isn't one there already (not working)
                    //if ([self.view viewWithTag:i] == nil){
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
    
    //NSMutableArray *xArray; // keep track of where X's are
    //NSMutableArray *oArray; // keep track of where O's are
    
    for (int i=0; i<10; i++){
        NSLog(@"Here's what is recorded in grid tracker at %d: %@", i, [self.gridTracker objectAtIndex:i]);
        
        if ([[self.gridTracker objectAtIndex:i] isEqual:@"X"]){
            NSLog(@"MATCH!");
            //[xArray addObject:[NSNumber numberWithInt:i]]; // add index to X array
            [self.xArray addObject:[NSString stringWithFormat:@"%d",i]];
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
    }
    
    if (self.moveCount==9){
        NSLog(@"TIE!");
    }
}

// NEED TO FIGURE THIS OUT
- (void)resetBoard {
    /*for (int i=0; i<10; i++){
        for (UIView *view in [self.view viewWithTag:i]){
            [view removeFromSuperview];
        }
    }*/
}

// NOTE: NOT WORKING PROPERLY
- (void)resizeToFitSubviews {
    float w = 0;
    float h = 0;
    
    float fw = self.infoView.frame.origin.x + self.infoText.frame.size.width;
    float fh = self.infoView.frame.origin.y + self.infoText.frame.size.height + self.infoDismiss.frame.size.height;
    w = MAX(fw, w);
    h = MAX(fh, h);
    
    [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x, self.infoView.frame.origin.y, w, h)];
}

@end
