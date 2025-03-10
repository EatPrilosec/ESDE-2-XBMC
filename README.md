# ESDE-2-XBMC
**K**eep-**I**t-**S**imple-**S**tupid Solution to collecting rom metadata for Rocky5's XBMC-EmuStation

ES-DE is a VERY capable Emulationstation frontend for desktop environments. Conveniently, it stores its metadata almost the exact same way [Rocky5's XBMC-EmuStation](https://github.com/Rocky5/XBMC-Emustation/tree/master) 

this is a simple tool I made to convert/copy scraped metadata from ES-DE to the directory structure used by Rocky5's XBMC-EmuStation, and convert the gamelist.xml files for separate synopsis files.

This method:
- supports your personal rom naming scheme
- doesnt use python
- creates synopsis files based on your naming scheme
- doesnt require python
- scrapes faster than screenscraper's Skraper tool
- removes dependency of older defunct python 2.7
- allows for hacks/community roms that you manually set the metadata of
- did I mention its not using python 2.7 like, at all.
- I really dont like python

## Basic Guide:

1. [download and extract this repo](https://github.com/EatPrilosec/ESDE-2-XBMC/archive/refs/heads/main.zip) to its own folder somewhere. ie. `Downloads\ESDE-2-XBMC`

2. Download and install [AutoHotKey V2](https://www.autohotkey.com/download/)

3. Download and extract [ES-DE portable from gitlab releases](https://gitlab.com/es-de/emulationstation-de/-/releases),

   - it should be inside the repo folder, without the zip name as a dir.

   - ie. the ES-DE.exe should be located at ie `Downloads\ESDE-2-XBMC\ES-DE\ES-DE.exe` 

5. Move or copy your roms to the ROMs folder inside `Downloads\ESDE-2-XBMC\ES-DE\` setting the ROMs dir in ES-DE is untested, and i think might cause issues, but a symlink should suffice.

6. open ES-DE, use the scraper menu to scrape metadata for your games.

7. look through ES-DE, make sure all your ROMs look right and edit them if necessary

8. close ES-DE, run `ESDE-2-XBMC.ahk` by double clicking it.


## What does this tool do, specifically?
for now, it does two very basic operations:

1. Parse gamelist.xml's made by ES-DE protable, and converts them to synopsis.txt files for XBMC-Emustation to a hardcoded output directory (`Path\To\Ahk\Script\2XBox\Synopsi`),

   - this does not use an xml parser and is hacky

   - i will (probably) fix this at some point to be more robust, but any unaccounted for features of XML will cause issues

   - must copy synopsis files to `XBMC-Emustation\emustation\synopsis\(SYSTEM NAME)\` manually

3. Copy's downloaded media from ES-DE to a hardcoded output directory (`Path\To\Ahk\Script\2XBox\RomsMedia`),

   - must point XBMC-Emustation to this directory
  
   - XBMC's `boxart` gets populated from ES-DE's `cover` folder
 
   - XBMC's `boxart3d` gets populated from ES-DE's `3dboxes` folder
  
   - XBMC's `logo` gets populated from ES-DE's `marquees` folder
  
   - XBMC's `mix` gets populated from ES-DE's `miximages` folder
  
   - XBMC's `screenshots` gets populated from ES-DE's `titlescreens` folder
  
   - XBMC's `videos` gets populated from ES-DE's `videos` folder
  
   - that can be changed in the script via these lines:

```
MediaDirs  := ["covers", "3dboxes",   "marquees", "miximages", "titlescreens", "videos"]
XmediaDirs := ["boxart", "boxart3d",  "logo",     "mix",       "screenshots",  "videos"]
```



