-- Disable window animation
hs.window.animationDuration = 0

hs.grid.MARGINX    = 0
hs.grid.MARGINY    = 0
hs.grid.GRIDHEIGHT = 10
hs.grid.GRIDWIDTH  = 10

--------------------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------------------
local NAMES = { iTerm2 = "iTerm", iTerm = "iTerm" }
local pn    = { fn = {} }

function hs.application:standardWindows()
    return hs.fnutils.filter(self:allWindows(), function(w)
        return w:id() and w:isStandard() and w:title() ~= ""
    end)
end

function hs.hints.applicationHints(app)
    if app then
        hs.hints.windowHints(app:allWindows())
    else
        hs.hints.windowHints()
    end
end

function hs.appfinder.appsFromName(name)
    return hs.fnutils.filter(hs.application.runningApplications(), function(app)
        return app:title() == name
    end)
end

function pn.reload(files)
    hs.reload()
end

function pn.normalWindow()
    local win = hs.window.focusedWindow()
    if win and win:isFullScreen() then win = nil end
    return win
end

function pn.snapWindow()
    local win = pn.normalWindow()
    if win then hs.grid.snap(win) end
end

function pn.toggleFullScreen()
    local win = hs.window.focusedWindow()
    if not win then return end
    win:toggleFullScreen()
end

function pn.maximizeWindow()
    local win = pn.normalWindow()
    if win then win:maximize() end
end

function pn.minimizeWindow()
    local win = pn.normalWindow()
    if not win then return end

    win:minimize()

    local nextWindow = hs.fnutils.find(hs.window.orderedWindows(), function(win)
        return not win:isMinimized()
    end)

    if nextWindow then nextWindow:focus() end
end

function pn.unminimizeAllWindows()
    local allWindows = hs.fnutils.filter(hs.window.allWindows(), function(win)
        return win:isMinimized()
    end)

    hs.fnutils.each(allWindows, function(win)
        win:unminimize()
    end)

    if #allWindows > 0 then
        allWindows[#allWindows]:focus()
    end
end

function pn.toggleMinimizing()
    local win = hs.window.focusedWindow()

    if not win then
        pn.unminimizeAllWindows()
    else
        pn.minimizeWindow()
    end
end

function pn.centralizeWindow()
    local win = pn.normalWindow()
    if not win then return end

    local winFrame    = win:frame()
    local screenFrame = win:screen():frame()

    win:setFrame({
        x = screenFrame.x + (screenFrame.w - winFrame.w) / 2,
        y = screenFrame.y + (screenFrame.h - winFrame.h) / 2,
        w = winFrame.w,
        h = winFrame.h
    })
end

function pn.moveWindowToScreen(win, newScreen)
    local frame           = win:frame()
    local screenFrame     = win:screen():frame()
    local nextScreenFrame = newScreen:frame()

    frame.x = nextScreenFrame.x + ((frame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w
    frame.y = nextScreenFrame.y + ((frame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h
    frame.w = math.min(frame.w, nextScreenFrame.w)
    frame.h = math.min(frame.h, nextScreenFrame.h)

    win:setFrame(frame)
end

function pn.moveWindowToNextScreen()
    local win = pn.normalWindow()
    if win and win:screen():next() then pn.moveWindowToScreen(win, win:screen():next()) end
end

function pn.moveWindowToPreviousScreen()
    local win = pn.normalWindow()
    if win and win:screen():previous() then pn.moveWindowToScreen(win, win:screen():previous()) end
end

function pn.moveWindowToNextScreenWithScaling()
    local win = pn.normalWindow()
    if win and win:screen():next() then win:moveToScreen(win:screen():next()) end
end

function pn.moveWindowToPreviousScreenWithScaling()
    local win = pn.normalWindow()
    if win and win:screen():previous() then win:moveToScreen(win:screen():previous()) end
end

function pn.handle(fn)
    return function()
        local win = pn.normalWindow()
        if not win then return end
        fn()
    end
end

function pn.moveWindowToUnit(unit)
    local win = pn.normalWindow()
    if win then win:moveToUnit(unit) end
end

function pn.moveWindowToTopLeft()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.5, h = 0.5 })
end

function pn.moveWindowToTopRight()
    pn.moveWindowToUnit({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
end

function pn.moveWindowToBottomLeft()
    pn.moveWindowToUnit({ x = 0, y = 0.5, w = 0.5, h = 0.5 })
end

function pn.moveWindowToBottomRight()
    pn.moveWindowToUnit({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
end

function pn.moveWindowToTopHalf()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 1.0, h = 0.5 })
end

function pn.moveWindowToBottomHalf()
    pn.moveWindowToUnit({ x = 0, y = 0.5, w = 1.0, h = 0.5 })
end

function pn.moveWindowToLeftHalf()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.5, h = 1.0 })
end

function pn.moveWindowToRightHalf()
    pn.moveWindowToUnit({ x = 0.5, y = 0, w = 0.5, h = 1.0 })
end

function pn.moveWindowToLeft60()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.6, h = 1.0 })
end

function pn.moveWindowToRight40()
    pn.moveWindowToUnit({ x = 0.6, y = 0, w = 0.4, h = 1.0 })
end

function pn.moveWindowToLeft40()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.4, h = 1.0 })
end

