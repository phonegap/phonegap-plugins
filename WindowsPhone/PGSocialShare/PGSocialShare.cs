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
using System.Runtime.Serialization;
using Microsoft.Phone.Tasks;

namespace WP7GapClassLib.PhoneGap.Commands
{

    public class PGSocialShare : BaseCommand
    {
        public enum ShareType
        {
            Status = 0, // status update to twitter/facebook/... all supported device accounts
            Link        // share a link on twitter/facebook/ ... all supported device accounts
        }


        [DataContract]
        public class ShareOptions
        {
            [DataMember]
            public string url;

            [DataMember]
            public string title;

            [DataMember]
            public string message;

            [DataMember]
            public ShareType shareType = ShareType.Status; // default
        }

        public void share(string options)
        {
            ShareOptions opts = JSON.JsonHelper.Deserialize<ShareOptions>(options);
            switch (opts.shareType)
            {
                case ShareType.Status :
                    shareStatus(opts.message);
                    break;
                case ShareType.Link :
                    shareLink(opts.title, opts.url, opts.message);
                    break;
            }
        }

        protected void shareStatus(string msg)
        {
            ShareStatusTask shareStatusTask = new ShareStatusTask();
            shareStatusTask.Status = msg;
            shareStatusTask.Show();

            this.DispatchCommandResult();
        }

        protected void shareLink(string title, string url, string msg)
        {
            ShareLinkTask shareLinkTask = new ShareLinkTask();
            shareLinkTask.Title = title;
            shareLinkTask.LinkUri = new Uri(url, UriKind.Absolute);
            shareLinkTask.Message = msg;
            shareLinkTask.Show();

            this.DispatchCommandResult();
        }
    }
}
