using System.Runtime.Serialization;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;
using Microsoft.Phone.Shell;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Tasks;
using System.Windows;

namespace org.apache.cordova
{
    public class barcodeScanner : WP7CordovaClassLib.Cordova.Commands.BaseCommand
    {
        public void scan(string options) 
        {
            Deployment.Current.Dispatcher.BeginInvoke(() =>
            {
                var root = Application.Current.RootVisual as PhoneApplicationFrame;

                root.Navigated += new System.Windows.Navigation.NavigatedEventHandler(root_Navigated);

                root.Navigate(new System.Uri("/BarcodeScanner;component/Scanner.xaml?dummy=" + Guid.NewGuid().ToString(), UriKind.Relative));
            });
        }

        void root_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            if (!(e.Content is BarcodeScanner.Scanner)) return;

            (Application.Current.RootVisual as PhoneApplicationFrame).Navigated -= root_Navigated;

            BarcodeScanner.Scanner scanner = (BarcodeScanner.Scanner)e.Content;

            if (scanner != null)
            {
                scanner.Completed += new EventHandler<BarcodeScanner.ScannerResult>(scanner_Completed);
            }
        }

        void scanner_Completed(object sender, BarcodeScanner.ScannerResult e)
        {
            if (e.TaskResult == TaskResult.OK)
            {
                string result = String.Format("\"cancelled\":{0},\"text\":\"{1}\"", 0, e.ScanCode);
                result = "{" + result + "}";
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK, result));
            }
            else
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Failed to scan QR code"));
            }
        }

        public void encode(string options)
        {
            DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Not implemented"));
        }
    }
}