function pn.moveWindowToRight60()
    pn.moveWindowToUnit({ x = 0.4, y = 0, w = 0.6, h = 1.0 })
end

function pn.moveWindowToLeft65()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.65, h = 1.0 })
end

function pn.moveWindowToRight35()
    pn.moveWindowToUnit({ x = 0.65, y = 0, w = 0.35, h = 1.0 })
end

function pn.moveWindowToLeft35()
    pn.moveWindowToUnit({ x = 0, y = 0, w = 0.35, h = 1.0 })
end

function pn.moveWindowToRight65()
    pn.moveWindowToUnit({ x = 0.35, y = 0, w = 0.65, h = 1.0 })
end

function pn.moveWindowToGrid(xcell, ycell, gridSize)
    local win = pn.normalWindow()
    if not win then return end

    local xratio      = (gridSize >= xcell) and (gridSize - xcell) / 2.0 or 0.0
    local yratio      = (gridSize >= ycell) and (gridSize - ycell) / 2.0 or 0.0
    local screenFrame = win:screen():frame()

    win:setFrame({
        x = screenFrame.x + screenFrame.w / gridSize * xratio,
        y = screenFrame.y + screenFrame.h / gridSize * yratio,
        w = screenFrame.w / gridSize * xcell,
        h = screenFrame.h / gridSize * ycell
    })
end

function pn.moveWindowTo6x6()
    pn.moveWindowToGrid(6, 6, 8)
end

function pn.moveWindowTo6x7()
    pn.moveWindowToGrid(6, 7, 8)
end

function pn.moveWindowTo6x8()
    pn.moveWindowToGrid(6, 8, 8)
end

function pn.moveWindowTo7x8_5()
    pn.moveWindowToGrid(7, 8.5, 9)
end

function pn.focusUp()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowNorth() end
end

function pn.focusDown()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowSouth() end
end

function pn.focusLeft()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowWest() end
end

function pn.focusRight()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowEast() end
end

function pn.open(name)
    local apps = hs.appfinder.appsFromName(name)

    if #apps == 0 or (#apps == 1 and #apps[1]:allWindows() < 2) then
        hs.application.launchOrFocus(NAMES[name] or name)
    else
        pn.activate(name, apps)
    end
end

function pn.fn.open(name)
    return function()
        pn.open(name)
    end
end

function pn.nextWindow(app, win)
    local windows = app:standardWindows()

    table.sort(windows, function(a, b)
        return a:id() < b:id()
    end)

    local nextWindow = hs.fnutils.find(windows, function(w)
        return w:id() > win:id()
    end)

    return (nextWindow or windows[1])
end

function pn.nextApplication(apps, app)
    local applications = hs.fnutils.copy(apps)

    table.sort(applications, function(a, b)
        return a:pid() < b:pid()
    end)

    local nextApplication = hs.fnutils.find(applications, function(a)
        return a:pid() > app:pid()
    end)

    return (nextApplication or applications[1])
end

