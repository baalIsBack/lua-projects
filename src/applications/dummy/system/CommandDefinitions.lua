local COMMANDS = {}
local PROGRAM_COMMANDS = {}

local function newCommand(command)
  if command.prefix == nil or command.prefix == "" then
    table.insert(COMMANDS, command)
  else
    if not PROGRAM_COMMANDS[command.prefix] then
      PROGRAM_COMMANDS[command.prefix] = {}
    end
    table.insert(PROGRAM_COMMANDS[command.prefix], command)
  end
end

newCommand({
  prefix = "",
  command = "echo",
  aliases = {"print"},
  unlocked = true,
  effect = function(terminal, commands)
    local str = ""
    for i = 2, #commands do
      str = str .. commands[i] .. " "
    end
    terminal:appendLog(str)
  end
})

newCommand({
  prefix = "",
  command = "clear",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal.log = {}
  end
})

newCommand({
  prefix = "",
  command = "help",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:appendLog("help not implemented")
  end
})

newCommand({
  prefix = "",
  command = "info",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:appendLog("Employee ID: " .. string.format("%05d", terminal.main.values:get("employee_id")))
    terminal:appendLog("Employee Name: ..." .. "REDACTED")
    terminal:appendLog("Employee Birthday: ..." .. "REDACTED")
    terminal:appendLog("Employee Adress: ..." .. "REDACTED")
  end
})

newCommand({
  prefix = "",
  command = "color",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal.window.font_color = {tonumber(commands[2]) or 1, tonumber(commands[3]) or 1, tonumber(commands[4]) or 1}
  end
})

newCommand({
  prefix = "",
  command = "exit",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:appendLog("Exiting terminal...")
    terminal.window:setReal(false)
  end
})

newCommand({
  prefix = "",
  command = "install",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:install(commands[2])
  end
})

newCommand({
  prefix = "",
  command = "uninstall",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:uninstall(commands[2])
  end
})

newCommand({
  prefix = "",
  command = "open",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    if terminal.main.apps:isInstalled(commands[2]) then
      local target_process = terminal.main.processes:getProcess(commands[2])
      terminal.main.processes:openProcess(target_process)
      terminal:appendLog("Opened " .. commands[2])
    else
      terminal:appendLog("Could not open program: " .. commands[2])
    end
  end
})

newCommand({
  prefix = "",
  command = "diskspace",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:appendLog(terminal.main.values:get("rom_usage_current") .. "MB/" .. terminal.main.values:get("rom_usage_total") .. "MB")
  end
})

newCommand({
  prefix = "",
  command = "close",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    if terminal.main.processes:isActive(commands[2]) then
      local target_process = terminal.main.processes:getProcess(commands[2])
      terminal.main.processes:closeProcess(target_process)
      terminal:appendLog("Closed " .. commands[2])
    else
      terminal:appendLog("Could not close program: " .. commands[2])
    end
  end
})

newCommand({
  prefix = "",
  command = "save",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal.main.gamestate:save()
  end
})

newCommand({
  prefix = "",
  command = "reset",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal.main.gamestate:resetSave()
  end
})

newCommand({
  prefix = "",
  command = "test",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    print(commands[1], commands[2], commands[3])
  end
})

