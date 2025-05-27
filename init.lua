-- List of hotkeys to focus app and hide others
local optionKeys = {
    a = "zen",
    s = "Cursor",
    d = "Slack",
    f = "Figma",
    o = "Obsidian",
    z = "Finder",
    g = "Google Chrome",
  }

  local cmdKeys = {
    j = "ghostty"
  }

  local appsToNotHide = {
    "CleanShot X"
  }
  
  -- Focus app and hide all others
  local function focusApp(appName)
    -- Launch or focus the target app first
    hs.application.launchOrFocus(appName)
    
    -- Then hide other apps in the background
    local targetApp = hs.application.find(appName)
    for _, app in ipairs(hs.application.runningApplications()) do
      local shouldNotHide = false
      for _, excludedApp in ipairs(appsToNotHide) do
        if app:name() == excludedApp then
          shouldNotHide = true
          break
        end
      end
      if app ~= targetApp and not app:isHidden() and not shouldNotHide then
        app:hide()
      end
    end
    
    layoutApp(appName)
  end
  
  -- Bind keys (Hyper + key)
  for key, app in pairs(optionKeys) do
    hs.hotkey.bind({"option"}, key, function()
      focusApp(app)
    end)
  end

  for key, app in pairs(cmdKeys) do
    hs.hotkey.bind({"cmd"}, key, function()
      focusApp(app)
    end)
  end

  hs.hotkey.bind({"option"}, "space", function()
    local currentApp = hs.application.frontmostApplication()
    for _, app in ipairs(hs.application.runningApplications()) do
      local shouldNotHide = false
      for _, excludedApp in ipairs(appsToNotHide) do
        if app:name() == excludedApp then
          shouldNotHide = true
          break
        end
      end
      if app ~= currentApp and not app:isHidden() and not shouldNotHide then
        app:hide()
      end
    end
  end)

  hs.hotkey.bind({"option"}, "=", function()
    -- Show all windows of all applications
    for _, app in ipairs(hs.application.runningApplications()) do
      if app:isHidden() then
        app:unhide()
      end
    end
  end)