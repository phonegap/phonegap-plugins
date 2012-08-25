/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2011, Microsoft Corporation
 */

using System.Runtime.Serialization;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;
using Microsoft.Phone.Shell;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Phone.Controls;
using System.Windows;

namespace Cordova.Extension.Commands
{
    /// <summary>
    /// Implementes access to application live tiles
    /// http://msdn.microsoft.com/en-us/library/hh202948(v=VS.92).aspx
    /// </summary>
    public class LiveTiles : BaseCommand
    {

        #region Live tiles options
        
        /// <summary>
        /// Represents LiveTile options
        /// </summary>
        [DataContract]
        public class LiveTilesOptions
        {
            /// <summary>
            /// Tile title
            /// </summary>
            [DataMember(IsRequired=false, Name="title")]
            public string Title { get; set; }

            /// <summary>
            /// Tile count
            /// </summary>
            [DataMember(IsRequired = false, Name = "count")]
            public int Count { get; set; }

            /// <summary>
            /// Tile image
            /// </summary>
            [DataMember(IsRequired = false, Name = "image")]
            public string Image { get; set; }

            /// <summary>
            /// Back tile title
            /// </summary>
            [DataMember(IsRequired = false, Name = "backTitle")]
            public string BackTitle { get; set; }

            /// <summary>
            /// Back tile content
            /// </summary>
            [DataMember(IsRequired = false, Name = "backContent")]
            public string BackContent { get; set; }

            /// <summary>
            /// Back tile image
            /// </summary>
            [DataMember(IsRequired = false, Name = "backImage")]
            public string BackImage { get; set; }

            /// <summary>
            /// Identifier for second tile
            /// </summary>
            [DataMember(IsRequired = false, Name = "secondaryTileUri")]
            public string SecondaryTileUri { get; set; }

        }
        #endregion

        /// <summary>
        /// Updates application live tile
        /// </summary>
        public void updateAppTile(string options)
        {
            LiveTilesOptions liveTileOptions;
            try
            {
                liveTileOptions = JsonHelper.Deserialize<LiveTilesOptions[]>(options)[0];
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            try
            {
                ShellTile appTile = ShellTile.ActiveTiles.First();

                if (appTile != null)
                {
                    StandardTileData standardTile = CreateTileData(liveTileOptions);
                    appTile.Update(standardTile);
                    DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
                }
                else
                {
                    DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Can't get application tile"));
                }
            }
            catch(Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Error updating application tile"));
            }
        }

        /// <summary>
        /// Creates secondary tile
        /// </summary>
        public void createSecondaryTile(string options)
        {
            LiveTilesOptions liveTileOptions;
            try
            {
                liveTileOptions = JsonHelper.Deserialize<LiveTilesOptions[]>(options)[0];
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            if (string.IsNullOrEmpty(liveTileOptions.Title) || string.IsNullOrEmpty(liveTileOptions.Image) || string.IsNullOrEmpty(liveTileOptions.SecondaryTileUri))
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }
            try
            {
                ShellTile foundTile = ShellTile.ActiveTiles.FirstOrDefault(x => x.NavigationUri.ToString().Contains(liveTileOptions.SecondaryTileUri));                
                if (foundTile == null)
                {
                    StandardTileData secondaryTile = CreateTileData(liveTileOptions);
                    PhoneApplicationPage currentPage;
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        currentPage = ((PhoneApplicationFrame)Application.Current.RootVisual).Content as PhoneApplicationPage;
                        string currentUri = currentPage.NavigationService.Source.ToString().Split('?')[0];
                        ShellTile.Create(new Uri(currentUri + "?Uri=" + liveTileOptions.SecondaryTileUri, UriKind.Relative), secondaryTile);
                        DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
                    });                                                            
                }
                else
                {
                    DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR,"Tile already exist"));
                }                
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR,"Error creating secondary live tile"));
            }
        }

        /// <summary>
        /// Updates secondary tile
        /// </summary>
        public void updateSecondaryTile(string options)
        {
            LiveTilesOptions liveTileOptions;
            try
            {
                liveTileOptions = JsonHelper.Deserialize<LiveTilesOptions[]>(options)[0];
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            if (string.IsNullOrEmpty(liveTileOptions.SecondaryTileUri))
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            try
            {
                ShellTile foundTile = ShellTile.ActiveTiles.FirstOrDefault(x => x.NavigationUri.ToString().Contains(liveTileOptions.SecondaryTileUri));

                if (foundTile != null)
                {
                    StandardTileData liveTile = this.CreateTileData(liveTileOptions);
                    foundTile.Update(liveTile);
                    DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
                }
                else
                {
                    DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Can't get secondary live tile"));
                }
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR,"Error updating secondary live tile"));
            }
        }

        /// <summary>
        /// Deletes secondary tile
        /// </summary>
        public void deleteSecondaryTile(string options)
        {
            LiveTilesOptions liveTileOptions;
            try
            {
                liveTileOptions = JsonHelper.Deserialize<LiveTilesOptions[]>(options)[0];
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            if (string.IsNullOrEmpty(liveTileOptions.SecondaryTileUri))
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }
            try
            {
                ShellTile foundTile = ShellTile.ActiveTiles.FirstOrDefault(x => x.NavigationUri.ToString().Contains(liveTileOptions.SecondaryTileUri));
                if (foundTile != null)
                {
                    foundTile.Delete();
                    DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
                }
                else
                {
                    DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Can't get secondary live tile"));
                }   
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Error deleting secondary live tile"));
            }
        }


        /// <summary>
        /// Cerates tile data
        /// </summary>
        private StandardTileData CreateTileData(LiveTilesOptions liveTileOptions)
        {
            StandardTileData standardTile = new StandardTileData();
            if (!string.IsNullOrEmpty(liveTileOptions.Title))
            {
                standardTile.Title = liveTileOptions.Title;
            }
            if (!string.IsNullOrEmpty(liveTileOptions.Image))
            {
                standardTile.BackgroundImage = new Uri(liveTileOptions.Image, UriKind.RelativeOrAbsolute);
            }                        
            if (liveTileOptions.Count > 0)
            {
                standardTile.Count = liveTileOptions.Count;
            }
            if (!string.IsNullOrEmpty(liveTileOptions.BackTitle))
            {
                standardTile.BackTitle = liveTileOptions.BackTitle;
            }
            if (!string.IsNullOrEmpty(liveTileOptions.BackContent))
            {
                standardTile.BackContent = liveTileOptions.BackContent;
            }
            if (!string.IsNullOrEmpty(liveTileOptions.BackImage))
            {
                standardTile.BackBackgroundImage = new Uri(liveTileOptions.BackImage, UriKind.RelativeOrAbsolute);
            }
            return standardTile;
        }

    }
}