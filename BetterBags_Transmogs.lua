-- This will get a handle to the BetterBags addon.
---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

-- This will get a handle to the Categories module, which exposes
-- the API for creating categories.
---@class Categories: AceModule
local categories = addon:GetModule('Categories')

-- This will get a handle to the localization module, which should be
-- used for all text your users will see. For all category names,
-- you should use the L:G() function to get the localized string.
---@class Localization: AceModule
local L = addon:GetModule('Localization')

---@class Transmogs: AceModule
local transmogs = addon:NewModule('Transmogs')
function transmogs.OnInitialize()
  categories:WipeCategory(L:G("New Transmog - Mine"))
  categories:WipeCategory(L:G("New Transmog - Other"))
end

categories:RegisterCategoryFunction("Zeptognome Transmog function", function (data)
  local needtoCollect = true
  local cancollect = false
  local itemLink = C_Container.GetContainerItemLink(data.bagid,data.slotid)
  local _,_,transmogSource,_ = C_Transmog.CanTransmogItem(itemLink)
  if not transmogSource then
    return nil
  end
  local itemAppearanceID, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
  if sourceID then
    _, cancollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
    local Sources = C_TransmogCollection.GetAllAppearanceSources(itemAppearanceID)
    for _, v in pairs(Sources) do
      local _,_,_,_,isCollected = C_TransmogCollection.GetAppearanceSourceInfo(v)
      if isCollected then
        needtoCollect = false
      end
    end
    if needtoCollect then
      if cancollect then
        return "New Transmog - Mine"
      end
      return "New Transmog - Other"
    end
  end
  return nil
end)
