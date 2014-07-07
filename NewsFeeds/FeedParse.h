//
//  FeedParse.h
//  NewsFeeds
//
//  Created by Vineeth on 18/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FeedParseDelegate;
@interface FeedParse : NSObject<NSXMLParserDelegate>
{
//    id <FeedParseDelegate> mydelegate;
    NSMutableDictionary *item;
    NSMutableString *title,*content,*disc,*date,*thumbnailUrl;
    NSString *element;
    NSXMLParser *parser;
    FeedParse *feedobject;
}
-(void)startparse:(NSURL *)url;
@property (strong) id  <FeedParseDelegate> mydelegate;
@property (nonatomic,retain) NSMutableArray *feeds;
@end

@protocol FeedParseDelegate
-(void)passfeeds:(NSDictionary *)passeddict;
@end



