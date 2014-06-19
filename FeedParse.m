//
//  FeedParse.m
//  NewsFeeds
//
//  Created by qbadmin on 18/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import "FeedParse.h"



@implementation FeedParse
-(NSMutableArray *)startparse:(NSURL *)url
{
    feeds=[[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    return feeds;
}
- (void)parser:(NSXMLParser *)par didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"])
    {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        content = [[NSMutableString alloc] init];
        disc    = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
        
    }
    
    if([element isEqualToString:@"media:thumbnail"])
    {
        thumbnailUrl = [attributeDict valueForKey:@"url"];
    }
    else if ([element isEqualToString:@"media:content"])
    {
        thumbnailUrl = [attributeDict valueForKey:@"url"];
        
    }
    
}


- (void)parser:(NSXMLParser *)par didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:content forKey:@"content:encoded"];
        [item setObject:thumbnailUrl forKey:@"image"];
        [item setObject:disc forKey:@"description"];
        [item setObject:date forKey:@"pubDate"];
        [feeds addObject:[item copy]];
        if(feeds.count==50)
        {
            [parser abortParsing];
        }

    }
}

- (void)parser:(NSXMLParser *)par foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"content:encoded"]) {
        [content appendString:string];
    }
    else if ([element isEqualToString:@"description"]){
        [disc appendString:string];
    }
    else if ([element isEqualToString:@"pubDate"])
    {
        [date appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)par {
    
}

@end
