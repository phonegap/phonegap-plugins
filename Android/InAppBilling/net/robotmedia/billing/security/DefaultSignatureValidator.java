/*   Copyright 2011 Robot Media SL (http://www.robotmedia.net)
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

package net.robotmedia.billing.security;

import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

import android.text.TextUtils;
import android.util.Log;
import net.robotmedia.billing.BillingController;
import net.robotmedia.billing.utils.Base64;
import net.robotmedia.billing.utils.Base64DecoderException;

public class DefaultSignatureValidator implements ISignatureValidator {

	protected static final String KEY_FACTORY_ALGORITHM = "RSA";
	protected static final String SIGNATURE_ALGORITHM = "SHA1withRSA";

	/**
	 * Generates a PublicKey instance from a string containing the
	 * Base64-encoded public key.
	 * 
	 * @param encodedPublicKey
	 *            Base64-encoded public key
	 * @throws IllegalArgumentException
	 *             if encodedPublicKey is invalid
	 */
	protected PublicKey generatePublicKey(String encodedPublicKey) {
		try {
			byte[] decodedKey = Base64.decode(encodedPublicKey);
			KeyFactory keyFactory = KeyFactory.getInstance(KEY_FACTORY_ALGORITHM);
			return keyFactory.generatePublic(new X509EncodedKeySpec(decodedKey));
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		} catch (InvalidKeySpecException e) {
			Log.e(BillingController.LOG_TAG, "Invalid key specification.");
			throw new IllegalArgumentException(e);
		} catch (Base64DecoderException e) {
			Log.e(BillingController.LOG_TAG, "Base64 decoding failed.");
			throw new IllegalArgumentException(e);
		}
	}

	private BillingController.IConfiguration configuration;

	public DefaultSignatureValidator(BillingController.IConfiguration configuration) {
		this.configuration = configuration;
	}

	protected boolean validate(PublicKey publicKey, String signedData, String signature) {
		Signature sig;
		try {
			sig = Signature.getInstance(SIGNATURE_ALGORITHM);
			sig.initVerify(publicKey);
			sig.update(signedData.getBytes());
			if (!sig.verify(Base64.decode(signature))) {
				Log.e(BillingController.LOG_TAG, "Signature verification failed.");
				return false;
			}
			return true;
		} catch (NoSuchAlgorithmException e) {
			Log.e(BillingController.LOG_TAG, "NoSuchAlgorithmException");
		} catch (InvalidKeyException e) {
			Log.e(BillingController.LOG_TAG, "Invalid key specification");
		} catch (SignatureException e) {
			Log.e(BillingController.LOG_TAG, "Signature exception");
		} catch (Base64DecoderException e) {
			Log.e(BillingController.LOG_TAG, "Base64 decoding failed");
		}
		return false;
	}

	public boolean validate(String signedData, String signature) {
		final String publicKey;
		if (configuration == null || TextUtils.isEmpty(publicKey = configuration.getPublicKey())) {
			Log.w(BillingController.LOG_TAG, "Please set the public key or turn on debug mode");
			return false;
		}
		if (signedData == null) {
			Log.e(BillingController.LOG_TAG, "Data is null");
			return false;
		}
		PublicKey key = generatePublicKey(publicKey);
		return validate(key, signedData, signature);
	}

}
