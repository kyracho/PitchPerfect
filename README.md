# Pitch Perfect Tuner
The first watchOS app that combines a metronome, chromatic tuner, and chromatic scale player all in one.

<img width="311" alt="Screenshot 2024-08-25 at 7 29 34 PM" src="https://github.com/user-attachments/assets/df97b48b-cff2-4aba-9f3d-064d8e04f76d">

#### **Metronome**: 

<img width="302" alt="Screenshot 2024-08-25 at 7 29 50 PM" src="https://github.com/user-attachments/assets/c633491c-de9a-4077-9240-f6ee8daa586a">

- Supports tempos ranging from 40 BPM to 200 BPM.
- The scroll wheel can be used for quick adjustments.

#### **Chromatic Tuner**

<img width="304" alt="Screenshot 2024-08-25 at 7 36 24 PM" src="https://github.com/user-attachments/assets/6caeec93-2f5d-4b3e-857b-96011a4d4d71">

- Displays the detected frequency, identifies the closest matching note, and shows the ideal frequency for that note.
- Uses the microphone on the Apple Watch to detect audio input, processing it in real-time to determine the frequency of the sound. It does this by counting the zero-crossings in the audio signal to estimate the pitch, which is then averaged over a short buffer to smooth out fluctuations and reduce noise. The detected frequency is displayed on the screen in hertz, providing users with a stable and accurate representation of the sound's pitch.
  
#### **Play a Note**

<img width="305" alt="Screenshot 2024-08-25 at 7 29 58 PM" src="https://github.com/user-attachments/assets/e777c476-d7df-448a-b357-cf0d1632b5cb">

- "Play" begins the note. The arrows increment the note (and begin the note, if it's not already playing). "Stop" ends the note.
- The notes represent the middle octave of the piano:
  - 261.63 Hz: C
  - 277.18 Hz: C#
  - 293.66 Hz: D
  - 311.13 Hz: D#
  - 329.63 Hz: E
  - 349.23 Hz: F
  - 369.99 Hz: F#
  - 392.00 Hz: G
  - 415.30 Hz: G#
  - 440.00 Hz: A
  - 466.16 Hz: A#
  - 493.88 Hz: B

### Versions
___
Version 1.2: 
- Adds a metronome function
- Adds a chromatic tuner function
- Adopts a minimalistic UI

Version 1.1: 
- Fixes the stopping/freezing bug
- Adds fade-in and fade-out for a smoother experience
- Adds a new icon for improved identifiability
  
### Credits
___
@jpsim's idea to use zero crossings for the tuner. It resulted in simpler code with a higher accuracy compared to using FFT.
