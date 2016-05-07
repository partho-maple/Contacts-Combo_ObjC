//
//  Base64.h
//  iColgate
//
//  Created by Altynbek Usenbekov on 9/7/10.
//  Copyright 2010 MagiClick. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Base64) 

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encodeing;
- (NSString *)base64EncodeingWithLineLength:(unsigned int) lineLength;

@end