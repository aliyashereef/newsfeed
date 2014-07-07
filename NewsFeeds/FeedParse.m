//
//  FeedParse.m
//  NewsFeeds
//
//  Created by Vineeth on 18/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import "FeedParse.h"



@implementation FeedParse
{
    NSMutableArray *allItems;
    //This variable will be used to build up the data coming back from NSURLConnection
    NSMutableData *receivedData;
    //This allows the creating object to know when parsing has completed
    BOOL parsing;
    NSURL *parseurl;
}

-(void)startparse:(NSURL *)url
{
    parseurl=url;
    parsing = true;
    //Initialise the receivedData object
    receivedData = [[NSMutableData alloc] init];
    //Create the connection with the string URL and kick it off
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [urlConnection start];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Reset the data as this could be fired if a redirect or other response occurs
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Append the received data each time this is called
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Start the XML parser with the delegate pointing at the current object
    self.feeds=[[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithData:receivedData];
    [parser setDelegate:self];
    [parser parse];
    parsing = false;
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
        [self.feeds addObject:[item copy]];
        if(self.feeds.count==50)
        {
            [parser abortParsing];
            NSDictionary *parsingdictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.feeds,@"feeds",parseurl,@"url", nil];
            [[self mydelegate]  passfeeds:parsingdictionary];
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parsing finished");
}

@end
