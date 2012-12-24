//
//  NSString+MimeEncodedWord.m
//  NSString+MimeEncodedWord
//
//  Created by Hermes Pique on 12/24/12.
//  Copyright (c) 2012 Hermes Pique. All rights reserved.
//

#import "NSString+MimeEncodedWord.h"
#import "QSStrings.h"

@implementation NSString (MimeEncodedWord)

+ (NSString*) stringWithMimeEncodedWord:(NSString*)word
{ // Example: =?iso-8859-1?Q?=A1Hola,_se=F1or!?=
    NSArray *components = [word componentsSeparatedByString:@"?"];
    if (components.count < 5) return nil;
    
    NSString *charset = [components objectAtIndex:1];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)charset)); // TODO: Undefined behavior when encoding is invalid
    
    NSString *encodingType = [components objectAtIndex:2];
    encodingType = [encodingType uppercaseString]; // Protection from bad email clients
    NSString *encodedText = [components objectAtIndex:3];
    if ([encodingType isEqualToString:@"Q"])
    { // quoted-printable
        encodedText = [encodedText stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        encodedText = [encodedText stringByReplacingOccurrencesOfString:@"=" withString:@"%"];
        NSString *decoded = [encodedText stringByReplacingPercentEscapesUsingEncoding:encoding];
        return decoded;
    } else if ([encodingType isEqualToString:@"B"])
    { // base64
        NSData *data = [QSStrings decodeBase64WithString:encodedText];
        NSString *decoded = [[NSString alloc] initWithData:data encoding:encoding];
        return decoded;
    } else {
        NSLog(@"%@ is not a valid encoding (must be Q or B)", encodingType);
        return nil;
    }    
}

- (BOOL) isMimeEncodedWord
{
    return [self hasPrefix:@"=?"]  && [self hasSuffix:@"?="];
}

@end
