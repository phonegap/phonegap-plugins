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
using Microsoft.Phone.Controls;
using System.Device.Location;
using System.Runtime.Serialization;
using System.Diagnostics;

namespace WP7GapClassLib.PhoneGap.Commands
{
    public class PGMapLauncher : PhoneGap.Commands.BaseCommand
    {

        [DataContract]
        public class SearchOptions
        {
            [DataMember(IsRequired = false, Name = "searchTerm")]
            public string SearchTerm { get; set; }

            [DataMember(IsRequired = false, Name = "center")]
            public Coordinates Center;
        }

        [DataContract]
        public class Coordinates
        {
            [DataMember(IsRequired = false, Name = "latitude")]
            public double Latitude;

            [DataMember(IsRequired = false, Name = "longitude")]
            public double Longitude;
        }

        [DataContract]
        public class LabeledCoordinates
        {
            [DataMember(IsRequired = false, Name = "coordinates")]
            public Coordinates Coordinates;

            [DataMember(IsRequired = false, Name = "label")]
            public string Label;
        }

        [DataContract]
        public class GetDirectionsOptions
        {
            [DataMember(IsRequired = false, Name = "startPosition")]
            public LabeledCoordinates Start;

            [DataMember(IsRequired = true, Name = "endPosition")]
            public LabeledCoordinates End;
        }


        public void searchNear(string options)
        {
            SearchOptions searchOptions =  JSON.JsonHelper.Deserialize<SearchOptions>(options);
            BingMapsTask bingMapsTask = new BingMapsTask();

            //Omit the Center property to use the user's current location.
            if (searchOptions.Center != null)
            {
                bingMapsTask.Center = new GeoCoordinate(searchOptions.Center.Latitude, searchOptions.Center.Longitude);
            }

            if (searchOptions.SearchTerm != null)
            {

                bingMapsTask.SearchTerm = searchOptions.SearchTerm;
                bingMapsTask.Show();
            }
            else
            {
                Debug.WriteLine("Error::searchTerm must be specified for map searching");
            }
           
            
        }

        public void getDirections(string options)
        {
            GetDirectionsOptions directionOptions = JSON.JsonHelper.Deserialize<GetDirectionsOptions>(options);

            BingMapsDirectionsTask bingMapsDirectionsTask = new BingMapsDirectionsTask();

            // You can specify a label and a geocoordinate for the end point.
            if (directionOptions.Start != null)
            {
                LabeledMapLocation startLML = new LabeledMapLocation();
                startLML.Location = new GeoCoordinate(directionOptions.Start.Coordinates.Latitude, directionOptions.Start.Coordinates.Longitude);
                if (directionOptions.Start.Label != null)
                {
                    startLML.Label = directionOptions.Start.Label;
                }
                bingMapsDirectionsTask.Start = startLML;
            }
            // If you set the geocoordinate parameter to null, the label parameter is used as a search term.
            if (directionOptions.End != null)
            {
                LabeledMapLocation endLML = new LabeledMapLocation();
                if (directionOptions.End.Coordinates != null)
                {
                    endLML.Location = new GeoCoordinate(directionOptions.End.Coordinates.Latitude, directionOptions.End.Coordinates.Longitude);
                }
                if (directionOptions.End.Label != null)
                {
                    endLML.Label = directionOptions.End.Label;
                }
                bingMapsDirectionsTask.End = endLML;
            }

            // If bingMapsDirectionsTask.Start is not set, the user's current location is used as the start point.
            bingMapsDirectionsTask.Show();
        }
    }
}
