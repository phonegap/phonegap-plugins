package dell.phoneGap.localization;

import java.lang.reflect.Field;
import java.util.Locale;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Context;
import android.text.TextUtils;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class Localizable extends Plugin {

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		try {
			Context ctx = this.ctx.getApplicationContext();
			if (action.equals("get")) {
				String name = args.getString(0);
				String languageCode = args.getString(1);
				String value = get(ctx, name, languageCode);
				return new PluginResult(PluginResult.Status.OK, value);
			} else if (action.equals("values")) {
				String languageCode = args.getString(0);
				JSONObject values = values(ctx, languageCode);
				return new PluginResult(PluginResult.Status.OK, values);
			} else
				return new PluginResult(PluginResult.Status.INVALID_ACTION);
		} catch (Exception ex) {
			return new PluginResult(PluginResult.Status.ERROR, ex.getMessage());
		}
	}

	public static String get(Context ctx, String key, String languageCode)
			throws JSONException {
		if (_localeValues == null)
			Init(ctx, languageCode);
		if (_localeValues == null)
			return "";
		return _localeValues.get(key).toString();
	}

	public static JSONObject values(Context ctx, String languageCode)
			throws JSONException {
		if (_localeValues == null)
			Init(ctx, languageCode);
		return _localeValues;
	}

	private static JSONObject _localeValues;
	private static String _localeLanguageCode;

	private static void Init(Context ctx, String languageCode) {
		if (_localeLanguageCode != null
				&& _localeLanguageCode.contentEquals(languageCode)
				&& _localeValues != null)
			return;

		JSONObject localeValues = new JSONObject();
		// Check language is valid
		if (TextUtils.isEmpty(languageCode))
			languageCode = Locale.getDefault().getLanguage();
		// Build an array of resource strings from given language
		Field[] allString = R.string.class.getFields();
		for (int i = 0; i < allString.length; i++) {
			try {
				Field field = allString[i];
				String fieldName = field.getName();
				String fieldValue = ctx.getString(field.getInt(R.string.class));
				if (TextUtils.isEmpty(fieldName)
						|| TextUtils.isEmpty(fieldValue))
					continue;
				// fieldValue = JSONObject.quote(fieldValue)
				localeValues.put(fieldName, fieldValue);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		_localeValues = localeValues;
		_localeLanguageCode = languageCode;
	}

}
