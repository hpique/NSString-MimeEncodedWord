//
//  NSString+MimeEncodedWord.h
//  NSString+MimeEncodedWord
//
//  Created by Hermes Pique on 12/24/12.
//  Copyright (c) 2012 Hermes Pique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MimeEncodedWord)

+ (NSString*) stringWithMimeEncodedWord:(NSString*)word;

- (BOOL) isMimeEncodedWord;

@end
