//
//  Books.m
//  HelloWord
//
//  Created by 横濱 悠平 on 13/03/03.
//  Copyright (c) 2013年 横濱 悠平. All rights reserved.
//

#import "Books.h"

static Books *singleton;

@implementation Books

@synthesize items;

+(Books *)factory {
    if (!singleton) {
        [[Books alloc]init_singleton];
    }
    return singleton;
}

-(void)init_singleton{
    items = [[[BookModel alloc] init] findAll];
    singleton = self;
}

-(BookModel *)find:(int)bookId {
    for (int i=0; i<[items count]; i++) {
        if (bookId == [items[i] recodeId]) {
            return items[i];
        }
    }
    return nil;
}

-(void)rehash:(NSMutableArray *)newBooks{
    //現在のものを削除
    for (int i=0; i<[items count]; i++){
        BookModel *oldBook = items[i];
        for (int w=0; w<[oldBook.words count]; w++) {
            WordModel *oldWm = oldBook.words[w];
            [oldWm destroy];
        }
        [oldBook destroy];
    }
    
    for (int i=0; i<[newBooks count]; i++){
        BookModel *book = (BookModel *)newBooks[i];
        int bookId = [book create];
        for (int iw=0; iw<[book.words count]; iw++) {
            WordModel *wm = book.words[iw];
            wm.bookId = bookId;
            [wm create];
        }
    }
    items = [[[BookModel alloc]init]findAll];
}

@end
