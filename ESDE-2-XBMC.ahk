#Requires AutoHotkey v2.0
#SingleInstance Force


;;;;; Vars
XBOutDir := A_ScriptDir "\2XBox"
if DirExist(XBOutDir)
    DirDelete(XBOutDir,1)

DirCreate(XBOutDir)

ESDEDir := A_ScriptDir "\ES-DE"
ESDEDataDir := ESDEDir "\ES-DE"
ESDEGLDir := ESDEDataDir "\gamelists"
ESDEMediaDir := ESDEDataDir "\downloaded_media"
ESDEROMsDir := ESDEDir "\ROMs"

SynopsiDir := XBOutDir "\Synopsi"

if not DirExist(SynopsiDir)
    DirCreate(SynopsiDir)

;;;;; Vars

TT:="starting"
settimer ToolTipIt,1

Loop Files ESDEGLDir "\*" , "D" {
    TT:="Processing synopsi for " A_LoopFileName

    XML := ESDEGLDir "\" A_LoopFileName "\gamelist.xml"
    if FileExist(XML)
        Gamelist2Synopsi(XML)

    TT:=""

}

Loop Files ESDEMediaDir "\*" , "D" {
    TT:="Processing media for " A_LoopFileName

    MediaDir := ESDEMediaDir "\" A_LoopFileName
    if DirExist(MediaDir)
        Media2Xmedia(MediaDir)

    TT:=""

}
ExitApp


;;;;;;;;;;;Functions

Media2Xmedia(MediaDir) {
    SplitPath MediaDir, &SystemName

    XmediaOutDir:= XBOutDir "\RomsMedia"

    ;if DirExist(XmediaOutDir)
    ;    DirDelete(XmediaOutDir,1)

    DirCreate(XmediaOutDir)
    MediaDirs  := ["covers", "3dboxes",   "marquees", "miximages", "titlescreens", "videos"]
    XmediaDirs := ["boxart", "boxart3d",  "logo",     "mix",       "screenshots",  "videos"]

    loop XmediaDirs.Length {
        from:=MediaDir "\" MediaDirs[A_Index]
        to:= XmediaOutDir "\" SystemName "\" XmediaDirs[A_Index]
        ;msgbox from "`n" to
        DirCopy(from, to, 1)
    }
}


