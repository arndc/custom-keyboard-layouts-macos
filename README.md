# Custom keyboard layouts for macOS

This repository offers custom keyboard layouts for macOS, 
enabling users to tailor their keyboard mappings for a personalized experience.

## Installation

### Manual installation

1. Download the desired bundle's `.bundle` file from the directory [layouts](./layouts)
2. Place the `.bundle` file in either `/Library/Keyboard Layouts` (for all users) 
or `~/Library/Keyboard Layouts` (for personal use)
3. Log out or restart your Mac to apply the changes
4. Navigate to **System Settings** > **Keyboard** > **Input Sources** and add the layout to your input sources

### Using Ukulele

_Prerequisites: install [Ukulele](https://software.sil.org/ukelele/), 
also available via [Homebrew](https://brew.sh/): `brew install --cask ukelele` 
([formulae](https://formulae.brew.sh/cask/ukelele))_

1. Download the desired bundle's `.bundle` file from the directory [layouts](./layouts)
2. In Ukulele, go to `File > Install` and select the desired bundle for installation
3. Log out or restart your Mac to apply the changes
4. In **System Settings** > **Keyboard** > **Input Sources**, add the layout to your input sources

## Uninstalling a layout

### Manual uninstallation

1. In **System Settings** > **Keyboard** > **Input Sources**, remove the layout from your input sources
2. Delete the `.bundle` file from either `/Library/Keyboard Layouts` (for all users) 
or `~/Library/Keyboard Layouts` (for personal use)
3. Log out or restart your Mac to apply the changes

### Using Ukulele

1. In **System Settings** > **Keyboard** > **Input Sources**, remove the layout from your input sources
2. In Ukulele, go to `File > Install` and select the desired bundle for uninstallation
3. Log out or restart your Mac to apply the changes

### Additional key mappings script (optional)

_You can optionally run the script below to remove additional key mappings in case you installed them._

Uninstalling the layout will not automatically remove the additional key mappings.
To remove them, run the command below from your layout's directory if present.

```zsh
sudo ./layouts/<layout>/additional-key-mappings.zsh --remove
```

or you can run the command below which will have the same effect.

```zsh
sudo ./scripts/reset-key-mappings.zsh
```

> **Note:** The `hidutil` command, used by the script, requires root privileges since macOS version 14.3.

## Supported layouts

Only the Belgian Period Layout is supported at the moment.

### Belgian Period

The Belgian Period layout for macOS is a customized AZERTY layout designed 
for users familiar with this layout from Windows or Linux. 
Since macOS lacks native support for this layout, the custom version serves as a viable alternative. 
The Option key functions as the `Alt Gr` key, with both the left and right Option keys mimicking this behavior.

#### Known issues

Two potential issues are recognized when using the Belgian Period layout. 
An additional script is available to address these issues for a smoother user experience, 
found at [layouts/belgian-period/additional-key-mappings.zsh](./layouts/belgian-period/additional-key-mappings.zsh).

The script uses the native `hidutil` command to remap keys on the keyboard. 
Since macOS version 14.3, the `hidutil` command requires root privileges to run.

> **Note:** These issues also occur with Apple's default Belgian or French key layouts.

##### Issue #1: External keyboard has incorrect key mappings

On external keyboards, the key above the tab key (key code 10) and
the key to the right of the left shift key (key code 50) are sometimes switched.
To resolve this issue, run the command below, replacing `MyExternalKeyboard` with the name of your external keyboard.
The name of your external keyboard can be found in **System Information** > **Hardware** > **USB** or **Bluetooth**.
Make sure to copy the name exactly as it appears in the list, including spaces and capitalization.
Sometimes, the name has a trailing space, which should be included as well.

```zsh
sudo ./additional-key-mappings.zsh --fix-layout-on-external-keyboard "MyExternalKeyboard"
```

##### Issue #2: Position of `Alt Gr` key on internal keyboard
The right command key is directly next to the space bar on the internal keyboard of a MacBook, 
causing inconvenience for users with muscle memory. The provided script swaps the right command key
with the right option key on the internal keyboard. As a result, the key serving as the `Alt Gr` key 
is now conveniently located next to the space bar. To resolve this issue, run the command below.

```zsh
sudo ./additional-key-mappings.zsh --swap-right-cmd-and-right-opt-on-internal-keyboard
```

## License

This project is licensed under the [MIT License](./LICENSE).
