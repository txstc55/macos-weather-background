# Macos Weather Background

The goal of the project is to let user automatically change background based on weather. This project only works with MacOS.

## Install
To install this project, simply

```bash
git clone https://github.com/txstc55/macos-weather-background
```

**_Note_:** You need to put this project into a publicly accessible place, like `/Users/your_user_name/`. This is because this project uses plist, and apple does not allow plist to access files in private directories like `~/Desktop`, `~/Documents` or `~/Download`.

After you cloned this project, you need to add the plist item into `~/Library/LaunchAgents/`:

```bash
cd macos-weather-background
mv com.txstc55.pick-bg.plist ~/Library/LaunchAgents/
mv com.txstc55.change-bg.plist ~/Library/LaunchAgents/
```

Fell free to change the name of the plist file. You will also need to modify the path in both plist files.

## Add image for corresponding weather

This project uses wttr.in as input for weather information. Upon receiving the weather info, it will check each sub-directory to see if the name matches. If a match is found, it will then locate all the image file in that sub-directory, randomly pick one to be the new image.

You can easily add images to corresponding sub-directory. If no match is found, the script will do two things:

1. The script will pick the default/default.img as the background
2. The script will output the weather string to `extra_weather_list.txt`.

You can always check `extra_weather_list.txt` to see if there's any weather you want to add.

## Change Interval
The reason there are two plists is because osascript doesn't always work when it's called from plist. Therefore, you can decrease `StartInterval` in `com.txstc55.change-bg.plist` to increase the chance for it to actually work. The default is 5 minutes.

The default for checking weather is 30 minutes. You can also change that in `com.txstc55.pick-bg.plist` under key `StartInterval`

## Manual Call

Alternatively, if plist is not working well with osascript, you can just add the following in your zshrc to call change background:

```bash
alias wbg="/path/to/changeBG.sh && osascript /path/to/changeBG.scpt"
```

And whenever you feel like it, just type `wbg` in terminal.