Gamelist2Synopsi(XML) {

    SplitPath(XML, &XMLName, &XMLDir, &XMLExt, &XMLNameNoExt, &XMLDrive)
    SplitPath(XMLDir, &SystemName)
    ;msgbox SystemName

    GamesArray := []
    ParsingGame := false
    ParsingDesc := false

    Global ThisSynopsiDir := ""
    Global ThisSynopsisFileFullPath := ""
    Global ThisGameFullPath := ""
    Global ThisGameName := ""
    Global ThisGameReleaseYear := ""
    Global ThisGameDeveloper := ""
    Global ThisGamePublisher := ""
    Global ThisGameGenre := ""
    Global ThisGamePlayers := ""

    Global ThisGameDeats := ""

    Global ThisGameDesc := ""

    loop read XML {
        ThisLineRaw:=A_LoopReadLine
        ThisLine:=StrReplace(A_LoopReadLine,A_Tab)
        if (ParsingGame = false and ThisLine = "<game>") {
            ParsingGame := true
            Global ThisSynopsiDir := ""
            Global ThisSynopsisFileFullPath := ""
            Global ThisGameFullPath := ""
            Global ThisGameName := ""
            Global ThisGameReleaseYear := ""
            Global ThisGameDeveloper := ""
            Global ThisGamePublisher := ""
            Global ThisGameGenre := ""
            Global ThisGamePlayers := ""
        
            Global ThisGameDeats := ""
        
            Global ThisGameDesc := ""
            continue
        }

        if ParsingGame {
            if ParsingDesc {
                ThisGameDesc .= StrReplace(ThisLine,"</desc>") "`n"
                if InStr(ThisLine,"</desc>") {
                    ParsingDesc := false
                    ;msgbox "ThisGameDesc:`n" ThisGameDesc
                }
                continue
            }


            ;msgbox "Parsing:`n`n" ThisLine
            if InStr(ThisLine,"<path>") {
                ThisGameFullPath := ThisLine
                ThisGameFullPath := StrReplace(ThisGameFullPath,"<path>")
                ThisGameFullPath := StrReplace(ThisGameFullPath,"</path>")
                ThisGameFullPath := StrReplace(ThisGameFullPath,"./",ESDEROMsDir "\" SystemName "\")
                ;msgbox "ThisGameFullPath:`n" ThisGameFullPath "`n" (FileExist(ThisGameFullPath) ? "Exists" : "Not Found")
            }
            if InStr(ThisLine,"<name>") {
                ThisGameName := ThisLine
                ThisGameName := StrReplace(ThisGameName,"<name>")
                ThisGameName := StrReplace(ThisGameName,"</name>")
                ;ThisGameName := StrReplace(ThisGameName,"./",ESDEROMsDir "\" SystemName "\")
                ;msgbox "ThisGameName:`n" ThisGameName
            }
            if InStr(ThisLine,"<desc>") {
                if InStr(ThisLine,"</desc>") {
                    ThisGameDesc := StrReplace(ThisLine,"<desc>") "`n"
                    ThisGameDesc := StrReplace(ThisGameDesc,"</desc>") "`n"
                } else {
                    ParsingDesc := true
                    ThisGameDesc := StrReplace(ThisLine,"<desc>") "`n"
                }
            }
            if InStr(ThisLine,"<releasedate>") {
                ThisGameReleaseYear := ThisLine
                ThisGameReleaseYear := StrReplace(ThisGameReleaseYear,"<releasedate>")
                ThisGameReleaseYear := StrReplace(ThisGameReleaseYear,"</releasedate>")
                ThisGameReleaseYear := SubStr(ThisGameReleaseYear, 1, 4)

                ;msgbox "ThisGameReleaseYear:`n" ThisGameReleaseYear
            }
            if InStr(ThisLine,"<developer>") {
                ThisGameDeveloper := ThisLine
                ThisGameDeveloper := StrReplace(ThisGameDeveloper,"<developer>")
                ThisGameDeveloper := StrReplace(ThisGameDeveloper,"</developer>")

                ;msgbox "ThisGameDeveloper:`n" ThisGameDeveloper
            }
            if InStr(ThisLine,"<publisher>") {
                ThisGamePublisher := ThisLine
                ThisGamePublisher := StrReplace(ThisGamePublisher,"<publisher>")
                ThisGamePublisher := StrReplace(ThisGamePublisher,"</publisher>")

                ;msgbox "ThisGamePublisher:`n" ThisGamePublisher
            }
            if InStr(ThisLine,"<players>") {
                ThisGamePlayers := ThisLine
                ThisGamePlayers := StrReplace(ThisGamePlayers,"<players>")
                ThisGamePlayers := StrReplace(ThisGamePlayers,"</players>")

                ;msgbox "ThisGamePlayers:`n" ThisGamePlayers
            }
            if InStr(ThisLine,"</Game>") {
                ParsingGame := false

                ThisSynopsiDir := SynopsiDir "\" SystemName
                if not DirExist(ThisSynopsiDir)
                    DirCreate(ThisSynopsiDir
                )
                SplitPath ThisGameFullPath ,,,, &ThisGameNameNoExt
                ThisSynopsisFileFullPath := ThisSynopsiDir "\" ThisGameNameNoExt ".txt"
                if FileExist(ThisSynopsisFileFullPath)
                    FileDelete(ThisSynopsisFileFullPath)
                ;msgbox ThisSynopsisFileFullPath
                FileAppend(ConstructSynopsis(ThisGameName,ThisGameReleaseYear,ThisGameDeveloper,ThisGamePublisher,ThisGameGenre,ThisGamePlayers,ThisGameDesc),ThisSynopsisFileFullPath)
            }
        }

    }

}

ConstructSynopsis(ThisGameName,ThisGameReleaseYear,ThisGameDeveloper,ThisGamePublisher,ThisGameGenre,ThisGamePlayers,ThisGameDesc) {

    Global ThisGameDeats := "" ThisGameName "`n"

    if not (ThisGameReleaseYear = "")
        Global ThisGameDeats .= "Release Year: " ThisGameReleaseYear "`n"

    if not (ThisGameDeveloper = "")
        Global ThisGameDeats .= "Developer: " ThisGameDeveloper "`n"

    if not (ThisGamePublisher = "")
        Global ThisGameDeats .= "Publisher: " ThisGamePublisher "`n"

    if not (ThisGameGenre = "")
        Global ThisGameDeats .= "Genre: " ThisGameGenre "`n"

    if not (ThisGamePlayers = "")
        Global ThisGameDeats .= "Players: " ThisGamePlayers "`n"

    Global ThisGameDeats .= "_________________________`n`n"
    Global ThisGameDeats .= ThisGameDesc
    return ThisGameDeats
}

ResetGLVars() {
    Global ThisSynopsiDir := ""
    Global ThisSynopsisFileFullPath := ""
    Global ThisGameFullPath := ""
    Global ThisGameName := ""
    Global ThisGameReleaseYear := ""
    Global ThisGameDeveloper := ""
    Global ThisGamePublisher := ""
    Global ThisGameGenre := ""
    Global ThisGamePlayers := ""

    Global ThisGameDeats := ""

    Global ThisGameDesc := ""

}

ToolTipIt() {
    global TT
    tooltip TT
}
