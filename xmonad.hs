import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.SetWMName

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/luis/.xmobarrc"
  xmonad $ defaultConfig {
    terminal = "terminator",
    startupHook = setWMName "LG3D",
    manageHook = manageDocks <+> manageHook defaultConfig,
    layoutHook = avoidStruts  $  layoutHook defaultConfig,
    logHook = dynamicLogWithPP xmobarPP { 
      ppOutput = hPutStrLn xmproc,
      ppTitle = xmobarColor "green" "" . shorten 50
      }
    }
