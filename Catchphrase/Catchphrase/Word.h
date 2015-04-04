//
//  Word.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 4/3/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

+ (id) wordManager;

- (NSString*) anyWord;
- (NSString*) wordFromEasy:(BOOL)easy
                 andMedium:(BOOL)medium
                   andHard:(BOOL)hard;

@end