newCommand({
  prefix = "mail",
  command = "count",
  aliases = {"length", "amount", "size"},
  unlocked = true,
  effect = function(terminal, commands)
    terminal:appendLog(#terminal.main.mails:getMails())
  end
})

newCommand({
  prefix = "mail",
  command = "read",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    local i = tonumber(commands[3])
    local targetMail = terminal.main.mails:getMail(i)
    local mailWindow = terminal.main.processes:getProcess("mail")
    if targetMail then
      mailWindow:openMail(targetMail)
      terminal.main.mails:readMail(targetMail)
      local str = ""
      .. targetMail:getSender() .. "\n"
      .. targetMail:getSubject() .. "\n"
      .. targetMail:getContent()
      terminal:appendLog(str)
    else
      terminal:appendLog("Could not read mail " .. i)
    end
  end
})

newCommand({
  prefix = "mail",
  command = "reply",
  aliases = {"answer", "respond"},
  unlocked = true,
  effect = function(terminal, commands)
    local i = tonumber(commands[3])
    local targetMail = terminal.main.mails:getMail(i)
    if targetMail then
      --terminal.main.mails:replyMail(targetMail)
      local mailWindow = terminal.main.processes:getProcess("mail")
      if not mailWindow.sending_reply then
        mailWindow:openMail(targetMail)
        mailWindow:initiateReply()
        terminal:appendLog("Replied mail " .. i)
        return
      else
        terminal:appendLog("Could not reply to mail " .. i)
        return
      end
    else
      terminal:appendLog("Could not reply to mail " .. i)
      return
    end
  end
})

newCommand({
  prefix = "mail",
  command = "canreply",
  aliases = {"isreply", "replyable", "isreplyable", "replyable"},
  unlocked = true,
  effect = function(terminal, commands)
    local i = tonumber(commands[3])
    local targetMail = terminal.main.mails:getMail(i)
    if targetMail and terminal.main.mails:canSolve(targetMail) and not targetMail.onReply_called then
      terminal:appendLog("Yes")
    else
      terminal:appendLog("No")
    end
  end
})

newCommand({
  prefix = "files",
  command = "ls",
  aliases = {"show", "list", "lst"},
  unlocked = true,
  effect = function(terminal, commands)
    local filesWindow = terminal.main.processes:getProcess("files")

    local files = terminal.main.fileserver
    local str = ""
    str = str .. left_pad("ID", 4, " ") .. "  "
    str = str .. left_pad("Name", 12, " ") .. "  "
    str = str .. left_pad("Type", 12, " ") .. "  "
    terminal:appendLog(str)
    terminal:appendLog(string.rep("-", 4 + 12 + 12 + 4))
    for i, file in ipairs(filesWindow.icons) do
      str = ""
      str = str .. left_pad(""..i, 4, " ") .. "  "
      str = str .. left_pad(""..file.name, 12, " ") .. "  "
      str = str .. left_pad(""..file.filetype, 12, " ") .. "  "
      terminal:appendLog(str)
    end
  end
})

newCommand({
  prefix = "files",
  command = "open",
  aliases = {"execute", "exe", "run", "do", "launch", "start", "cd"},
  unlocked = true,
  effect = function(terminal, commands)
    local filesWindow = terminal.main.processes:getProcess("files")
    local files = terminal.main.fileserver
    if not filesWindow.icons[tonumber(commands[3])] then
      terminal:appendLog("Could not open file " .. commands[3])
      return
    end
    filesWindow.icons[tonumber(commands[3])].callbacks:call("onClicked", {terminal})
  end
})


newCommand({
  prefix = "documents",
  command = "ls",
  aliases = {"show", "list", "lst"},
  unlocked = true,
  effect = function(terminal, commands)
    local statWindow = terminal.main.processes:getProcess("stat")

    local str = ""
    str = str .. left_pad("Type", 12, " ") .. "  "
    str = str .. left_pad("Amount", 8, " ") .. "  "
    terminal:appendLog(str)
    terminal:appendLog(string.rep("-", 12 + 8 + 4))
    for i, trackable in ipairs(statWindow.trackables) do
      str = ""
      str = str .. left_pad(""..trackable.value_id, 12, " ") .. "  "
      str = str .. left_pad(""..terminal.main.values:get("currently_collected_"..trackable.value_id), 8, " ") .. "  "
      terminal:appendLog(str)
    end
  end
})

newCommand({
  prefix = "processes",
  command = "ls",
  aliases = {"show", "list", "lst"},
  unlocked = true,
  effect = function(terminal, commands)
    local processWindow = terminal.main.processes:getProcess("processes")

    local str = ""
    str = str .. left_pad("ID", 4, " ") .. "  "
    str = str .. left_pad("Process", 12, " ") .. "  "
    str = str .. left_pad("Ram", 8, " ") .. "  "
    terminal:appendLog(str)
    terminal:appendLog(string.rep("-", 4 + 12 + 8 + 4))
    for i, trackable in ipairs(processWindow.trackables) do
      str = ""
      str = str .. left_pad(""..i, 4, " ") .. "  "
      str = str .. left_pad(""..trackable.process.title, 12, " ") .. "  "
      str = str .. left_pad(""..terminal.main.values:get("ram_usage_"..trackable.process.INTERNAL_NAME), 8, " ") .. "  "
      terminal:appendLog(str)
    end
  end
})

newCommand({
  prefix = "processes",
  command = "stop",
  aliases = {"kill", "quit", "end", "terminate", "close", "exit", "destroy", "remove", "delete", "halt", "abort"},
  unlocked = true,
  effect = function(terminal, commands)
    local processWindow = terminal.main.processes:getProcess("processes")

    local str = ""
    str = str .. left_pad("Process", 12, " ") .. "  "
    str = str .. left_pad("Ram", 8, " ") .. "  "
    terminal:appendLog(str)
    terminal:appendLog(string.rep("-", 12 + 8 + 4))
    if processWindow.trackables[tonumber(commands[3])] then
      local trackable = processWindow.trackables[tonumber(commands[3])]
      terminal.main.processes:closeProcess(trackable.process)
      terminal:appendLog("Terminated " .. trackable.process.title)
    else
      terminal:appendLog("Could not terminate process " .. commands[3])
    end
  end
})

newCommand({
  prefix = "",
  command = "loottable",
  aliases = {},
  unlocked = true,
  effect = function(terminal, commands)
    terminal.main.fileserver:setLootTable(commands[2])
  end
})

return {COMMANDS, PROGRAM_COMMANDS}