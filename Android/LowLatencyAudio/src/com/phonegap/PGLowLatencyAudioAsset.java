/*
THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.phonegap;

import java.io.IOException;
import java.util.ArrayList;

import android.content.res.AssetFileDescriptor;

public class PGLowLatencyAudioAsset {

	private ArrayList<PGPolyphonicVoice> voices;
	private int playIndex = 0;
	
	public PGLowLatencyAudioAsset(AssetFileDescriptor afd, int numVoices) throws IOException
	{
		voices = new ArrayList<PGPolyphonicVoice>();
		
		if ( numVoices < 0 )
			numVoices = 0;
		
		for ( int x=0; x<numVoices; x++) 
		{
			PGPolyphonicVoice voice = new PGPolyphonicVoice(afd);
			voices.add( voice );
		}
	}
	
	public void play() throws IOException
	{
		PGPolyphonicVoice voice = voices.get(playIndex);
		voice.play();
		playIndex++;
		playIndex = playIndex % voices.size();
	}
	
	public void stop() throws IOException
	{
		for ( int x=0; x<voices.size(); x++) 
		{
			PGPolyphonicVoice voice = voices.get(x);
			voice.stop();
		}
	}
	
	public void loop() throws IOException
	{
		PGPolyphonicVoice voice = voices.get(playIndex);
		voice.loop();
		playIndex++;
		playIndex = playIndex % voices.size();
	}
	
	public void unload() throws IOException
	{
		this.stop();
		for ( int x=0; x<voices.size(); x++) 
		{
			PGPolyphonicVoice voice = voices.get(x);
			voice.unload();
		}
		voices.removeAll(voices);
	}
	
}
