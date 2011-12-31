using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using System.Diagnostics;
using System.Runtime.Serialization;
using WP7GapClassLib.PhoneGap.UI;
using Microsoft.Phone.Shell;

namespace WP7GapClassLib.PhoneGap.Commands
{
    [DataContract]
    public class BrowserOptions
    {
        [DataMember]
        public string url;

        [DataMember]
        public bool isGeolocationEnabled;
    }

    public class ChildBrowserCommand : BaseCommand
    {

        private static WebBrowser browser;
        private static ApplicationBarIconButton backButton;
        private static ApplicationBarIconButton fwdButton;

        // Display an inderminate progress indicator
        public void showWebPage(string options)
        {
            BrowserOptions opts = JSON.JsonHelper.Deserialize<BrowserOptions>(options);

            Uri loc = new Uri(opts.url);

            Deployment.Current.Dispatcher.BeginInvoke(() =>
            {
                if (browser != null)
                {
                    browser.IsGeolocationEnabled = opts.isGeolocationEnabled;
                    browser.Navigate(loc);
                }
                else
                {
                    PhoneApplicationFrame frame = Application.Current.RootVisual as PhoneApplicationFrame;
                    if (frame != null)
                    {
                        PhoneApplicationPage page = frame.Content as PhoneApplicationPage;
                        if (page != null)
                        {
                            Grid grid = page.FindName("LayoutRoot") as Grid;
                            if (grid != null)
                            {
                                browser = new WebBrowser();
                                browser.Navigate(loc);

                                browser.LoadCompleted += new System.Windows.Navigation.LoadCompletedEventHandler(browser_LoadCompleted);

                                browser.Navigating += new EventHandler<NavigatingEventArgs>(browser_Navigating);
                                browser.NavigationFailed += new System.Windows.Navigation.NavigationFailedEventHandler(browser_NavigationFailed);
                                browser.Navigated += new EventHandler<System.Windows.Navigation.NavigationEventArgs>(browser_Navigated);
                                browser.IsScriptEnabled = true;
                                browser.IsGeolocationEnabled = opts.isGeolocationEnabled;
                                grid.Children.Add(browser);
                            }

                            ApplicationBar bar = new ApplicationBar();
                            bar.BackgroundColor = Colors.Black;
                            bar.IsMenuEnabled = false;

                            backButton = new ApplicationBarIconButton();
                            backButton.Text = "Back";
                            backButton.IconUri = new Uri("/Images/appbar.back.rest.png", UriKind.Relative);
                            backButton.Click += new EventHandler(backButton_Click);
                            backButton.IsEnabled = false;
                            bar.Buttons.Add(backButton);


                            fwdButton = new ApplicationBarIconButton();
                            fwdButton.Text = "Forward";
                            fwdButton.IconUri = new Uri("/Images/appbar.next.rest.png", UriKind.Relative);
                            fwdButton.Click += new EventHandler(fwdButton_Click);
                            fwdButton.IsEnabled = false;
                            bar.Buttons.Add(fwdButton);

                            ApplicationBarIconButton closeBtn = new ApplicationBarIconButton();
                            closeBtn.Text = "Close";
                            closeBtn.IconUri = new Uri("/Images/appbar.close.rest.png", UriKind.Relative);
                            closeBtn.Click += new EventHandler(closeBtn_Click);
                            bar.Buttons.Add(closeBtn);

                            page.ApplicationBar = bar;
                        }

                    }
                }
            });
        }

        void browser_LoadCompleted(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            
        }

        void fwdButton_Click(object sender, EventArgs e)
        {
            if (browser != null)
            {
                try
                {
                    browser.InvokeScript("execScript", "history.forward();");
                }
                catch(Exception)
                {

                }
            }
        }

        void backButton_Click(object sender, EventArgs e)
        {
            if (browser != null)
            {
                try
                {
                    browser.InvokeScript("execScript", "history.back();");
                }
                catch (Exception)
                {

                }
            }
        }

        void closeBtn_Click(object sender, EventArgs e)
        {
            this.close();
        }


        public void close(string options="")
        {
            if (browser != null)
            {
                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    PhoneApplicationFrame frame = Application.Current.RootVisual as PhoneApplicationFrame;
                    if (frame != null)
                    {
                        PhoneApplicationPage page = frame.Content as PhoneApplicationPage;
                        if (page != null)
                        {
                            Grid grid = page.FindName("LayoutRoot") as Grid;
                            if (grid != null)
                            {
                                grid.Children.Remove(browser);
                            }
                            page.ApplicationBar = null;
                        }
                    }
                    browser = null;
                });
            }
        }

        void browser_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            string message = "{\"type\":\"locationChanged\", \"location\":\"" + e.Uri.AbsoluteUri + "\"}";
            PluginResult result = new PluginResult(PluginResult.Status.OK, message);
            result.KeepCallback = true;
            this.DispatchCommandResult(result);
        }

        void browser_NavigationFailed(object sender, System.Windows.Navigation.NavigationFailedEventArgs e)
        {
            string message = "{\"type\":\"navigationError\",\"location\":\"" + e.Uri.AbsoluteUri + "\"}";
            PluginResult result = new PluginResult(PluginResult.Status.ERROR, message);
            result.KeepCallback = true;
            this.DispatchCommandResult(result);
        }

        void browser_Navigating(object sender, NavigatingEventArgs e)
        {
            string message = "{\"type\":\"locationAboutToChange\",\"location\":\"" + e.Uri.AbsoluteUri + "\"}";
            PluginResult result = new PluginResult(PluginResult.Status.OK, message);
            result.KeepCallback = true;
            this.DispatchCommandResult(result);
        }

    }
}
