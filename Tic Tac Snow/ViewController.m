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
    
    self.moveCount = 0; // initialize move count (use to toggle between turns)
    
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
        // NOTE TO SELF: NEED TO FIX WHEN INTERSECTING MORE THAN ONE VIEW FRAME IN GRID
        for (int i=1; i<10; i++){
            if (CGRectIntersectsRect(self.xView.frame, [self.view viewWithTag:i].frame)) {
                //NSLog(@"THEY'RE INTERSECTING");
                
                // add image
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                
                // reference: http://stackoverflow.com/questions/6325849/how-to-test-for-an-empty-uiimageview
                if (imageView.image == nil){
                    imageView.image = [UIImage imageNamed:@"X"];
                    [[self.view viewWithTag:i] addSubview:imageView];
                    [self resetX];
                    self.moveCount++;
                    [self toggleTurn];
                    NSLog(@"Move count: %ld", (long)self.moveCount);
                }
            }
            
            if (CGRectIntersectsRect(self.oView.frame, [self.view viewWithTag:i].frame)) {
                //NSLog(@"THEY'RE INTERSECTING");
                
                // add image
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                
                // reference: http://stackoverflow.com/questions/6325849/how-to-test-for-an-empty-uiimageview
                if (imageView.image == nil){
                    imageView.image = [UIImage imageNamed:@"O"];
                    [[self.view viewWithTag:i] addSubview:imageView];
                    [self resetO];
                    self.moveCount++;
                    [self toggleTurn];
                    NSLog(@"Move count: %ld", (long)self.moveCount);
                }
            }
        }
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
    } else {
        self.xView.alpha = 0.5;
        self.xView.userInteractionEnabled = false;
        self.oView.alpha = 1;
        self.oView.userInteractionEnabled = true;
    }
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
