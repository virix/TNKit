/*
 * TNToolTip.j
 *
 * Copyright (C) 2010  Antoine Mercadal <antoine.mercadal@inframonde.eu>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

@import <Foundation/Foundation.j>

@import <AppKit/CPTextField.j>
@import <AppKit/CPView.j>

@import "TNAttachedWindow.j"



/*! @ingroup TNKit
    subclass of TNAttachedWindow in order to build quick tooltip
*/
@implementation TNToolTip : TNAttachedWindow
{
    CPTextField _content;
}

/*! returns an initialized TNToolTip with string and attach it to given view
    @param aString the content of the tooltip
    @param aView the view where the tooltip will be attached
*/
+ (TNToolTip)toolTipWithString:(CPString)aString forView:(CPView)aView
{
    var mask = ([[CPBundle bundleForClass:TNToolTip] objectForInfoDictionaryKey:@"TNToolTipDefaultMask"] == @"white") ? TNAttachedWhiteWindowMask : TNAttachedBlackWindowMask,
        tooltip = [[TNToolTip alloc] initWithString:aString styleMask:mask];

    [tooltip setAlphaValue:[[CPBundle bundleForClass:TNToolTip] objectForInfoDictionaryKey:@"TNToolTipOpacity"]];
    [tooltip attachToView:aView];
    [tooltip resignMainWindow];

    return tooltip;
}

/*! returns an initialized TNToolTip with string
    @param aString the content of the tooltip
*/
- (id)initWithString:(CPString)aString styleMask:(unsigned)aStyleMask
{
    if (self = [super initWithContentRect:CPRectMake(0.0, 0.0, 200.0, 0.0) styleMask:aStyleMask])
    {
        _content = [CPTextField labelWithTitle:aString];

        var size = [aString sizeWithFont:[_content font] inWidth:200.0];

        size.height += 5;

        [_content setLineBreakMode:CPLineBreakByWordWrapping];
        [_content setFrameSize:size];
        [_content setFrameOrigin:CPPointMake(10.0, 10.0)];
        [_content setTextShadowOffset:CGSizeMake(0.0, 1.0)];
        [_content setTextColor:(_styleMask & TNAttachedWhiteWindowMask) ? [CPColor blackColor] : [CPColor whiteColor]]
        [_content setValue:(_styleMask & TNAttachedWhiteWindowMask) ? [CPColor whiteColor] : [CPColor colorWithHexString:@"5b5b5b"]  forThemeAttribute:@"text-shadow-color"];

        size.width += 40;
        size.height += 45;

        [[self contentView] addSubview:_content];
        [self setFrameSize:size];
        [self setMovableByWindowBackground:NO];
    }

    return self;
}

@end