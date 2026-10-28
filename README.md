# cleanyourtv-patches

A few small patches for the [Clean Your TV](https://github.com/Gathin23/cleanyourtv) launcher, kept as a patch
collection and not as a fork: `git am` them on top of upstream, build as usual, install.
Made for a Google TV Streamer; the patches are small and touch only the launcher's Home screen.

Not affiliated with, or endorsed by, the Clean Your TV project.

## Patches

| Patch | What it does |
|---|---|
| `0001` weather line under the date | Shows the global setting `tvhome_weather` (for example `☁ 12°`) as a line under the date, right of the clock. The date moves up by one line while it is set. Hidden when the setting is empty, or when `tvhome_weather_at` (epoch seconds, optional) is older than 3 hours. |
| `0002` hide the greeting (optional) | Sets `show_greeting` to `false` in `config.xml`. Skip it to keep "Good evening" above the clock. |
| `0003` short date (optional) | The date beside the clock reads "Wed 28 Oct" instead of "Wednesday 28 October" (the launcher upper-cases it). Changes `date_format` in the default strings only; languages with their own `date_format_home`, such as German, keep theirs. Skip it to keep the long form. |

The launcher keeps its zero-network footprint: **it has no `INTERNET` permission and fetches nothing.** Something
else writes the setting. With adb:

```sh
adb shell settings put global tvhome_weather "☁ 12°"
adb shell settings put global tvhome_weather_at "$(date +%s)"   # optional: hides the line after 3 hours
adb shell settings delete global tvhome_weather                 # remove it
```

[`home-assistant/weather-header.yaml`](home-assistant/weather-header.yaml) is an automation that does this from a
Home Assistant weather entity every 30 minutes and whenever the weather or day/night changes: it picks the symbol
from the condition and uses a moon instead of a sun at night.

The line is refreshed within a minute of a change, or when Home comes back to the front.

## Use

```sh
git clone https://github.com/Gathin23/cleanyourtv
git clone https://github.com/pschmitt/cleanyourtv-patches
./cleanyourtv-patches/apply.sh ./cleanyourtv          # or: apply.sh ./cleanyourtv 0001
```

then build and install the launcher as upstream describes (JDK 17, Android SDK 34, `./gradlew assembleRelease`,
`adb install -r app/build/outputs/apk/release/app-release.apk`). `apply.sh` refuses a checkout with uncommitted
changes and uses `git am --3way`.

The patches were made against the commit in [`UPSTREAM`](UPSTREAM) and built there. On a newer upstream they
usually still apply; if one does not, `git am` names the hunk.

## Symbols

Symbols that render with the stock fonts on the Google TV Streamer: ☀ ⛅ ☁ 🌧 ⛈ ❄ 🌙. 🌫 (fog) shows as a grey box
there. Other TVs have other fonts, so check yours with a test value first.

## Limits

- Tested on one TV (Google TV Streamer, Google TV 14), with a launcher that replaced the stock home screen.
- A Hebrew or Arabic layout was not tried.
- The weather line has no icon art, only text symbols.

## Licence

MIT, the same as upstream: see [`LICENSE`](LICENSE).