function pn.activateApplication(app, win)
    local mainWindow

    if win then mainWindow = pn.nextWindow(app, win) end

    if not mainWindow then
        local windows = app:standardWindows()
        mainWindow = app:mainWindow() or windows[#windows]
    end

    if mainWindow then mainWindow:unminimize() end

    app:activate(false)
end

function pn.activate(name, applications)
    local apps = applications or hs.appfinder.appsFromName(name)

    if #apps == 0 then return end

    local win = hs.window.focusedWindow()

    if #apps == 1 then
        if win and win:application():pid() == apps[1]:pid() then
            pn.activateApplication(apps[1], win)
        else
            pn.activateApplication(apps[1])
        end
    else
        local app = apps[#apps]

        if win then app = pn.nextApplication(apps, win:application()) end

        pn.activateApplication(app)
    end
end

function pn.fn.activate(name)
    return function()
        pn.activate(name)
    end
end

function pn.openInitialApplications()
    hs.alert.show("Opening initial applications...")
    pn.open("Skype")
    pn.open("Upwork")
    pn.open("Google Chrome")
    pn.open("iTerm2")
end

function pn.windowHints()
    local win = hs.window.focusedWindow()
    if win then
        hs.hints.windowHints(win:otherWindowsAllScreens())
    else
        hs.hints.windowHints()
    end
end

function pn.applicationHints()
    local win = hs.window.focusedWindow()
    if win then
        hs.hints.applicationHints(win:application())
    else
        pn.windowHints()
    end
end

function pn.itermHints()
    hs.hints.applicationHints(hs.appfinder.appFromName("iTerm2"))
end

function pn.chromeHints()
    hs.hints.applicationHints(hs.appfinder.appFromName("Google Chrome"))
end

--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------
local cmd    = { "cmd" }
local winKey = { "ctrl", "alt", "cmd" }
local appKey = { "ctrl", "alt", "cmd", "shift" }

-- Snap window
hs.hotkey.bind(winKey, "Space", pn.snapWindow)

-- Toggle fullscreen
hs.hotkey.bind(winKey, "Return", pn.toggleFullScreen)

-- Maximize
hs.hotkey.bind(winKey, "M", pn.maximizeWindow)

-- Toggle minimizing
hs.hotkey.bind(winKey, "\\",  pn.toggleMinimizing)

-- Centralize
hs.hotkey.bind(winKey, "/", pn.centralizeWindow)

-- Move window to next / previous screen
hs.hotkey.bind(winKey, "N", pn.moveWindowToNextScreen)
hs.hotkey.bind(winKey, "P", pn.moveWindowToPreviousScreen)

hs.hotkey.bind(winKey, "[", pn.handle(hs.grid.pushWindowPrevScreen))
hs.hotkey.bind(winKey, "]", pn.handle(hs.grid.pushWindowNextScreen))

hs.hotkey.bind(winKey, "-", pn.moveWindowToNextScreenWithScaling)
hs.hotkey.bind(winKey, "=", pn.moveWindowToPreviousScreenWithScaling)

hs.hotkey.bind(cmd, "E",      pn.windowHints)
hs.hotkey.bind(cmd, "Escape", pn.applicationHints)

hs.hotkey.bind(winKey, ";", pn.itermHints)
hs.hotkey.bind(winKey, "'", pn.chromeHints)

hs.hotkey.bind(winKey, ",", pn.moveWindowToLeft65)
hs.hotkey.bind(winKey, ".", pn.moveWindowToRight35)

hs.hotkey.bind(winKey, "H", pn.moveWindowToLeftHalf)
hs.hotkey.bind(winKey, "J", pn.moveWindowToBottomHalf)
hs.hotkey.bind(winKey, "K", pn.moveWindowToTopHalf)
hs.hotkey.bind(winKey, "L", pn.moveWindowToRightHalf)

hs.hotkey.bind(winKey, "6", pn.moveWindowTo6x6)
hs.hotkey.bind(winKey, "7", pn.moveWindowTo6x7)
hs.hotkey.bind(winKey, "8", pn.moveWindowTo6x8)
hs.hotkey.bind(winKey, "9", pn.moveWindowTo7x8_5)

hs.hotkey.bind(winKey, 'Y', pn.handle(hs.grid.resizeWindowThinner))
hs.hotkey.bind(winKey, 'U', pn.handle(hs.grid.resizeWindowTaller))
hs.hotkey.bind(winKey, 'I', pn.handle(hs.grid.resizeWindowShorter))
hs.hotkey.bind(winKey, 'O', pn.handle(hs.grid.resizeWindowWider))

hs.hotkey.bind(winKey, 'UP',    pn.handle(hs.grid.pushWindowUp))
hs.hotkey.bind(winKey, 'DOWN',  pn.handle(hs.grid.pushWindowDown))
hs.hotkey.bind(winKey, 'LEFT',  pn.handle(hs.grid.pushWindowLeft))
hs.hotkey.bind(winKey, 'RIGHT', pn.handle(hs.grid.pushWindowRight))

-- Open my initial applications
hs.hotkey.bind(winKey, "0", pn.openInitialApplications)

-- Launch and focus applications
local apps = {
    { key = "1", name = "System Preferences" },
    { key = "2", name = "App Store"          },
    { key = "3", name = "iTunes"             },

    { key = "W", name = "Safari"             },
    { key = "E", name = "Mail"               },
    { key = "R", name = "Wunderlist"         },
    { key = "T", name = "Sublime Text"       },
    { key = "Y", name = "Terminal"           },
    { key = "U", name = "Upwork"             },
    { key = "I", name = "iTerm2"             },
    { key = "O", name = "oDesk Team"         },
    { key = "P", name = "pgAdmin3"           },

    { key = "A", name = "Android Studio"     },
    { key = "S", name = "Skype"              },
    { key = "D", name = "GoldenDict"         },
    { key = "F", name = "Finder"             },
    { key = "G", name = "Google Chrome"      },

    { key = ";", name = "LibreOffice"        },
    { key = "'", name = "PDF Reader X"       },

    { key = "Z", name = "Freeplane"          },
    { key = "X", name = "Xcode"              },
    { key = "C", name = "Chromium"           },
    { key = "V", name = "MacVim"             },
    { key = "B", name = "Firefox"            },
    { key = "N", name = "Evernote"           },
    { key = "M", name = "Monosnap"           }
}

hs.fnutils.each(apps, function(app)
    hs.hotkey.bind(appKey, app.key, pn.fn.open(app.name))
end)

-- Activate application
apps = {
    { key = "[", name = "Git Gui" },
    { key = "]", name = "Wish"    }
}

hs.fnutils.each(apps, function(app)
    hs.hotkey.bind(appKey, app.key, pn.fn.activate(app.name))
end)

-- Focus application by directions
hs.hotkey.bind(appKey, 'H', pn.focusLeft)
hs.hotkey.bind(appKey, 'J', pn.focusDown)
hs.hotkey.bind(appKey, 'K', pn.focusUp)
hs.hotkey.bind(appKey, 'L', pn.focusRight)

hs.pathwatcher.new(hs.configdir, pn.reload):start()

hs.alert.show("Hammerspoon started!")
