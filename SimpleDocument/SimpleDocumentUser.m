//
//  SimpleDocumentUser.m
//  SimpleDocument
//
//  Created by 片桐奏羽 on 12/12/07.
//  Copyright (c) 2012年 片桐奏羽. All rights reserved.
//

#import "SimpleDocumentUser.h"
#import "SimpleDocument.h"

@implementation SimpleDocumentUser

//ファイルが存在するか
- (BOOL)isFileExistForPathString:(NSString *)filePathStr
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:filePathStr];
    return isExist;
}

//ファイル保存先のディレクトリ取得
- (NSString *)directryStr
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
}

//ファイル名からURLStringを取得
- (NSString *)getURLStringForFileName:(NSString *)fileName
{
    //url作成
    NSString *filePathStr = [NSString stringWithFormat:@"%@/%@",self.directryStr,fileName];
    return filePathStr;
}

//ファイル名から URLを取得
- (NSURL *)getURLforFileName:(NSString *)fileName
{
    NSURL *url = [NSURL fileURLWithPath:[self getURLStringForFileName:fileName]];
    return url;
    
}

//セーブ
- (void)saveDocument:(SimpleDocument *)doc
{
    [doc saveToURL:doc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        NSLog(@"create save %d",success);
    }];
}

//ファイル名
- (NSString *)fileName
{
    return @"hoge.txt";
}

//ファイルのURL
- (NSURL *)url
{
    return [self getURLforFileName:[self fileName]];
}

//ドキュメントを開く
- (void)openDocument:(SimpleDocument *)doc
{
    [doc openWithCompletionHandler:^(BOOL success) {
        NSLog(@"open = %@",doc.text);
    }];
}

//ドキュメントを生成
- (SimpleDocument *)createDocumentForFileName:(NSString *)fileName
{
    //urlにファイルがあるか
    BOOL isExist = [self isFileExistForPathString:[self getURLStringForFileName:fileName]];
    
    //doc作成
    SimpleDocument *doc = [[SimpleDocument alloc] initWithFileURL:self.url];
    
    if (!isExist) {
        
        //テキスト入力
        doc.text = @"new text";
        
        //新規保存
        [self saveDocument:doc];
    }
    return doc;
}


//ローカルでファイルを保存する場所を取得
- (NSArray *)localDocumentPaths
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *localDocumentPaths = [fm contentsOfDirectoryAtPath:self.directryStr error:nil];
    return localDocumentPaths;
}


#pragma mark - TEST

//テスト用
- (void)test
{
    //ファイル一覧表示
    [self displayFileList];
    
    //ドキュメント生成
    SimpleDocument *doc = [self createDocumentForFileName:self.fileName];
    
    //開くもしくはリロード
    [self openDocument:doc];
    
    //テキスト入力
    doc.text = @"pokopoko";
    
    //セーブ
    [self saveDocument:doc];
    
    //閉じる
    [doc closeWithCompletionHandler:^(BOOL success) {
        NSLog(@"close %d", success);
    }];
}

//ファイルリストのログ表示
- (void)displayFileList
{
    NSLog(@"=fileName=");
    for (NSString *documentPath in self.localDocumentPaths) {
        NSString *fileName = documentPath.lastPathComponent;
        NSLog(@"%@",fileName);
    }
    NSLog(@"==========");
}


@end
