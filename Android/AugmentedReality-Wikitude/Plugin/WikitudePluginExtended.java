package com.wikitude.phonegap;

import android.app.Activity;

import com.qualcomm.QCAR.QCAR;
import com.wikitude.architect.ArchitectView.ArchitectConfig;
import com.wikitude.architect.VuforiaInterface;



/** 
 * Advanced Wikitude ARchitect Plugin (= Basic Plugin + Vuforia Image Recognition feature-set)
 *
 * You must add "wikitudesdk.jar" and "QCAR.lib" to your libs folder and build-path and have "libQCAR.so" in project's "libs/armeabi/" directory
 * 
 * Also add "<plugin name="WikitudePlugin" value="com.wikitude.phonegap.WikitudePluginVuforia"/>"
 * (replace Basic-plugin entry if necessary) 
 * 
 * in config.xml to enable this plug-in in your project; Ensure your architectSDK key is Vuforia-ready
 * 
 * Note:
 * This plug-in is written under Apache License, Version 2.0
 * http://www.apache.org/licenses/LICENSE-2.0.html
 * 
 * @version 1.0.0 
 * @author Wikitude GmbH; www.wikitude.com
 */
public class WikitudePluginExtended extends WikitudePlugin {


	static {
		System.loadLibrary( "QCAR" );
	}

	/**
	 * Architect-Configuration required for proper set-up
	 * @param apiKey
	 * @return
	 */
	@Override
	protected ArchitectConfig getArchitectConfig( final String apiKey ) {
		final ArchitectConfig config = super.getArchitectConfig( apiKey );

		/* required for Vuforia */
		config.setVuforiaInterface( new VuforiaServiceImplementation() );
		return config;
	}

	/* required for Vuforia */
	private class VuforiaServiceImplementation implements VuforiaInterface {

		@Override
		public void deInit() {
			QCAR.deinit();
		}

		@Override
		public int init() {
			return QCAR.init();
		}

		@Override
		public void onPause() {
			QCAR.onPause();
		}

		@Override
		public void onResume() {
			QCAR.onResume();
		}

		@Override
		public void onSurfaceChanged( final int arg0, final int arg1 ) {
			QCAR.onSurfaceChanged( arg0, arg1 );
		}

		@Override
		public void onSurfaceCreated() {
			QCAR.onSurfaceCreated();
		}

		@Override
		public void setInitParameters( final Activity activity, final int nFlags ) {
			QCAR.setInitParameters( activity, nFlags );
		}

	}

}
