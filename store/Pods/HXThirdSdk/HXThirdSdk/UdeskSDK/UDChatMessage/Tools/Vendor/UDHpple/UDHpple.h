//
//  TFHpple.h
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

#import "UDHppleElement.h"

@interface UDHpple : NSObject 

- (id) initWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithXMLData:(NSData *)theData;
- (id) initWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithHTMLData:(NSData *)theData;

+ (UDHpple *) hppleWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
+ (UDHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML;
+ (UDHpple *) hppleWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (UDHpple *) hppleWithXMLData:(NSData *)theData;
+ (UDHpple *) hppleWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (UDHpple *) hppleWithHTMLData:(NSData *)theData;

- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;
- (UDHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS;

@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) NSString * encoding;

@end
