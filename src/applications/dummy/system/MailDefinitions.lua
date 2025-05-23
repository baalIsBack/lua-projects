

local default_f = function(mail, main) return true end

local MAILS = {}
MAILS[1] = {
  sender = "Company",
  subject = "Greetings",
  content = "Dear Worker, \n\nwelcome to the Company! To finish your device setup we advise you to install the editor program by typing 'install editor' into the terminal and hitting 'enter'. In the meantime we will get back with further instructions.\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+n
  source_quests = {},
--  source_quests_requirement_count = 0,
  target_quests = {2},
  required_unlock_flags = {},
  expected_reply = "Done!",
  required_solve_function = default_f,
  required_solve_flags = {"installed_editor"},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
  reward = 0,
}
MAILS[2] = {
  sender = "Company",
  subject = "Editor",
  content = "Dear Worker, \n\nwe hope that by now you have installed the editor program. In the future we might require you to note down some information. Please keep that information as concise as possbile so our automatic reply generation system (args) can decipher your scramblings.\n\nIn the meantime please note down your employee ID, which you can find by typing 'info' into the terminal.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {1},
--  source_quests_requirement_count = 0,
  target_quests = {3},
  required_unlock_flags = {"mail_read_1",},
  expected_reply = SET_IN_VALUES,
  required_solve_function = default_f,
  required_solve_flags = {},
  required_solve_notes = {SET_IN_VALUES},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
  reward = 0,
}
MAILS[3] = {
  sender = "Company",
  subject = "Files",
  content = "Dear Worker, \n\nwe require you to also install the files app, which will allow for browsing your filesystem. Please install the filesystem app by typing 'install files' into the terminal.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {2},
--  source_quests_requirement_count = 0,
  target_quests = {4},
  required_unlock_flags = {},
  expected_reply = "Installed it!",
  required_solve_function = function (self, main)
    if main.flags:get("installed_files") then
      return true
    end
    return false
  end,
  required_solve_flags = {},--{"installed_files"},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
  reward = 0,
}
MAILS[4] = {
  sender = "Company",
  subject = "1st Job",
  content = "Dear Worker, \n\nnow that you have installed the files app you can start by browsing your filesystem. As your first job we would like you to find a file called 'merchandise' and send it to us.\nYou can use the automatic reply generation system (args) by clicking on the file. It will then be automatically attached to your reply.\n\nYou will earn 0.50$ for this job.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {3},
--  source_quests_requirement_count = 0,
  target_quests = {5, 6, 7},
  required_unlock_flags = {},
  expected_reply = "Here is the file!",
  required_solve_function = function (self, main)
    if main.flags:get("file_opened_merchandise") then
      return true
    end
    return false
  end,
  required_solve_flags = {},--{"file_opened_merchandise"},
  required_solve_notes = {},
  onRead = function(mail, main)
    main.files:add("merchandise", 1)
  end,
  onReply = function(mail, main, text) end,
  reward = 0.5,
}
MAILS[5] = {
  sender = "Company",
  subject = "New Job",
  content = "Dear Worker, \n\nfor your next job we require you to send 5 system files. You can use the automatic reply generation system (args).\n\nYou will earn 0.50$.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {4},
--  source_quests_requirement_count = 0,
  target_quests = {8},
  required_unlock_flags = {},
  expected_reply = "Here are the files:[...]",
  required_solve_function = function(self, main)
    if (main.values:get("currently_collected_system") or 0) >= 5 then
      return true
    end
    return false
  end,
  required_solve_flags = {},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text)
    local val = main.values:get("currently_collected_system")
    main.values:set("currently_collected_system", val -5)
  end,
  reward = 0.5,
}
MAILS[6] = {
  sender = "Company",
  subject = "New Job",
  content = "Dear Worker, \n\nfor your next job we require you to send 5 document files. You can use the automatic reply generation system (args).\n\nYou will earn 0.50$.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {4},
--  source_quests_requirement_count = 0,
  target_quests = {8},
  required_unlock_flags = {},
  expected_reply = "Here are the files:[...]",
  required_solve_function = function(self, main)
    if (main.values:get("currently_collected_document") or 0) >= 5 then
      return true
    end
    return false
  end,
  required_solve_flags = {},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text)
    local val = main.values:get("currently_collected_document")
    main.values:set("currently_collected_document", val -5)
  end,
  reward = 0.5,
}
MAILS[7] = {
  sender = "Company",
  subject = "New Job",
  content = "Dear Worker, \n\nfor your next job we require you to send 5 image files. You can use the automatic reply generation system (args).\n\nYou will earn 0.50$.\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {4},
--  source_quests_requirement_count = 0,
  target_quests = {8},
  required_unlock_flags = {},
  expected_reply = "Here are the files:[...]",
  required_solve_function = function(self, main)
    if (main.values:get("currently_collected_image") or 0) >= 5 then
      return true
    end
    return false
  end,
  required_solve_flags = {},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text)
    local val = main.values:get("currently_collected_image")
    main.values:set("currently_collected_image", val -5)
    main.contacts:triggerUnlock(1)
    main.contacts:triggerUnlock(2)
    main.contacts:triggerUnlock(3)
  end,
  reward = 0.5,
}
MAILS[8] = {
  sender = "Company",
  subject = "Thx",
  content = "Dear Worker, \n\nyou are fired. Thanks for playing! <3\n\n\nBest regards,\nHR",
  redeemable = 1,
  redeems_required_for_next_quest = 1,--redeemable+nö
  source_quests = {4, 5, 6},
  source_quests_requirement_count = 2,
  target_quests = {},
  required_unlock_flags = {},
  expected_reply = "I quit!",
  required_solve_function = default_f,
  required_solve_flags = {},
  required_solve_notes = {},
  onRead = function(mail, main) end,
  onReply = function(mail, main, text) end,
  reward = 0,
}


return MAILS