//
//  XOImageView.m
//  Tic Tac Snow
//
//  Created by helenwang on 2/6/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "XOImageView.h"
@import AudioToolbox;
@import AVFoundation;

@implementation XOImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches began: %@", event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches moved: %@", event);
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"woosh"] ofType:@"mp3"];
    _soundEffect = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFile] error:nil];
    [_soundEffect play];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches ended: %@", event);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches cancelled: %@", event);
}

@end
