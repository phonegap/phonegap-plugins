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

public interface ISignatureValidator {

	/**
	 * Validates that the specified signature matches the computed signature on
	 * the specified signed data. Returns true if the data is correctly signed.
	 * 
	 * @param signedData
	 *            signed data
	 * @param signature
	 *            signature
	 * @return true if the data and signature match, false otherwise.
	 */
	public boolean validate(String signedData, String signature);

}