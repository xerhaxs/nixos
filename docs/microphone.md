# Microphone: Rode Procaster on a Behringer UMC22

The EasyEffects preset `microphone` (`homeModules/applications/media/easyeffects-microphone.json`) is tuned for this chain.

## Hardware

- Connect the Procaster with XLR to input 1 of the UMC22 and leave 48V off, a dynamic microphone does not need it.
- The Procaster has a low output (-56 dB re 1 V/Pa, 1.6 mV at 94 dB SPL), so the preamp runs high. About 38 dB of gain are needed for -18 dBFS at 94 dB SPL (estimate from the data sheets, the UMC22 maximum is not published). Set the gain knob so that normal speech peaks around -18 to -12 dBFS and never lights the clip LED, about 70 to 90 percent of the knob.
- Speak from 5 to 10 cm, slightly past the capsule. The microphone has a pop filter, the proximity effect adds low end.

## Chain

| Step | Setting | Why |
|---|---|---|
| Stereo Tools | LR > LL | The UMC22 delivers input 1 on the left channel only. On input 2 use `LR > RR`. |
| DeepFilterNet | limit 18 dB | Removes the hiss of the preamp at high gain, the limit keeps the voice natural. |
| Gate | threshold -52 dB, reduction -15 dB, release 180 ms | Soft, lowers the room between sentences without cutting word ends. |
| Equalizer | high-pass 85 Hz, -2.5 dB at 200 Hz, -1.5 dB at 450 Hz, +1.5 dB at 3 kHz, +1 dB shelf at 10 kHz | The Procaster starts at 75 Hz and has a bump around 200 Hz, so little high end is added: it already rises between 5 and 10 kHz. |
| Compressor | 3:1, threshold -20 dB, attack 10 ms, release 120 ms, makeup 6 dB | Evens out the level, makeup compensates the low output. |
| De-esser | 5 and 8 kHz, ratio 4 | Sibilants, the rising high end makes them stronger. |
| Limiter | -1 dB | Protects against clipping. |

## Fine tuning

- Room or preamp noise audible in pauses: raise the gate threshold in steps of 2 dB.
- Word ends cut off: lower the threshold or raise the release.
- Voice too thin: reduce the cut at 200 Hz.
- Sharp sibilants: lower the de-esser threshold.

The values are a starting point from the data sheets and were not measured with the real microphone.

The preset is active on every client; other microphones need other values (at least Stereo Tools).
