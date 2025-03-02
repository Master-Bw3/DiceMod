#! /usr/bin/env nix-shell
#! nix-shell -i uiua -p uiua
User      ← "maple"
AppId     ← 2379780
LogDir    ← /◇⊂ {"/home/" User "/.steam/steam/steamapps/compatdata/" °⋕AppId "/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods/lovely/log/"}
StartTime ← now

&invk⊂ "steam://rungameid/" °⋕AppId

CheckFileCreated ← (
  ▽ ⊸(⬚@ ≠) LogDir    # extract file name
  ⍜(⇌|↘4) ↘ 7         # drop non-date part
  ⋕ ⊜□ ¬↥ ⊃(=@.|=@-). # parse date

  < StartTime °datetime # check not more recent
)

GetLatestLog ← (°□⊡0 ⇌⍆ &fld LogDir)

# loop until new the log file is created
⍢(&sl1
  ◌
  GetLatestLog
| CheckFileCreated
) 0

# dummy file and handle
"z" 0

# loop forever
⍢( # stack: filename, handle

  GetLatestLog
  ⤚(≠∩□)                  # check if most recent
  ⨬(                      # if current is most recent file:
    ⊙(&sl1 ∵&p↘1 &rl(□).) # print added line(s)
  |                       # else
    ⊙◌                    # remove old handle
    &fo.                  # open most recent
    &rl(&p).              # print file contents
    :
  )
| 1)
