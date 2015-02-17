 import XMonad
 import XMonad.Hooks.ManageDocks
 import XMonad.Hooks.DynamicLog
 import XMonad.Util.Run
 import XMonad.Util.EZConfig (additionalKeys)

 main = do
   xmproc <- spawnPipe "/usr/bin/xmobar /home/luis/.xmobarrc"
   xmonad $ defaultConfig {
   manageHook = manageDocks <+> manageHook defaultConfig,
   layoutHook = avoidStruts  $  layoutHook defaultConfig,
   logHook = dynamicLogWithPP xmobarPP
{ 
  ppOutput = hPutStrLn xmproc,
  ppTitle = xmobarColor "green" "" . shorten 50
  }
   }  `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        ]