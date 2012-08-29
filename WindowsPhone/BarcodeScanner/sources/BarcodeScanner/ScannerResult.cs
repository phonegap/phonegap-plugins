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

using Microsoft.Phone.Tasks;

namespace BarcodeScanner
{
    public class ScannerResult : TaskEventArgs
    {
        public ScannerResult() : base()
        {
        }

        public ScannerResult(TaskResult result) : base(result)
        {
        }
        /// <summary>
        /// Scanned QR Code
        /// </summary>
        public String ScanCode { get; internal set; }
    }
}
