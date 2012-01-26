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

import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;

public class PGPolyphonicVoice implements OnPreparedListener, OnCompletionListener {

	private static final int INVALID = 0;
	private static final int PREPARED = 1;
	private static final int PENDING_PLAY = 2;
	private static final int PLAYING = 3;
	private static final int PENDING_LOOP = 4;
	private static final int LOOPING = 5;
	
	private MediaPlayer mp;
	private int state;
	
	public PGPolyphonicVoice( AssetFileDescriptor afd )  throws IOException
	{
		state = INVALID;
		mp = new MediaPlayer();
		mp.setDataSource( afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
		mp.setAudioStreamType(AudioManager.STREAM_MUSIC);  
		mp.prepare();
	}
	
	public void play() throws IOException
	{
		invokePlay( false );
	}
	
	private void invokePlay( Boolean loop )
	{
		Boolean playing = ( mp.isLooping() || mp.isPlaying() );
		if ( playing )
		{
			mp.pause();
			mp.setLooping(loop);
			mp.seekTo(0);
			mp.start();
		}
		if ( !playing && state == PREPARED )
		{
			state = PENDING_LOOP;
			onPrepared( mp );
		}
		else if ( !playing )
		{
			state = PENDING_LOOP;
			mp.setLooping(loop);
			mp.start();
		}
	}
	
	public void stop() throws IOException
	{
		if ( mp.isLooping() || mp.isPlaying() )
		{
			state = INVALID;
			mp.pause();
			mp.seekTo(0);
		}
	}
	
	public void loop() throws IOException
	{
		invokePlay( true );
	}
	
	public void unload() throws IOException
	{
		this.stop();
		mp.release();
	}
	
	public void onPrepared(MediaPlayer mPlayer) 
	{
		if (state == PENDING_PLAY) 
		{
			mp.setLooping(false);
			mp.seekTo(0);
			mp.start();
			state = PLAYING;
		}
		else if ( state == PENDING_LOOP )
		{
			mp.setLooping(true);
			mp.seekTo(0);
			mp.start();
			state = LOOPING;
		}
		else
		{
			state = PREPARED;
			mp.seekTo(0);
		}
	}
	
	public void onCompletion(MediaPlayer mPlayer)
	{
		if (state != LOOPING)
		{
			this.state = INVALID;
			try {
				this.stop();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
	}
}
