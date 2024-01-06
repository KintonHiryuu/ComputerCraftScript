-- Setup Paramètres

local maxLineSize = 17 -- auras toujours un +3 a la fin
local autoMaxLineSize = true -- ré écrit la variable du dessus pour avoir la longueur max des écrans
local maxColumns = 4 -- Nombre max de colonnes quand maxLineSize est auto 

-- Setup Ecran
local monitor = peripheral.wrap("right")

if(monitor == nil) then
    print("Aucun écran disponible sur la droite du PC.")
    return
end
local monitorMaxX,monitorMaxY = monitor.getSize()
monitor.setTextScale(1)
 
-- Setup Fonctions utiles
function PadString (sText, iLen)
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
 
function TableContains(table, value)
    for i = 1,#table do
        if (table[i] == value) then
            return true
        end
    end
    return false
end
 
 
-- Setup variables gloabl
local inv = {peripheral.find("inventory") }
local liquid = {peripheral.find("fluid_storage")}
local content = {}
local contentList = {}

if(autoMaxLineSize == true) then
    maxLineSize = math.floor((monitorMaxY/maxColumns))
    print(("max Y : %d maxLineSize : %d maxColumns : %d"):format(monitorMaxY, maxLineSize, maxColumns))
end

-- Code
for _, chest in pairs(inv) do
    for slot, item in pairs(chest.list()) do
        local itemData = chest.getItemDetail(slot)
        if (content[itemData.displayName] == nil) then
            content[itemData.displayName] = {}
        end
        if not (TableContains(contentList, itemData.displayName)) then
            --print(("adding %s"):format(itemData.displayName))
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

local cursorX, cursorY = 1, 1

for item in pairs(contentList) do
    content[contentList[item]].count = tostring(content[contentList[item]].count)
    monitor.write(("%s x %d |"):format(PadString(content[contentList[item]].name,maxLineSize-string.len(content[contentList[item]].count)), content[contentList[item]].count) )
    monitor.setCursorPos(cursorX,cursorY)
    if(cursorX+maxLineSize+4 >= monitorMaxX-3) then
        cursorX = 1
        cursorY = cursorY+1
    else
        cursorX = cursorX + maxLineSize +6
    end
end
print("Work In Progress Script")
print("done")