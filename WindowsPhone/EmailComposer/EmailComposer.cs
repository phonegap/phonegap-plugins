using System;
using System.Runtime.Serialization;
using Microsoft.Phone.Tasks;

namespace WP7CordovaClassLib.Cordova.Commands
{
    [DataContract]
    public class Options
    {
        [DataMember]
        public string to;

        [DataMember]
        public string subject;

        [DataMember]
        public string body;
    }

    public class EmailComposer : BaseCommand
    {
        public void show(string options)
        {
            try
            {
                Options opts = WP7CordovaClassLib.Cordova.JSON.JsonHelper.Deserialize<Options>(options);
                EmailComposeTask emailcomposer = new EmailComposeTask();
                emailcomposer.To = opts.to;
                emailcomposer.Subject = opts.subject;
                emailcomposer.Body = opts.body;
                emailcomposer.Show();
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
            }
            catch (Exception e)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            }
        }
    }
}
