#include <stdio.h>
#include <stdlib.h>
#include "SDL.h"
#include "SDL_mixer.h"
#include "PDL.h"

#define MAX_SAMPLES 15
#define MAX_CHANNELS 4

static char paths[MAX_SAMPLES][255];
static Mix_Chunk *samples[MAX_SAMPLES];

static int currentChannel = 0;

static void PlaySound(const char *sound)
{
	// Look for the path
	int idx = 0;
	while (idx < MAX_SAMPLES && strcmp(paths[idx], sound) != 0) {
		idx++;
	}

	// Insert the path if not found
	if (idx >= MAX_SAMPLES) {
		idx = 0;
		while (idx < MAX_SAMPLES && strcmp(paths[idx], "") != 0) {
			idx++;
		}

		strcpy(paths[idx], sound);
		samples[idx] = Mix_LoadWAV(sound);
	}

	// Play the sound in the least busy channel
	Mix_PlayChannel(currentChannel, samples[idx], 0);

	currentChannel++;
	if (currentChannel >= MAX_CHANNELS) {
		currentChannel = 0;
	}
}

static PDL_bool play(PDL_JSParameters *params)
{
	if (PDL_GetNumJSParams(params) != 1) {
		PDL_JSException(params, "wrong number of parameters for play");

		return PDL_FALSE;
	}

	const char *sound = PDL_GetJSParamString(params, 0);

	SDL_Event event;
	event.user.type = SDL_USEREVENT;
	event.user.code = 0;
	event.user.data1 = strdup(sound);

	SDL_PushEvent(&event);

	return PDL_TRUE;
}

int main(int argc, char** argv)
{
	PDL_Init(0);
	SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);

	Mix_OpenAudio(44100, AUDIO_S16SYS, 2, 1024);
	Mix_AllocateChannels(MAX_CHANNELS);

	// Initialize the arrays
	for (int i = 0; i < MAX_SAMPLES; i++) {
		strcpy(paths[i], "");
		samples[i] = NULL;
	}

	PDL_RegisterJSHandler("play", play);
	PDL_JSRegistrationComplete();
	PDL_CallJS("ready", NULL, 0);

	SDL_Event event;
	do {
		SDL_WaitEvent(&event);

		if (event.type == SDL_USEREVENT && event.user.code == 0) {
			char *sound = (char *)event.user.data1;

			PlaySound(sound);

			free(sound);
		}
	} while (event.type != SDL_QUIT);

	for (int i = 0; i < MAX_SAMPLES; i++) {
		Mix_FreeChunk(samples[i]);
	}

	Mix_CloseAudio();

	PDL_Quit();
	SDL_Quit();

	return 0;
}
