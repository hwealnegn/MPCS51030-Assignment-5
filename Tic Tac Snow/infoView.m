//
//  infoView.m
//  Tic Tac Snow
//
//  Created by helenwang on 2/6/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "infoView.h"

@implementation infoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.title.text = @"HELLO";
        self.info.text = @"This is a test.";
        [self.dismiss setTitle:@"OK" forState:UIControlStateNormal]; // reference: http://stackoverflow.com/questions/11417077/changing-uibutton-text
    }
    return self;
}

@end
