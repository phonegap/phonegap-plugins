package com.wikitude.phonegap;

import java.io.IOException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewManager;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.wikitude.architect.ArchitectUrlListener;
import com.wikitude.architect.ArchitectView;
import com.wikitude.architect.ArchitectView.ArchitectConfig;



/**
 * Basic PhoneGap Wikitude ARchitect Plugin
 * 
 * @author Wikitude GmbH
 */
public class WikitudePlugin extends Plugin implements ArchitectUrlListener {

	/** PhoneGap-root to Android-App-assets folder */
	private static final String	LOCAL_ASSETS_PATH_ROOT		= "assets/";

	/* various JSON-Object keys*/
	private static final String	JSON_KEY_APIKEY				= "sdkKey";
	private static final String	JSON_KEY_FILE_PATH			= "filePath";

	private static final String	JSON_KEY_LOCATION_ALTITUDE	= "alt";
	private static final String	JSON_KEY_LOCATION_ACCURACY	= "acc";
	private static final String	JSON_KEY_LOCATION_LATITUDE	= "lat";
	private static final String	JSON_KEY_LOCATION_LONGITUDE	= "lon";

	/* static action strings */

	/**
	 * opens architect-view (add to view stack)
	 */
	private static final String	ACTION_OPEN					= "open";

	/**
	 * closes architect-view (remove view stack)
	 */
	private static final String	ACTION_CLOSE				= "close";

	/**
	 * set visibility of architectView to visible (of present)
	 */
	private static final String	ACTION_SHOW					= "show";

	/**
	 * set visibility of architectView to invisible (of present)
	 */
	private static final String	ACTION_HIDE					= "hide";

	/**
	 * inject location information
	 */
	private static final String	ACTION_SET_LOCATION			= "setLocation";

	/**
	 * callback for uri-invocations
	 */
	private static final String	ACTION_ON_URLINVOKE			= "onUrlInvoke";

	/**
	 * life-cycle notification for resume
	 */
	private static final String	ACTION_ON_RESUME			= "onResume";

	/**
	 * life-cycle notification for pause
	 */
	private static final String	ACTION_ON_PAUSE				= "onPause";

	/**
	 * check if view is on view-stack (no matter if visible or not)
	 */
	private static final String	ACTION_STATE_ISOPEN			= "isOpen";

	/**
	 * opens architect-view (add to view stack)
	 */
	private static final String	ACTION_IS_DEVICE_SUPPORTED	= "isDeviceSupported";

	/**
	 * check if view is on view-stack (no matter if visible or not)
	 */
	private static final String	ACTION_CALL_JAVASCRIPT		= "callJavascript";

	/**
	 * the Wikitude ARchitectview
	 */
	private ArchitectView		architectView;

	/**
	 * callback-Id of url-invocation method
	 */
	private String				urlInvokeCallbackId			= null;

	/**
	 * callback-id of "open"-action method
	 */
	private String				openCallbackId				= null;

	@Override
	public PluginResult execute( final String action, final JSONArray args, final String callbackId ) {

		/* hide architect-view -> destroy and remove from activity */
		if ( WikitudePlugin.ACTION_CLOSE.equals( action ) ) {
			if ( this.architectView != null ) {
				this.cordova.getActivity().runOnUiThread( new Runnable() {

					@Override
					public void run() {
						removeArchitectView();
					}
				} );
				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			}
			else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
			}
		}

