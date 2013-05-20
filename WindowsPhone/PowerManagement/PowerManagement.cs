using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Phone.Shell;

namespace WPCordovaClassLib.Cordova.Commands
{
    class PowerManagement : BaseCommand
    {
        public void acquire(string options) {
            PhoneApplicationService.Current.UserIdleDetectionMode = IdleDetectionMode.Disabled;
        }

        public void release(string options)
        {
            PhoneApplicationService.Current.UserIdleDetectionMode = IdleDetectionMode.Enabled;
        }

    }
}
