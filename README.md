# TF2 Reborn Source code.
again messy code, code base is from betam TF-Solo, as i didnt not had any experience with C++ before so
Build instructions
Clone the repository using the following command:

git clone https://github.com/snowy-s-stupid-studio/TF-REBORN-REWRITE

Windows
Requirements:

Source SDK 2013 Multiplayer installed via Steam
Visual Studio 2022 with the following workload and components:
Desktop development with C++:
MSVC v143 - VS 2022 C++ x64/x86 build tools (Latest)
Windows 11 SDK (10.0.22621.0) or Windows 10 SDK (10.0.19041.1)
Python 3.13 or later
Inside the cloned directory, navigate to src, run:

createallprojects.bat
This will generate the Visual Studio project everything.sln which will be used to build your mod.

Then, on the menu bar, go to Build > Build Solution, and wait for everything to build.

You can then select the Client (Mod Name) project you wish to run, right click and select Set as Startup Project and hit the big green > Local Windows Debugger button on the tool bar in order to launch your mod.

The default launch options should be already filled in for the Release configuration.