		/* return success only if view is opened (no matter if visible or not) */
		if ( WikitudePlugin.ACTION_STATE_ISOPEN.equals( action ) ) {
			if ( this.architectView != null ) {
				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			} else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
			}
		}

		/* return success only if view is opened (no matter if visible or not) */
		if ( WikitudePlugin.ACTION_IS_DEVICE_SUPPORTED.equals( action ) ) {
			if ( ArchitectView.isDeviceSupported( this.cordova.getActivity() ) ) {
				return new PluginResult( PluginResult.Status.OK, action + ": this device is ARchitect-ready" );
			} else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": Sorry, this device is NOT ARchitect-ready" );
			}
		}



		/* life-cycle's RESUME */
		if ( WikitudePlugin.ACTION_ON_RESUME.equals( action ) ) {

			if ( this.architectView != null ) {
				this.cordova.getActivity().runOnUiThread( new Runnable() {

					@Override
					public void run() {
						WikitudePlugin.this.architectView.onResume();
					}
				} );

				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			}
			return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
		}

		/* life-cycle's PAUSE */
		if ( WikitudePlugin.ACTION_ON_PAUSE.equals( action ) ) {
			if ( architectView != null ) {
				this.cordova.getActivity().runOnUiThread( new Runnable() {

					@Override
					public void run() {
						WikitudePlugin.this.architectView.onPause();
					}
				} );

				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			}
			return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
		}

		/* set visibility to "visible", return error if view is null */
		if ( WikitudePlugin.ACTION_SHOW.equals( action ) ) {

			if ( this.architectView != null ) {
				this.architectView.setVisibility( View.VISIBLE );
				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			} else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
			}
		}

		/* set visibility to "invisible", return error if view is null */
		if ( WikitudePlugin.ACTION_HIDE.equals( action ) ) {

			if ( this.architectView != null ) {
				this.architectView.setVisibility( View.INVISIBLE );
				return new PluginResult( PluginResult.Status.OK, action + ": architectView is present" );
			} else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": architectView is not present" );
			}
		}

		/* define call-back for url-invocations */
		if ( WikitudePlugin.ACTION_ON_URLINVOKE.equals( action ) ) {
			this.urlInvokeCallbackId = callbackId;
			PluginResult result = new PluginResult( PluginResult.Status.NO_RESULT, action + ": registered callback" );
			result.setKeepCallback( true );
			return result;
		}

		/* location update */
		if ( WikitudePlugin.ACTION_SET_LOCATION.equals( action ) ) {
			if ( this.architectView != null ) {
				try {
					String arrStr = args.getString( 0 );
					JSONObject arr = new JSONObject( arrStr );
					final double lat = arr.getDouble( WikitudePlugin.JSON_KEY_LOCATION_LATITUDE );
					final double lon = arr.getDouble( WikitudePlugin.JSON_KEY_LOCATION_LONGITUDE );
					Object altObj = arr.get( WikitudePlugin.JSON_KEY_LOCATION_ALTITUDE );
					float alt = Float.MIN_VALUE;

					if ( altObj != null && altObj instanceof Double ) {
						alt = ((Double)altObj).floatValue();
					}

					final float altitude = alt;

					final Double acc = arr.getDouble( WikitudePlugin.JSON_KEY_LOCATION_ACCURACY );
					if ( this.cordova != null && this.cordova.getActivity() != null ) {
						this.cordova.getActivity().runOnUiThread( new Runnable() {

							@Override
							public void run() {
								if ( acc != null ) {
									WikitudePlugin.this.architectView.setLocation( lat, lon, altitude, acc.floatValue() );
								} else {
									WikitudePlugin.this.architectView.setLocation( lat, lon, altitude );
								}
							}
						} );
					}

				} catch ( Exception e ) {
					return new PluginResult( PluginResult.Status.ERROR, action + ": exception thrown, " + e != null ? e.getMessage() : "(exception is NULL)" );
				}
				return new PluginResult( PluginResult.Status.OK, action + ": updated location" );
			}

			/* return error if there is no architect-view active*/
			return new PluginResult( PluginResult.Status.ERROR, action + ": architectview is not active" );
		}

		if ( WikitudePlugin.ACTION_CALL_JAVASCRIPT.equals( action ) ) {
			if ( this.architectView != null ) {
				String logMsg = null;
				try {
					final String callJS = args.getString( 0 );
					logMsg = callJS;
					this.cordova.getActivity().runOnUiThread( new Runnable() {

						@Override
						public void run() {
							WikitudePlugin.this.architectView.callJavascript( callJS );
						}
					} );

				} catch ( JSONException je ) {
					return new PluginResult( PluginResult.Status.ERROR, action + ": exception thrown, " + je != null ? je.getMessage() : "(exception is NULL)" );
				}
				return new PluginResult( PluginResult.Status.OK, action + ": called js, '" + logMsg + "'" );
			} else {
				return new PluginResult( PluginResult.Status.ERROR, action + ": architectview is not active" );
			}
		}


		/* initial set-up, show ArchitectView full-screen in current screen/activity */
		if ( WikitudePlugin.ACTION_OPEN.equals( action ) ) {
			this.openCallbackId = callbackId;
			PluginResult result = null;
			String arrStr = null;

			try {
				arrStr = args.getString( 0 );

				// arrStr = arrStr.substring( 1, arrStr.length() - 1 );

				JSONObject arr = new JSONObject( arrStr );

				final String apiKey = arr.getString( WikitudePlugin.JSON_KEY_APIKEY );
				final String filePath = arr.getString( WikitudePlugin.JSON_KEY_FILE_PATH );

				this.cordova.getActivity().runOnUiThread( new Runnable() {

					@Override
					public void run() {
						try {
							WikitudePlugin.this.addArchitectView( apiKey, filePath );

							/* call success method once architectView was added successfully */
							if ( WikitudePlugin.this.openCallbackId != null ) {
								PluginResult result = new PluginResult( PluginResult.Status.OK );
								result.setKeepCallback( false );
								WikitudePlugin.this.success( result, WikitudePlugin.this.openCallbackId );
							}
						} catch ( Exception e ) {
							/* in case "addArchitectView" threw an exception -> notify callback method asynchronously */
							WikitudePlugin.this.error( e != null ? e.getMessage() : "Exception is 'null'", WikitudePlugin.this.openCallbackId );
						}
					}
				} );

			} catch ( Exception e ) {
				result = new PluginResult( PluginResult.Status.ERROR, action + ": exception thown, " + e != null ? e.getMessage() : "(exception is NULL)" );
				result.setKeepCallback( false );
				return result;
			}

			/* adding architect-view is done in separate thread, ensure to setKeepCallback so one can call success-method properly later on */
			result = new PluginResult( PluginResult.Status.NO_RESULT, action + ": no result required, just registered callback-method" );
			result.setKeepCallback( true );

			return result;
		}

		/* fall-back return value */
		return new PluginResult( PluginResult.Status.ERROR, "no such action: " + action );
	}

	/**
	 * called when url was invoked in architectView (by e.g. calling document.location = "myprotocoll://foo";
	 * @param url the invoked url (e.g. "myprotocoll://foo")
	 * @return true if call was handled properly
	 */
	@Override
	public boolean urlWasInvoked( String url ) {

		/* call callback-method if set*/
		if ( this.urlInvokeCallbackId != null ) {
			try {
				/* pass called url as String to callback-method */
				PluginResult res = new PluginResult( PluginResult.Status.OK, url );
				res.setKeepCallback( true );
				this.success( res, this.urlInvokeCallbackId );
				return true;
			} catch ( Exception e ) {
				this.error( "invalid url invoked: " + url, this.urlInvokeCallbackId );
			}
		}
		return false;
	}

	/**
	 * hides/removes ARchitect-View completely
	 * @return true if successful, false otherwise
	 */
	private boolean removeArchitectView() {
		if ( this.architectView != null ) {
			/* fake life-cycle calls, because activity is already up and running */
			this.architectView.onPause();
			this.architectView.onDestroy();
			this.architectView.setVisibility( View.INVISIBLE );
			((ViewManager)this.architectView.getParent()).removeView( this.architectView );
			this.architectView = null;
			return true;
		}
		return false;
	}

	/**
	 * Architect-Configuration required for proper set-up
	 * @param apiKey
	 * @return
	 */
	protected ArchitectConfig getArchitectConfig( final String apiKey ) {
		/* no special set-up required in default Wikitude-Plugin, further things required in advanced usage (e.g. Vuforia Image Recognition) */
		return new ArchitectConfig( apiKey );
	}

	/**
	 * add architectView to current screen
	 * @param apiKey developers's api key to use (hides watermarking/intro-animation if it matches your package-name)
	 * @param filePath the url (starting with http:// for online use; starting with LOCAL_ASSETS_PATH_ROOT if oyu want to load assets within your app-assets folder)
	 * @throws IOException might be thrown from ARchitect-SDK
	 */
	@SuppressWarnings("deprecation")
	private void addArchitectView( final String apiKey, String filePath ) throws IOException {
		if ( this.architectView == null ) {
			this.architectView = new ArchitectView( (Activity)this.ctx.getContext() );

			/* add content view and fake initial life-cycle */
			((Activity)this.ctx.getContext()).addContentView( this.architectView, new ViewGroup.LayoutParams( LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT ) );

			/* fake life-cycle calls, because activity is already up and running */
			this.architectView.onCreate( getArchitectConfig( apiKey ) );
			this.architectView.onPostCreate();

			/* register self as url listener to fwd these native calls to PhoneGap */
			this.architectView.registerUrlListener( WikitudePlugin.this );

			/* load asset from local directory if prefix is used */
			if ( filePath.startsWith( WikitudePlugin.LOCAL_ASSETS_PATH_ROOT ) ) {
				filePath = filePath.substring( WikitudePlugin.LOCAL_ASSETS_PATH_ROOT.length() );
			}
			this.architectView.load( filePath );

			/* also a fake-life-cycle call (the last one before it is really shown in UI */
			this.architectView.onResume();
		}
	}
}
