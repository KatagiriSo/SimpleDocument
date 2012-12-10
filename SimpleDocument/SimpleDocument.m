//
//  SimpleDocument.m
//  SimpleDocument
//
//  Created by 片桐奏羽 on 12/12/07.
//  Copyright (c) 2012年 片桐奏羽. All rights reserved.
//

#import "SimpleDocument.h"

@implementation SimpleDocument


#pragma mark -

//ロード
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(@"typeName:%@",typeName);
    NSData *data = (NSData *)contents;
    
    if (data.length == 0) {
        NSLog(@"nothing");
        self.text = @"";
        return YES;
    }
    
    self.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!self.text) {
        NSLog(@"[Error]loadFromContents initWithData:%@",data);
        return NO;
    }
    
    return YES;
}

//セーブ
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return [(self.text)?:@"" dataUsingEncoding:NSUTF8StringEncoding];
}

@end
