//
//  FeedParse.h
//  NewsFeeds
//
//  Created by qbadmin on 18/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedParse : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title,*content,*disc,*date,*thumbnailUrl;
    NSString *element;
    NSXMLParser *parser;
}
-(NSMutableArray *)startparse:(NSURL *)url;
@end
