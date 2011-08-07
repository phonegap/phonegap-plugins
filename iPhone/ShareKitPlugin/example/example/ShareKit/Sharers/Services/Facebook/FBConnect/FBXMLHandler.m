/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#import "FBXMLHandler.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBXMLHandler

@synthesize rootObject = _rootObject, rootName = _rootName, parseError = _parseError;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (NSString*)topName {
  return [_nameStack lastObject];
}

- (id)topObject:(BOOL)create {
  id object = [_stack objectAtIndex:_stack.count-1];
  if (object == [NSNull null] && create) {
    object = [NSMutableDictionary dictionary];
    [_stack replaceObjectAtIndex:_stack.count-1 withObject:object];
  }
  return object;
}

- (id)topContainer {
  if (_stack.count < 2) {
    return nil;
  } else {
    id object = [_stack objectAtIndex:_stack.count-2];
    if (object == [NSNull null]) {
      object = [NSMutableDictionary dictionary];
      [_stack replaceObjectAtIndex:_stack.count-2 withObject:object];
    }
    return object;
  }
}

- (void)flushCharacters {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSInteger i = 0; i < _chars.length; ++i) {
    unichar c = [_chars characterAtIndex:i];
    if (![whitespace characterIsMember:c]) {
      id topContainer = self.topContainer;
      if ([topContainer isKindOfClass:[NSMutableArray class]]) {
        id object = [NSDictionary dictionaryWithObject:_chars forKey:self.topName];
        [_stack replaceObjectAtIndex:_stack.count-1 withObject:object];
      } else {
        [_stack replaceObjectAtIndex:_stack.count-1 withObject:_chars];
      }
      break;
    }
  }
  
  [_chars release];
  _chars = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    _stack = [[NSMutableArray alloc] init];
    _nameStack = [[NSMutableArray alloc] init];
    _rootObject = nil;
    _rootName = nil;
    _chars = nil;
    _parseError = nil;
  }
  return self;
}

- (void)dealloc {
  [_stack release];
  [_nameStack release];
  [_rootObject release];
  [_rootName release];
  [_chars release];
  [_parseError release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
        attributes:(NSDictionary *)attributeDict {
  [self flushCharacters];

  id object = nil;
  if ([[attributeDict objectForKey:@"list"] isEqualToString:@"true"]) {
    object = [NSMutableArray array];
  } else {
    object = [NSNull null];
  }
    
  [_stack addObject:object];
  [_nameStack addObject:elementName];
}
 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if (!_chars) {
    _chars = [string mutableCopy];
  } else {
    [_chars appendString:string];
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
        namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  [self flushCharacters];

  id object = [[[self topObject:NO] retain] autorelease];
  NSString* name = [[self.topName retain] autorelease];
  [_stack removeLastObject];
  [_nameStack removeLastObject];

  if (!_stack.count) {
    _rootObject = [object retain];
    _rootName = [name retain];
  } else {
    id topObject = [self topObject:YES];
    if ([topObject isKindOfClass:[NSMutableArray class]]) {
      [topObject addObject:object];
    } else if ([topObject isKindOfClass:[NSMutableDictionary class]]) {
      [topObject setObject:object forKey:name];
    }
  }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)error {
  _parseError = [error retain];
}

@end
