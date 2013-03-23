/* MIT licensed */
// (c) 2013 Harshal Kulkarni,  CHK Sound LLC http://chksound.com/Speech/

using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Windows;
using Windows.Foundation;
using Windows.Phone.Speech.Recognition;
using Windows.Phone.Speech.Synthesis;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;

namespace Cordova.Extension.Commands
{
    class SpeechInteraction : BaseCommand
    {
        
        #region Speech objects

        // Speech synthesizer for prompting and confirming
        private SpeechSynthesizer speechOutput;

        // Speech Recognzier using the default dictation grammar from BING. -Data Connection Required
        private SpeechRecognizerUI speechInput;

        // Speech Recognzier for using SRGS/GRXML grammar files -Data Connection NOT Required
        private SpeechRecognizerUI srgsGrammar;

        // Speech Recognizer for using text based command list
        private SpeechRecognizerUI commandReco;

        // List of comma separated grammar instead of url.
        private List<string> grammarList = new List<string>();

        //Flag to be set after initialization of speech component is completed.
        private Boolean isInitialized = false;

        #endregion

        public SpeechInteraction()
        {
            InitializeSpeech();
        }


        /*----------------------- TTS --------------------------------------------*/

        [DataContract]
        public class TTSParameters
        {
            [DataMember]
            public string text { get; set; }

        }

        public async void playTTS(string options)
        {
            TTSParameters parameters = JsonHelper.Deserialize<TTSParameters>(options);
            SpeechSynthesizer speechOutput = new SpeechSynthesizer();
            await speechOutput.SpeakTextAsync(parameters.text);
            this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, parameters.text + " Played"));
        }
        /*---------------------------TTS ------------------------------------------*/

        /*--------------------- Speech Recognition --------------------------------*/


        [DataContract]
        public class SRParams
        {
            [DataMember]
            public string language { get; set; }

            [DataMember]
            public string grammarURI { get; set; }

            [DataMember]
            public string promptString { get; set; }

            [DataMember]
            public string commandList { get; set; }
        }

        public void initSpeech(string options)
        {
            if (!isInitialized)
            {
                InitializeSpeech();
                this.DispatchCommandResult(new PluginResult((isInitialized?PluginResult.Status.OK:PluginResult.Status.ERROR), ""));
            }
        }

        public void recognizeFromTextList(string options)
        {
            SRParams parameters = JsonHelper.Deserialize<SRParams>(options);
            if (!isInitialized) InitializeSpeech();
            RecoUsingCSVCommands(parameters.promptString, parameters.commandList);
        }

        public void recognizeUsingSRGS(string options)
        {
            SRParams parameters = JsonHelper.Deserialize<SRParams>(options);
            if (!isInitialized) InitializeSpeech();
            RecoUsingSRGSGrammar(parameters.promptString, parameters.grammarURI);
        }

        public void recognizeUsingDictation(string options)
        {
            SRParams parameters = JsonHelper.Deserialize<SRParams>(options);
            if (!isInitialized) InitializeSpeech();
            RecoUsingDictation(parameters.promptString);
        }

        #region Speech helper functions
        // Initializes the synthesizer object and two recognizer objects
        private void InitializeSpeech()
        {
            //TTS Object
            speechOutput = new SpeechSynthesizer();

            // Dictation Grammar Recognizer 
            speechInput = new SpeechRecognizerUI();
            speechInput.Settings.ExampleText = "";
            speechInput.Settings.ListenText = "Say ...";

            // Command List grammar recognizer.
            commandReco = new SpeechRecognizerUI();
            commandReco.Settings.ExampleText = "";
            commandReco.Settings.ListenText = "Say ...";

            srgsGrammar = new SpeechRecognizerUI();
            srgsGrammar.Settings.ExampleText = "";
            srgsGrammar.Settings.ListenText = "Say ...";
            
            //Set flag to true. Speech Components initialized
            isInitialized = true;
        }

        /*
         * This method will recognize the grammar based on the comma separated list passed to it. 
         * The result is handled in the CommandCompleted callback.
         */
        private async void RecoUsingCSVCommands(string promptString, string commandList)
        {
            if (commandList != null && commandList != "")
            {
                string[] commands = commandList.Split(',');
                foreach (string comm in commands)
                {
                    Console.WriteLine(comm);
                    if(!grammarList.Contains(comm))
                            grammarList.Add(comm);
                }
                commandReco.Settings.ListenText = promptString;
                try
                {
                    SpeechGrammarSet set1 = commandReco.Recognizer.Grammars;
                    if (!set1.ContainsKey("pluginGrammar"))
                    {
                        commandReco.Recognizer.Grammars.AddGrammarFromList("pluginGrammar", grammarList);
                    }
                }
                catch (Exception ex)
                {

                }
            }
            else
            {
                this.DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Grammar is not defined."));
                return;
            }
            // Prompt the user to say a command
            await speechOutput.SpeakTextAsync(promptString);
            var operation = commandReco.RecognizeWithUIAsync();
            operation.Completed = CommandCompleted;
        }

        /*
         * This method will recognize the grammar based on the comma separated list passed to it. 
         * The result is handled in the CommandCompleted callback.
         */
        private async void RecoUsingSRGSGrammar(string promptString, String grammarURI)
        {
            if (grammarURI != null && grammarURI != "")
            {
                Uri gUri = new Uri("ms-appx:///www/grammar/"+grammarURI);
                srgsGrammar.Settings.ListenText = promptString;
                try
                {
                    SpeechGrammarSet set1 = srgsGrammar.Recognizer.Grammars;
                    if (!set1.ContainsKey("SRGSGrammar"))
                    {
                        srgsGrammar.Recognizer.Grammars.AddGrammarFromUri("SRGSGrammar", gUri);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
            else
            {
                this.DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, "Grammar link is not found."));
                return;
            }
            // Prompt the user to say a command
            await speechOutput.SpeakTextAsync(promptString);
            var operation = srgsGrammar.RecognizeWithUIAsync();
            operation.Completed = CommandCompleted;
        }


        /*
         * This method will recognize the grammar based on the comma separated list passed to it. 
         * The result is handled in the CommandCompleted callback.
         */
        private async void RecoUsingDictation(string promptString)
        {
            // Prompt the user to say a command
            await speechOutput.SpeakTextAsync(promptString);
            var operation = speechInput.RecognizeWithUIAsync();
            operation.Completed = CommandCompleted;
        }



        // Callback for RecognizeWithUIAsync completion for use with the commandReco recognizer object. It takes the appropriate action based on 
        // the recognition result, which can be any button name or "save and try again", "try again", or "quit". Referenced in the "GetCommand" 
        // helper function
        private void CommandCompleted(IAsyncOperation<SpeechRecognitionUIResult> asyncInfo, AsyncStatus asyncStatus)
        {
            // Don't do anything if the recognition hasn't completed.
            if (asyncStatus != AsyncStatus.Completed)
            {
                return;
            }
            try
            {
                // Get the recognition result object
                SpeechRecognitionUIResult result = asyncInfo.GetResults();
                if (result.ResultStatus == SpeechRecognitionUIStatus.Succeeded) // 
                {
                     this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, result.RecognitionResult.Text));
                }else{
                    MessageBox.Show("An error occurred in speech recognition.");
                    return;
                }
           }
            catch (Exception ex)
            {
                MessageBox.Show("Exception in command recognition handler " + ex.Message);
            }
        }
        #endregion



    }//class
}
