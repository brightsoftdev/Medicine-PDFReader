//
//  PDFSearcher.h
//  TestApp
//
//  Created by Columbus 2 on 2/21/11.
//  Copyright 2011 SapnaSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFSearcher : NSObject {
    CGPDFOperatorTableRef table;
    NSMutableString *currentData;
}

@property (nonatomic, retain) NSMutableString * currentData;
-(id)init;
-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString;
-(NSString *)returnStringForPage: (CGPDFPageRef )inPage;

@end
