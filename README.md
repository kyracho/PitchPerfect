### Welcome to Pitch Perfect Tuner

Hello, welcome. This is my watchOS app that combines a metronome, a chromatic tuner, and a note player in one. 

<img height="310" alt="Screenshot 2024-08-25 at 7 29 34 PM" src="https://github.com/user-attachments/assets/f9976730-cb27-460f-8fa5-1370744833d0">

You can choose between the three functionalities from the menu.

<img height="310" alt="Screenshot 2024-08-25 at 7 36 24 PM" src="https://github.com/user-attachments/assets/5230f656-fb6d-4f11-96e9-52fb6a7834ab">

The chromatic tuner works for a very wide range of frequencies, wide enough to be used with any musical instrument on the planet. The tuner itself is accurate to around 1 Hz, which is more accurate than the comparible tuner apps that I have found.

<img height="310" alt="Screenshot 2024-08-27 at 1 41 36 PM" src="https://github.com/user-attachments/assets/a6315a70-d5a3-4602-b619-474d428c5e6c">

The note player plays the notes of the chromatic scale. This will be useful if you prefer the old-school tuning fork method of tuning. This method is more accurate than the chromatic tuner. 

<img height="310" alt="Screenshot 2024-08-25 at 7 29 58 PM" src="https://github.com/user-attachments/assets/12e70d93-3516-4210-b60e-8bd5a80a5e62">

___

### Build the Pitch Perfect Tuner Watch App on Your Own Apple Watch

Follow these steps to build and run the **Pitch Perfect Tuner** app on your Apple Watch.

#### Step 1: Clone the Repository Locally
Start by cloning the repository to your local machine:
```bash
git clone https://github.com/kyracho/Pitch_Perfect.git
```
Navigate into the project directory:
```bash
cd Pitch_Perfect
```

#### Step 2: Open the Project in Xcode
1. Ensure you have the latest version of Xcode installed from the Mac App Store.
2. Open the `.xcodeproj` file to launch Xcode. You can do this by double-clicking the file or running:
   ```bash
   open Pitch Perfect Tuner.xcodeproj
   ```

#### Step 3: Verify Asset Files
Make sure all necessary assets (like app icons or any custom images) are correctly placed in the `Assets` folder. This ensures your app will display the correct icons and visuals on your Apple Watch.

#### Step 4: Set Up Your Apple Watch for Development
To run the app on your Apple Watch, you’ll need to follow these setup steps:

1. **Pair Your Apple Watch and iPhone**:
   - Ensure that your Apple Watch is paired with your iPhone.
   - Connect your iPhone to your Mac using a cable or Wi-Fi.

2. **Add Your Apple ID to Xcode**:
   - Open Xcode, then navigate to `Xcode > Settings > Accounts`.
   - Click the "+" button to add your Apple ID if you haven’t already done so.
   - Set your development team under the `Signing & Capabilities` tab of the project.

3. **Enable Developer Mode on Your Apple Watch**:
   - On your iPhone, go to the Watch app and enable Developer Mode via `General > Developer`.

#### Step 5: Select Your Apple Watch and Run the App
1. In Xcode, go to the device dropdown menu next to the "Run" button in the toolbar.
2. Select your Apple Watch from the list of available devices.
3. **Build and Run** the project by pressing the "Run" button (`Cmd + R`).

Xcode will build the app, install it on your Apple Watch, and launch the app automatically.

#### Step 6: Enjoy the Pitch Perfect Tuner App!
After the app is installed, you're all set to use the **Pitch Perfect Tuner** app on your Apple Watch. 


### **Versions**
___
Version 1.2
- Adopts minimalistic UI
- Adds metronome function
- Adds chromatic tuner function

Version 1.1 
- Fixes freezing bug
- Adds sound fade-in and sound fade-out

Version 1.0
- Initial release

### **Credits**
___
Thank you [@JPSim ](https://github.com/jpsim/ZenTuner) for the idea to use zero crossings for the chromatic tuner. My initial method using FFT was not as accurate.
