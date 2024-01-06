local monitor = peripheral.wrap("right")
 
if(monitor == nil) then
    print("Aucun écran est disponible sur la droite du PC.")
    return
end
monitor.setTextScale(0.5)
 
function padString (sText, iLen)
    local iTextLen = string.len(sText);
    if (iTextLen < iLen) then
        local iDiff = iLen - iTextLen;
        return(sText..string.rep(" ",iDiff));
    end
    if (iTextLen > iLen) then
        return(string.sub(sText,1,iLen));
    end
    return(sText);
end
 
function tableContains(table, value)
    for i = 1,#table do
        if (table[i] == value) then
            return true
        end
    end
    return false
end
 
 
local inv = {peripheral.find("inventory") }
local liquid = {peripheral.find("fluid_storage")}
local content = {}
local contentList = {}
 
for _, chest in pairs(inv) do
    for slot, item in pairs(chest.list()) do
        local itemData = chest.getItemDetail(slot)
        if (content[itemData.displayName] == nil) then
            content[itemData.displayName] = {}
        end
        tableContains(contentList, itemData.displayName)
        if not (tableContains(contentList, itemData.displayName)) then
            print(("adding %s"):format(itemData.displayName))
            table.insert(contentList, itemData.displayName)
        end
        if (content[itemData.displayName].count == nil) then
            content[itemData.displayName].count = 0
        end
        content[itemData.displayName].count = content[itemData.displayName].count + item.count
        if(content[itemData.displayName].name == nil) then
            content[itemData.displayName].name = itemData.displayName
        end
    end
end
 
for _, tanks in pairs(liquid) do
   for __, liquid  in pairs(tanks.tanks()) do
        if(content[liquid.name] == nil) then
            content[liquid.name] = {}
        end
        if (content[liquid.name].count == nil) then 
            content[liquid.name].count = 0
        end
        table.insert(contentList, liquid.name)
        content[liquid.name].count = content[liquid.name].count + liquid.amount/1000
        if (content[liquid.name].name == nil) then
            content[liquid.name].name = liquid.name
        end
    end
end
 
 
monitor.clear()
monitor.setCursorPos(1,1)
local x = 1
table.sort(contentList)
 
for item in pairs(contentList) do
    print(contentList[item])
    monitor.write(("%s x %d"):format(padString(content[contentList[item]].name,18), content[contentList[item]].count))
    monitor.setCursorPos(1,x+1)
    x=x+1
end
print("done")
 
print(table.concat(contentList,", "))