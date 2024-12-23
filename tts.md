https://api.fish.audio/v1/tts

This endpoint only accepts application/json and application/msgpack.

For best results, upload reference audio using the create model before using this one. This improves speech quality and reduces latency.

To upload audio clips directly, without pre-uploading, serialize the request body with MessagePack as per the instructions.

Audio formats supported:

WAV / PCM
Sample Rate: 8kHz, 16kHz, 24kHz, 32kHz, 44.1kHz
Default Sample Rate: 44.1kHz
16-bit, mono
MP3
Sample Rate: 32kHz, 44.1kHz
Default Sample Rate: 44.1kHz
mono
Bitrate: 64kbps, 128kbps (default), 192kbps
Opus
Sample Rate: 48kHz
Default Sample Rate: 48kHz
mono
Bitrate: -1000 (auto), 24kbps, 32kbps (default), 48kbps, 64kbps

Authorizations
​
Authorization
string
header
required
Bearer authentication header of the form Bearer <token>, where <token> is your auth token.


text
string
required
Text to be converted to speech

​
references
object[] | null
References to be used for the speech, this requires MessagePack serialization, this will override reference_voices and reference_texts


Hide child attributes

​
references.audio
file
required
​
references.text
string
required
​
reference_id
string | null
ID of the reference model o be used for the speech

​
prosody
object | null
Prosody to be used for the speech


Hide child attributes

​
prosody.speed
number
default: 1
​
prosody.volume
number
default: 0
​
chunk_length
integer
default: 200
Chunk length to be used for the speech

Required range: 100 < x < 300
​
normalize
boolean
default: true
Whether to normalize the speech, this will reduce the latency but may reduce performance on numbers and dates

​
format
enum<string>
default: mp3
Format to be used for the speech

Available options: wav, pcm, mp3, opus 
​
sample_rate
integer | null
Sample rate to be used for the speech

​
mp3_bitrate
enum<integer>
default: 128
MP3 Bitrate to be used for the speech

Available options: 64, 128, 192 
​
opus_bitrate
enum<integer>
default: 32
Opus Bitrate to be used for the speech

Available options: -1000, 24, 32, 48, 64 
​
latency
enum<string>
default: normal
Latency to be used for the speech, balanced will reduce the latency but may lead to performance degradation

Available options: normal, balanced 

status 401 402
{
  "status": 123,
  "message": "<string>"
}
status 422
[
  {
    "loc": [
      "<string>"
    ],
    "type": "<string>",
    "msg": "<string>",
    "ctx": "<string>",
    "in": "path"
  }
]