/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childbrowser;

import net.rim.device.api.system.Characters;
import net.rim.device.api.system.Display;
import net.rim.device.api.ui.Color;
import net.rim.device.api.ui.Font;
import net.rim.device.api.ui.Keypad;
import net.rim.device.api.ui.UiApplication;
import net.rim.device.api.ui.VirtualKeyboard;
import net.rim.device.api.ui.component.BasicEditField;
import net.rim.device.api.ui.decor.BackgroundFactory;

/**
 * A BasicEditField which manages display of the virtual keyboard when required
 * and provides native behavior for text selection and input.
 */
public class URLEditField extends BasicEditField {
    private NavigationBar navBar;
    private boolean selectAll = false;
    private final int PADDING = 20;

    /**
     * Create a one line BasicEditField with limited character input, no auto
     * correction and a white background.
     *
     * @param navigation
     * @param width
     */
    URLEditField(NavigationBar navigation) {
        super(NO_NEWLINE | FOCUSABLE | EDITABLE | FILTER_URL);
        navBar = navigation;

        setBackground(BackgroundFactory.createSolidBackground(Color.WHITE));
        setFont(Font.getDefault());
        setPadding(5, 5, 5, 5);
        setMargin(5, 5, 5, 5);
    }

    /**
     * Override the enter key to initiate a navigation and override the back key
     * to clear all text selection then revert to full navigation bar.
     *
     * @see net.rim.device.api.ui.component.BasicEditField#keyChar(char, int,
     *      int)
     */
    protected boolean keyChar(char key, int status, int time) {
        if (key == Keypad.KEY_ENTER) {
            // On enter key, navigate to specified URL.
            navBar.navigate(getText());
            return true;
        } else if (key == Characters.ESCAPE) {
            // If all text is currently selected, clear selection and set cursor
            // to end of text.
            if (selectAll) {
                selectAll = false;
                select(false);
                String text = getText();
                if (text != null) {
                    setCursorPosition(text.length());
                } else {
                    setCursorPosition(0);
                }
                return true;
            } else {
                // User is backing out of URL edit, so display full navigation
                // bar.
                navBar.showFullNav(true);
                UiApplication.getUiApplication().invokeLater(new Runnable() {
                    public void run() {
                        navBar.setFocus();
                    }
                });
                return true;
            }
        }
        return super.keyChar(key, status, time);
    }

    /**
     * Adjust width to the desired width on orientation change.
     *
     * @see net.rim.device.api.ui.component.BasicEditField#layout(int, int)
     */
    protected void layout(int maxWidth, int maxHeight) {
        int width = Display.getWidth() - PADDING;
        super.layout(width, maxHeight);
        setExtent(width, getPreferredHeight());
    }

    /**
     * If the user clicks the trackpad in the field, navigate to the URL
     * specified.
     *
     * @see net.rim.device.api.ui.component.TextField#navigationClick(int, int)
     */
    protected boolean navigationClick(int status, int time) {
        String text = getText();
        if (text != null && text.length() > 0) {
            navBar.navigate(text);
            return true;
        }

        return navigationClick(status, time);
    }

    /**
     * Disable text selection with the trackpad upon movement.
     *
     * @see net.rim.device.api.ui.Field#navigationMovement(int, int, int, int)
     */
    protected boolean navigationMovement(int dx, int dy, int status, int time) {
        if (isSelecting()) {
            select(false);
        }
        return super.navigationMovement(dx, dy, status, time);
    }

    /**
     * When focus is acquired, highlight all the text in the field and display
     * the virtual keyboard if it is needed.
     *
     * @see net.rim.device.api.ui.component.TextField#onFocus(int)
     */
    protected void onFocus(int direction) {
        if (!selectAll) {
            UiApplication.getUiApplication().invokeLater(new Runnable() {
                public void run() {
                    // Display the virtual keyboard if required.
                    if (VirtualKeyboard.isSupported()) {
                        VirtualKeyboard vk = UiApplication.getUiApplication()
                                .getActiveScreen().getVirtualKeyboard();
                        if (vk != null
                                && vk.getVisibility() == VirtualKeyboard.HIDE) {
                            vk.setVisibility(VirtualKeyboard.SHOW);
                        }
                    }

                    // Highlight all the text in the field.
                    setCursorPosition(0);
                    select(true);
                    String text = getText();
                    if (text != null && text.length() > 0) {
                        moveFocus(text.length(), 0, 0);
                    }
                    selectAll = true;
                }
            });
            return;
        } else {
            // On refocus, use default behavior.
            selectAll = false;
        }

        super.onFocus(direction);
    }

    /**
     * When focus is lost, hide the virtual keyboard if it is shown.
     *
     * @see net.rim.device.api.ui.component.BasicEditField#onUnfocus()
     */
    protected void onUnfocus() {
        if (VirtualKeyboard.isSupported()) {
            VirtualKeyboard vk = UiApplication.getUiApplication()
                    .getActiveScreen().getVirtualKeyboard();
            if (vk != null && vk.getVisibility() == VirtualKeyboard.SHOW) {
                vk.setVisibility(VirtualKeyboard.HIDE);
            }
        }
        selectAll = false;
        super.onUnfocus();
    }

}
