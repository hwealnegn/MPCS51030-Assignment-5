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
    
    // toggle between turns
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoPressed:(id)sender {
    NSLog(@"Button pressed: %ld", (long)self.moveCount);
    
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

    // determine if view frames are intersecting
    for (int i=1; i<10; i++){
        if (CGRectIntersectsRect(self.xView.frame, [self.view viewWithTag:i].frame)) {
            //NSLog(@"THEY'RE INTERSECTING");
        
            // add image
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x100.png"]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

            if (imageView.image == nil){
                imageView.image = [UIImage imageNamed:@"X"];
                [[self.view viewWithTag:i] addSubview:imageView];
            }
        }
    }

}

- (IBAction)closeInfo:(id)sender {
    self.infoView.hidden = YES;
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
