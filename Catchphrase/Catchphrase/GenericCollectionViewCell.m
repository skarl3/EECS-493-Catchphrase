//
//  GenericCollectionViewCell.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "GenericCollectionViewCell.h"
#import "Constants.h"

@implementation GenericCollectionViewCell

- (void) awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];//[[Constants instance] EXTRA_LIGHT_BG];
    self.layer.cornerRadius = [Constants borderRadius];
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[Constants instance] EXTRA_LIGHT_TEXT].CGColor;
    self.layer.borderWidth = [Constants thinLineWidth];
    
    self.mainLabel.font = [UIFont fontWithName:[Constants lightFont]
                                          size:[Constants titleTextSize]];
    self.mainLabel.textColor = [[Constants instance] EXTRA_LIGHT_TEXT];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ? [[Constants instance] EXTRA_LIGHT_BG] : [UIColor clearColor];
}

@end
