/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childbrowser;

import javax.microedition.io.InputConnection;

import net.rim.device.api.browser.field2.BrowserField;
import net.rim.device.api.browser.field2.BrowserFieldConfig;
import net.rim.device.api.browser.field2.BrowserFieldHistory;
import net.rim.device.api.browser.field2.BrowserFieldRequest;
import net.rim.device.api.browser.field2.ProtocolController;
import net.rim.device.api.system.Bitmap;
import net.rim.device.api.ui.Color;
import net.rim.device.api.ui.Field;
import net.rim.device.api.ui.Font;
import net.rim.device.api.ui.UiApplication;
import net.rim.device.api.ui.component.BitmapField;
import net.rim.device.api.ui.container.HorizontalFieldManager;
import net.rim.device.api.ui.container.VerticalFieldManager;
import net.rim.device.api.ui.decor.BackgroundFactory;

import com.phonegap.util.Logger;

/**
 * Implements a navigation bar for the custom browser. Provides UI elements to
 * navigation back or forward in history, to stop or refresh loading and a field
 * to display and navigate to a URL.
 */
public class NavigationBar extends HorizontalFieldManager {
    // Images used in the navigation bar. Must exist in the compiled
    // application.
    private final static String BUTTON_BACK = "icon_arrow_left.png";
    private final static String BUTTON_FORWARD = "icon_arrow_right.png";
    private final static String BUTTON_REFRESH = "icon_refresh.png";
    private final static String BUTTON_STOP = "icon_stop.png";

    private BrowserField browserField = null;

    /** Tracks whether the full navigation bar is displayed. */
    private boolean fullNav = false;

    /** The fields and their order in the navigation bar. */
    private Field[] navFields = new Field[4];

    private BitmapField refreshField = null;
    private BitmapField stopField = null;
    private UiApplication uiApp = UiApplication.getUiApplication();
    private URLLabelField urlLabel = null;

    /**
     * Create a HorizontalFieldManager with no scrolling and a black background.
     *
     * @param browserField
     */
    NavigationBar(BrowserField browserField) {
        super(NO_HORIZONTAL_SCROLL | NO_VERTICAL_SCROLL | NON_FOCUSABLE);
        setBackground(BackgroundFactory.createSolidBackground(Color.BLACK));
        this.browserField = browserField;
    }

    /**
     * Initialize the navigation bar. Load the images used in the UI and
     * configure the layout.
     *
     * @return true if init succeeds, otherwise false.
     */
    boolean init() {
        final long style = Field.FIELD_VCENTER | Field.FOCUSABLE;

        // Load a custom protocol controller which provides the ability to
        // stop a load of a web page.
        final CustomProtocolController controller = new CustomProtocolController(
                browserField);
        browserField.getConfig().setProperty(BrowserFieldConfig.CONTROLLER,
                controller);

        // Load the images used in the navigation bar.
        Bitmap back = Bitmap.getBitmapResource(BUTTON_BACK);
        Bitmap forward = Bitmap.getBitmapResource(BUTTON_FORWARD);
        Bitmap stop = Bitmap.getBitmapResource(BUTTON_STOP);
        Bitmap refresh = Bitmap.getBitmapResource(BUTTON_REFRESH);
        if (back == null || forward == null || stop == null || refresh == null) {
            Logger.log(ChildBrowser.TAG
                    + "Failed to load navigation bar image.\n" + BUTTON_BACK
                    + ": " + back + "\n" + BUTTON_FORWARD + ": " + forward
                    + "\n" + BUTTON_STOP + ": " + stop + "\n" + BUTTON_REFRESH
                    + ": " + refresh);
            return false;
        }

        // Setup the back button.
        BitmapField backField = new BitmapField(back, style) {
            protected boolean navigationClick(int status, int time) {
                goBack();
                return true;
            }
        };
        backField.setSpace(5, 3);
        backField.setMargin(2, 2, 2, 2);

        // Setup the forward button.
        BitmapField forwardField = new BitmapField(forward, style) {
            protected boolean navigationClick(int status, int time) {
                goForward();
                return true;
            }
        };
        forwardField.setSpace(5, 3);
        forwardField.setMargin(2, 0, 2, 2);

        // Setup the stop button.
        stopField = new BitmapField(stop, style) {
            protected boolean navigationClick(int status, int time) {
                controller.stopLoad();
                setRefreshActive(true);
                return true;
            }
        };
        stopField.setSpace(5, 3);
        stopField.setMargin(2, 2, 2, 0);

        // Setup the refresh button.
        refreshField = new BitmapField(refresh, style) {
            protected boolean navigationClick(int status, int time) {
                setRefreshActive(false);
                uiApp.invokeLater(new Runnable() {
                    public void run() {
                        browserField.setFocus();
                        browserField.refresh();
                    }
                });
                return true;
            }
        };
        refreshField.setSpace(5, 3);
        refreshField.setMargin(2, 2, 2, 0);

        // Calculate the total width used by the buttons (images + padding +
        // margin) in order to determine the text field size.
        int buttonWidth = back.getWidth() + forward.getWidth() + refresh.getWidth()
                + 50;

        // Setup the URL label text field.
        urlLabel = new URLLabelField(this, buttonWidth);
        urlLabel.setBackground(BackgroundFactory
                .createSolidBackground(Color.WHITE));
        urlLabel.setFont(Font.getDefault());
        urlLabel.setPadding(5, 5, 5, 5);
        urlLabel.setMargin(5, 2, 5, 2);

        // Update the field array with the initial setup for the navigation bar.
        navFields[0] = backField;
        navFields[1] = forwardField;
        navFields[2] = urlLabel;
        navFields[3] = refreshField;

        showFullNav(true);

        return true;
    }

