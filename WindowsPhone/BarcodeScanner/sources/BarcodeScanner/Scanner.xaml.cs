using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;

using Microsoft.Phone.Tasks;
using System.Windows.Threading;
using Microsoft.Devices;
using com.google.zxing;
using com.google.zxing.common;
using com.google.zxing.qrcode;

namespace BarcodeScanner
{
    public partial class Scanner : PhoneApplicationPage
    {
        /// <summary>
        /// Occurs when a video recording task is completed.
        /// </summary>
        public event EventHandler<ScannerResult> Completed;
        private ScannerResult result = new ScannerResult(TaskResult.Cancel);

        public Scanner()
        {
            InitializeComponent();
        }

        // opening
        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);

            _photoCamera = new PhotoCamera();
            _photoCamera.Initialized += OnPhotoCameraInitialized;
            _previewVideo.SetSource(_photoCamera);

            CameraButtons.ShutterKeyHalfPressed += (o, arg) => _photoCamera.Focus();
        }

        // closing
        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            stopCamera();

            if (this.Completed != null)
            {
                this.Completed(this, result);
            }

            base.OnNavigatedFrom(e);
        }

        private DispatcherTimer _timer;

        private PhotoCameraLuminanceSource _luminance;
        private QRCodeReader _reader;
        private PhotoCamera _photoCamera;

        private void OnPhotoCameraInitialized(object sender, CameraOperationCompletedEventArgs e)
        {
            Dispatcher.BeginInvoke(() =>
            {
                _timer = new DispatcherTimer();
                _timer.Interval = TimeSpan.FromMilliseconds(250);
                _timer.Tick += (o, arg) => ScanPreviewBuffer();

                int width = Convert.ToInt32(_photoCamera.PreviewResolution.Width);
                int height = Convert.ToInt32(_photoCamera.PreviewResolution.Height);

                _luminance = new PhotoCameraLuminanceSource(width, height);
                _reader = new QRCodeReader();
            });

            Dispatcher.BeginInvoke(() =>
            {
                _previewTransform.Rotation = _photoCamera.Orientation;
                _timer.Start();
            });
        }

        private void ScanPreviewBuffer()
        {
            try
            {
                _photoCamera.GetPreviewBufferY(_luminance.PreviewBufferY);
                var binarizer = new HybridBinarizer(_luminance);
                var binBitmap = new BinaryBitmap(binarizer);
                var result = _reader.decode(binBitmap);

                Dispatcher.BeginInvoke(() => DisplayResult(result.Text));
            }
            catch
            {
            }
        }

        private void DisplayResult(string text)
        {
            result = new ScannerResult(Microsoft.Phone.Tasks.TaskResult.OK);
            result.ScanCode = text;
            stopCamera();
            if (this.NavigationService.CanGoBack)
            {
                this.NavigationService.GoBack();
            }
        }

        private bool stopCamera()
        {
            if (_photoCamera == null)
            {
                return false;
            }
            _timer.Stop();
            _timer = null;
            _luminance = null;
            _reader = null;
            _photoCamera.Dispose();
            _photoCamera = null;

            return true;
        }

        private void _focusButton_Click(object sender, RoutedEventArgs e)
        {
            if (_photoCamera != null && _photoCamera.IsFocusSupported)
            {
                try
                {
                    _photoCamera.CancelFocus();
                    _photoCamera.Focus();
                }
                catch
                {
                }
            }
        }
    }
}