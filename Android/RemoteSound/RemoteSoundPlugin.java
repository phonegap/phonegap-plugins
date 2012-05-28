package com.phonegap.plugin.remotesound;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;

/**
 * The Class RemoteSoundPlugin allows to perform 2 separate actions: 1- play a
 * remote sound given a URL 2- load and cache sounds given some URLs
 * 
 * A usage where load/cache sounds is valuable is when lots of sounds, possibly
 * large, needs to be pre-loaded Play sound is first checking that no other
 * sound with the same name has been cached. If not, it remotely downloads it
 * and cache it on the file system
 */
public class RemoteSoundPlugin extends Plugin implements OnPreparedListener, OnCompletionListener {

    private MediaPlayer mp = null;
    private static final int BUFFER_SIZE = 1024 * 2;

    @Override
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult result = null;

        if (action.equals("playRemoteSound")) {

            JSONObject obj = null;
            try {
                obj = args.getJSONObject(0);
                String soundURL = obj.has("soundURL") ? obj.getString("soundURL") : null;

                if (soundURL != null) {
                    this.playSound(soundURL);
                }
            } catch (JSONException jsonEx) {

                result = new PluginResult(Status.JSON_EXCEPTION);
            }
        }

        if (action.equals("loadRemoteSounds")) {

            JSONArray resourceNames = null;
            JSONObject obj = null;
            
            try {
                obj = args.getJSONObject(0);
                resourceNames = obj.has("soundURLs") ? obj.getJSONArray("soundURLs") : null;

                if (resourceNames != null && resourceNames.length() > 0) {
                    Set<URL> resources = new HashSet<URL>(resourceNames.length());
                    for (int nbElem = 0; nbElem < resourceNames.length(); nbElem++) {
                        try {
                            resources.add(new URL(resourceNames.getString(nbElem)));
                        } catch (MalformedURLException e) {
                            e.printStackTrace();
                        }
                    }

                    if (!resources.isEmpty()) {
                        downloadResources(ctx.getContext(), resources);
                    }
                }

            } catch (JSONException jsonEx) {

                result = new PluginResult(Status.JSON_EXCEPTION);
            }
        }

        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * android.media.MediaPlayer.OnPreparedListener#onPrepared(android.media
     * .MediaPlayer)
     */
    public void onPrepared(MediaPlayer mediaplayer) {
        if (mp != null) {
            mp.start();
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * android.media.MediaPlayer.OnCompletionListener#onCompletion(android.media
     * .MediaPlayer)
     */
    public void onCompletion(MediaPlayer mediaplayer) {
        Timer endSound = new Timer();
        endSound.schedule(new TimerTask() {
            public void run() {
                if (mp != null) {
                    mp.stop();
                    mp.release();
                    mp = null;
                }
            }
        }, 200);

    }

    /**
     * Play sound, either locally (from assets) or remotely via URL.
     * 
     * @param soundUri
     *            the sound uri
     */
    private void playSound(String soundUri) {

        try {

            mp = new MediaPlayer();

            mp.setOnPreparedListener(this);
            mp.setOnCompletionListener(this);

            FileInputStream fis = null;
            String soundName = soundUri.substring(soundUri.lastIndexOf('/') + 1);
            try {

                fis = ctx.getApplicationContext().openFileInput(soundName);
            } catch (FileNotFoundException fne) {

                downloadRemoteMedia(ctx.getApplicationContext(), soundUri, soundName);
                fis = ctx.getApplicationContext().openFileInput(soundName);
            }

            mp.setDataSource(fis.getFD());

            mp.setVolume(1.0f, 1.0f);
            mp.prepare();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Download the url stream to a temporary location and then call the
     * 
     * 
     * @param context
     *            the context
     * @param mediaUrl
     *            the media url
     * @param mediaFileName
     *            the media file name
     * @return the file
     * @throws IOException
     *             Signals that an I/O exception has occurred.
     */
    private void downloadRemoteMedia(Context context, String mediaUrl, String mediaFileName)
            throws IOException {
        // File downloadingMediaFile = null;
        HttpURLConnection cn = null;
        FileOutputStream out = null;
        InputStream stream = null;

        try {
            cn = (HttpURLConnection) new URL(mediaUrl).openConnection();
            stream = new BufferedInputStream(cn.getInputStream(), BUFFER_SIZE);

            // PRIVATE STORAGE. Automatically replace existing files
            out = context.openFileOutput(mediaFileName, Context.MODE_PRIVATE);

            byte buf[] = new byte[BUFFER_SIZE];
            int len1 = 0;

            while ((len1 = stream.read(buf)) > 0) {
                out.write(buf, 0, len1);
            }

            out.close();
            stream.close();
        } finally {
            if (cn != null) {
                cn.disconnect();
            }
            try {
                out.close();
            } catch (IOException e) {

            }
            try {
                stream.close();
            } catch (IOException e) {

            }
        }

    }

    /**
     * Download given resources.
     * 
     * @param context
     *            the context
     * @param resources
     *            the resources
     * @return the number of loaded resources
     */
    private Integer downloadResources(Context context, Set<URL> resources) {
        int nbLoaded = 0;

        for (Iterator<URL> iterator = resources.iterator(); iterator.hasNext();) {

            URL url = iterator.next();
            try {
                downloadRemoteMedia(context, url.toString(),
                        url.getPath().substring(url.getPath().lastIndexOf('/') + 1));
                nbLoaded++;
            } catch (IOException ioex) {
                ioex.printStackTrace();
            }
        }

        return nbLoaded;
    }

}