    /**
     * Initiates a browser request to a specified URL and updates the navigation
     * bar to the proper state for browser loading.
     *
     * @param address
     *            the URL to load.
     */
    void navigate(final String address) {
        if (browserField != null && address != null && address.length() > 0) {
            final String url = setURL(address);

            setRefreshActive(false);
            showFullNav(true);
            uiApp.invokeLater(new Runnable() {
                public void run() {
                    try {
                        browserField.setFocus();
                        browserField.requestContent(url);
                    } catch (Exception e) {
                        Logger.log("Caught exception navigating to: " + address
                                + " message: " + e.getMessage());
                    }
                }
            });
        }
    }

    /**
     * Activates either the refresh or close button in the navigation bar.
     *
     * @param refresh
     *            if true activate refresh, otherwise activate close.
     */
    synchronized void setRefreshActive(boolean refresh) {
        navFields[3] = refresh ? refreshField : stopField;

        // If the full navigation bar is currently displayed, make sure the
        // correct button is active.
        if (fullNav && getFieldCount() == 4) {
            if ((refresh && getField(3) == stopField)
                    || (!refresh && getField(3) == refreshField)) {
                final Field deleteField = refresh ? stopField : refreshField;
                final Field showField = refresh ? refreshField : stopField;

                uiApp.invokeLater(new Runnable() {
                    public void run() {
                        replace(deleteField, showField);
                    }
                });
            }
        }
    }

    /**
     * Sets the URL to display in the navigation bar URL label field.
     *
     * @param url
     *            the URL to display.
     * @return the URL.
     */
    String setURL(String url) {
        if (url != null && url.length() > 0) {
            if (!url.startsWith("http")) {
                url = "http://" + url;
            }
        }
        final String address = url;
        uiApp.invokeLater(new Runnable() {
            public void run() {
                urlLabel.setText(address);
            }
        });

        return url;
    }

    /**
     * Switches the navigation bar to either the full navigation bar or a
     * navigation bar for URL editing.
     *
     * @param showFull
     *            if true show full navigation bar otherwise show URL edit bar.
     */
    synchronized void showFullNav(boolean showFull) {
        if (showFull && !fullNav) {
            uiApp.invokeLater(new Runnable() {
                public void run() {
                    deleteAll();
                    addAll(navFields);
                    invalidate();
                    fullNav = true;
                }
            });
        } else if (!showFull && fullNav) {
            uiApp.invokeLater(new Runnable() {
                public void run() {
                    deleteAll();

                    // Use a VerticalFieldManager to restrict vertical scrolling
                    // but allow horizontal scrolling of the text field.
                    VerticalFieldManager vfm = new VerticalFieldManager(
                            FIELD_VCENTER | NO_VERTICAL_SCROLL
                                    | HORIZONTAL_SCROLL);
                    URLEditField urlEdit = new URLEditField(NavigationBar.this);
                    urlEdit.setText(urlLabel.getText());
                    vfm.add(urlEdit);

                    add(vfm);
                    invalidate();
                    urlEdit.setFocus();
                    fullNav = false;
                }
            });
        }
    }

    /**
     * Checks to see if it is possible to go back one page in history, then does
     * so.
     */
    private void goBack() {
        if (browserField != null) {
            BrowserFieldHistory history = browserField.getHistory();
            if (history != null && history.canGoBack()) {
                setRefreshActive(false);
                uiApp.invokeLater(new Runnable() {
                    public void run() {
                        browserField.setFocus();
                        browserField.back();
                    }
                });
            }
        }
    }

    /**
     * Checks to see if it is possible to go forward one page in history, then
     * does so.
     */
    private void goForward() {
        if (browserField != null) {
            BrowserFieldHistory history = browserField.getHistory();
            if (history != null && history.canGoForward()) {
                setRefreshActive(false);
                uiApp.invokeLater(new Runnable() {
                    public void run() {
                        browserField.setFocus();
                        browserField.forward();
                    }
                });
            }
        }
    }

    /**
     * This is a very simple override of the ProtocolController which provides a
     * hack to stop a load of a web page.
     */
    private class CustomProtocolController extends ProtocolController {
        private boolean stop = false;

        public CustomProtocolController(BrowserField browserField) {
            super(browserField);
        }

        /**
         * @see net.rim.device.api.browser.field2.ProtocolController#handleNavigationRequest(net.rim.device.api.browser.field2.BrowserFieldRequest)
         */
        public void handleNavigationRequest(BrowserFieldRequest request)
                throws Exception {
            // A new navigation request resets the stop variable.
            stop = false;
            super.handleNavigationRequest(request);
        }

        /**
         * @see net.rim.device.api.browser.field2.ProtocolController#handleResourceRequest(net.rim.device.api.browser.field2.BrowserFieldRequest)
         */
        public InputConnection handleResourceRequest(BrowserFieldRequest request)
                throws Exception {
            // If a stop request was issued just return null so the content
            // isn't downloaded.
            if (stop) {
                return null;
            } else {
                return super.handleResourceRequest(request);
            }
        }

        /**
         * Stop a navigation request.
         */
        void stopLoad() {
            stop = true;
        }
    }
}
