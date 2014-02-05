//
//  ReadOnlyTextView.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/17/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "ReadOnlyTextView.h"

@implementation ReadOnlyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
