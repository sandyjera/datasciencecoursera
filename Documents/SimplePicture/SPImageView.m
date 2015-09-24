//
//  SPImageView.m
//  SimplePicture
//
//  Created by Scott Stevenson on 9/28/07.
//
//  Personal site: http://theocacao.com/
//  Post for this sample: http://theocacao.com/document.page/497
//
//  The code in this project is intended to be used as a learning
//  tool for Cocoa programmers. You may freely use the code in
//  your own programs, but please do not use the code as-is in
//  other tutorials.

#import "SPImageView.h"


@implementation SPImageView

- (void)drawRect:(NSRect)rect
{   
    // draw our background color
	[[NSColor grayColor] set];
	NSRectFill(rect);

    // enabling this can result in better image quality, but
    // potentially much, much slower for large images    
    /* [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh]; */

    // now allow NSImageView to draw the image itself
    [super drawRect:rect];
}

@end
