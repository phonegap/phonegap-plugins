package menupluginexample;

import com.phonegap.plugins.menu.DroidGapMenuActivity;

import android.os.Bundle;

public class AndroidMenuPluginActivity extends DroidGapMenuActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        super.loadUrl("file:///android_asset/www/index.html");
    }
}
