/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childbrowser;

import net.rim.device.api.system.Display;
import net.rim.device.api.ui.Color;
import net.rim.device.api.ui.Graphics;
import net.rim.device.api.ui.component.LabelField;
import net.rim.device.api.ui.decor.BackgroundFactory;

/**
 * Label field used to display the current web page URL. Draws a highlight of
 * the field on focus and displays an editable text field when clicked.
 */
public class URLLabelField extends LabelField {
    private NavigationBar parentManager;
    private int padding;

    /**
     * Creates a label field of a defined size with ellipsis for long text.
     *
     * @param manager
     * @param padding
     */
    URLLabelField(NavigationBar manager, int padding) {
        super("", LabelField.ELLIPSIS | LabelField.FIELD_LEFT
                | LabelField.FIELD_VCENTER | LabelField.USE_ALL_WIDTH
                | LabelField.FOCUSABLE);
        this.padding = padding;
        parentManager = manager;
    }

    /**
     * Draws a light blue background across entire text label when element is
     * focussed.
     *
     * @see net.rim.device.api.ui.Field#drawFocus(net.rim.device.api.ui.Graphics,
     *      boolean)
     */
    protected void drawFocus(Graphics graphics, boolean on) {
        setBackground(BackgroundFactory.createSolidBackground(Color.LIGHTBLUE));
        invalidate();
    }

    /**
     * Enforces the custom width for the layout.
     *
     * @see net.rim.device.api.ui.component.LabelField#layout(int, int)
     */
    protected void layout(int maxWidth, int maxHeight) {
        int width = Display.getWidth() - padding;
        super.layout(width, maxHeight);
        setExtent(width, getPreferredHeight());
    }

    /**
     * Shows the editable text field when the label field is clicked.
     *
     * @see net.rim.device.api.ui.Field#navigationClick(int, int)
     */
    protected boolean navigationClick(int status, int time) {
        parentManager.showFullNav(false);
        return true;
    }

    /**
     * Resets the background color on unfocus.
     *
     * @see net.rim.device.api.ui.Field#onUnfocus()
     */
    protected void onUnfocus() {
        setBackground(BackgroundFactory.createSolidBackground(Color.WHITE));
        invalidate();
        super.onUnfocus();
    }
}
