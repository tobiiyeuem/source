
print("akiki toi choi")
repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
player                                   = game:GetService("Players")
LocalPlayer                              = player.LocalPlayer
PlayerGui                                = LocalPlayer:WaitForChild('PlayerGui')
local World1, World2, World3, Request_Places
if game.PlaceId == 2753915549 then
    World1 = true
    Request_Places = {
        ["Whirl Pool"] = CFrame.new(3864.6884765625, 6.736950397491455, -1926.214111328125),
        ["Sky Area 1"] = CFrame.new(-4607.82275, 872.54248, -1667.55688),
        ["Sky Area 2"] = CFrame.new(-7894.61767578125, 5547.1416015625, -380.29119873046875),
        ["Fish Man"] = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875)
    }
elseif game.PlaceId == 4442272183 then
    World2 = true
    Request_Places = {
        ["Swan's room"] = CFrame.new(2284.912109375, 15.152046203613281, 905.48291015625),
        ["Mansion"] = CFrame.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
        ["Ghost Ship"] = CFrame.new(923.21252441406, 126.9760055542, 32852.83203125),
        ["Ghost Ship Entrance"] = CFrame.new(-6508.5581054688, 89.034996032715, -132.83953857422)
    }
elseif game.PlaceId == 7449423635 then
    World3 = true
    Request_Places = {
        ["Castle on the sea"] = CFrame.new(-5075.50927734375, 314.5155029296875, -3150.0224609375),
        ["Mansion"] = CFrame.new(-12548.998046875, 332.40396118164, -7603.1865234375),
        ["Hydra Island"] = CFrame.new(5661.53027, 1013.38354, -334.961914),
        ["Temple Of Time"] = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875),
        ["Green Tree"] = CFrame.new(3028.84082, 2281.20264, -7324.7832)
    }
end
if game.Players.LocalPlayer.Team == nil then
    print(1)
    repeat
        repeat wait() until PlayerGui:FindFirstChild("Main (minimal)") and PlayerGui["Main (minimal)"]:FindFirstChild "ChooseTeam"
        local Button = PlayerGui["Main (minimal)"].ChooseTeam
            .Container[getgenv().Team].Frame
            .TextButton
        for i, v in pairs(getconnections(Button.Activated)) do
            v.Function()
        end
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", getgenv().Team)

        wait(1)
    until LocalPlayer.Team ~= nil
end
ReplicatedStorage                        = game:GetService("ReplicatedStorage")
Remotes                                  = ReplicatedStorage:WaitForChild("Remotes")
Quests                                   = require(ReplicatedStorage.Quests)
GuideModule                              = require(ReplicatedStorage:WaitForChild("GuideModule"))

CommF                                    = Remotes:WaitForChild("CommF_")
Modules                                  = ReplicatedStorage:WaitForChild("Modules")
Net                                      = Modules:WaitForChild("Net")

RegisterAttack                           = Net:WaitForChild("RE/RegisterAttack")
RegisterHit                              = Net:WaitForChild("RE/RegisterHit")

VirtualInputManager                      = game:GetService("VirtualInputManager")
Enemies                                  = workspace:WaitForChild("Enemies")
PlrData                                  = LocalPlayer:WaitForChild("Data")
Level                                    = PlrData:WaitForChild("Level")
Fragments                                = PlrData:WaitForChild("Fragments")
Beli                                     = PlrData:WaitForChild("Beli")
LastSpawn                                = PlrData:WaitForChild('LastSpawnPoint')
Race                                     = PlrData:WaitForChild('Race')
print('Loaded Team')
check2 = false
queuechecked = false
print("Loading Hop...")
local SaveFileName2 = "!Blacklist_Servers.json"
local Settings2 = {}

function SaveSettings2()
    local HttpService = game:GetService("HttpService")
    if not isfolder("Custom") then
        makefolder("Custom")
    end
    writefile(SaveFileName2, HttpService:JSONEncode(Settings2))
end

function ReadSetting2()
    local s, e =
        pcall(
        function()
            local HttpService = game:GetService("HttpService")
                if not isfolder("Custom1") then
            makefolder("Custom1")
        end
            return HttpService:JSONDecode(readfile(SaveFileName2))
        end
    )
    if s then
        return e
    else
        SaveSettings2()
        return ReadSetting2()
    end
end


local AllIDs, foundAnything, actualHour, S_T, S_H = {}, "", os.date("!*t").hour, game:GetService("TeleportService"), game:GetService("HttpService")
local hourBlock = math.floor(os.time() / (60 * 60 * 4))
local success, result = pcall(function() return S_H:JSONDecode(readfile("server-hop-temp.json")) end)
if success and type(result) == "table" and result[1] == hourBlock then
    AllIDs = result
else
    AllIDs = {hourBlock}
    pcall(function() writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs)) end)
end


local function TPReturner(placeId)
    local data
    if foundAnything == "" then
        data = S_H:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    else
        data = S_H:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything))
    end
    if data.nextPageCursor then foundAnything = data.nextPageCursor end
    for _, v in ipairs(data.data) do
        if v.playing < v.maxPlayers then
            local id = tostring(v.id)
            local skip = false
            for i = 2, #AllIDs do
                if AllIDs[i] == id then skip = true break end
            end
            if not skip then
                table.insert(AllIDs, id)
                pcall(function() writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs)) end)
                pcall(function() S_T:TeleportToPlaceInstance(placeId, id, game.Players.LocalPlayer) end)
                task.wait(4)
            end
        end
    end
end

local module = {}
function module:Teleport(placeId)
    while task.wait() do
        pcall(function()
            TPReturner(placeId)
            if foundAnything ~= "" then TPReturner(placeId) end
        end)
    end
end

function HopLow()
    local cursor = ""
    repeat
        local site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")))
        if site.nextPageCursor then cursor = site.nextPageCursor else cursor = "" end
        for _, v in ipairs(site.data) do
            if v.playing <= 4 and v.id ~= game.JobId then
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, tostring(v.id), game.Players.LocalPlayer)
                end)
                return
            end
        end
    until cursor == ""
end

local Settings2 = ReadSetting2()
getgenv().TimeTryHopLow = 0

function HopServer(CountTarget, hoplowallow, reasontohop)
    local delay = 3
    if hoplowallow and getgenv().TimeTryHopLow < 3 then
        for _ = 1, 3 - getgenv().TimeTryHopLow do
            local ok = pcall(function() HopLow() end)
            if ok then
                getgenv().TimeTryHopLow = getgenv().TimeTryHopLow + 1

                task.wait(delay / 2)
            end
        end
    end
    CountTarget = CountTarget or 10
    print(reasontohop)
    task.wait(delay)
    local function Hop()
        for i = 1, 100 do
            if not ChooseRegion or ChooseRegion == "" then
                ChooseRegion = "Singapore"
            else
                game.Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = ChooseRegion
            end
            local servers = game.ReplicatedStorage.__ServerBrowser:InvokeServer(i)
            for id, data in pairs(servers) do
                if id ~= game.JobId and data.Count < CountTarget then
                    if not Settings2[id] or tick() - Settings2[id].Time > 600 then
                        Settings2[id] = {Time = tick()}
                        SaveSettings2()
                        game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", id)
                        return true
                    elseif tick() - Settings2[id].Time > 3600 then
                        Settings2[id] = nil
                    end
                end
            end
        end
        return false
    end
    if not getgenv().Loaded then
        local function handle(v)
            if v.Name == "ErrorPrompt" then
                local function onChange()
                    if v.Visible and v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                        HopServer()
                        v.Visible = false
                    end
                end
                if v.Visible then onChange() end
                v:GetPropertyChangedSignal("Visible"):Connect(onChange)
            end
        end
        for _, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do handle(v) end
        game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(handle)
    end
    Hop()
    SaveSettings2()
end
print("load hop chx?")
function CheckPlayerAlive()
    local a2,b2 = pcall(function() return game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 end)
    task.wait()
    if a2 then return b2 end 
end
function RemoveLevelTitle(v)
    return tostring(tostring(v):gsub(" %pLv. %d+%p", ""):gsub(" %pRaid Boss%p", ""):gsub(" %pBoss%p", ""))
end 
local Request_Places2 = {}
for i1,v1 in pairs(workspace._WorldOrigin.PlayerSpawns[tostring(game:GetService("Players").LocalPlayer.Team)]:GetChildren()) do
    if not Request_Places2[v1.Name] then
        Request_Places2[v1.Name] = CFrame.new(v1.WorldPivot.Position)
    end
end
workspace._WorldOrigin.PlayerSpawns[tostring(game:GetService("Players").LocalPlayer.Team)].ChildAdded:Connect(function(aa)
        if not Request_Places2[aa.Name] then
            Request_Places2[aa.Name] = CFrame.new(aa.WorldPivot.Position)
        end
end)

if game.Workspace:FindFirstChild("MobSpawns") then
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "MobSpawns" then
            v:Destroy()
        end
    end
end

local MobSpawnsFolder = Instance.new("Folder")
MobSpawnsFolder.Parent = game.Workspace
MobSpawnsFolder.Name = "MobSpawns"
MobSpawnsFolder.ChildAdded:Connect(function(v)
    wait(1)
    v.Name = RemoveLevelTitle(v.Name)
end)
local AllMobInGame = {}
for i, v in next, require(game:GetService("ReplicatedStorage").Quests) do
    for i1, v1 in next, v do
        for i2, v2 in next, v1.Task do
            if v2 > 1 then
                table.insert(AllMobInGame, i2)
            end
        end
    end
end
local MobOutFolder = {}
for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
    v.Name = RemoveLevelTitle(v.Name)
    table.insert(MobOutFolder, v)
end
for i, v in pairs(getnilinstances()) do
    if table.find(AllMobInGame, RemoveLevelTitle(v.Name)) then
        table.insert(MobOutFolder, v)
    end
end
local l1 = {}
function ReCreateMobFolder()
    local MobNew
    l1 = {}
    for i,v in pairs(MobOutFolder) do 
        if v then
            pcall(function()
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    MobNew = Instance.new("Part")
                    MobNew.CFrame = v.PrimaryPart.CFrame
                    MobNew.Name = v.Name
                    MobNew.Parent = game.Workspace.MobSpawns
                elseif v:IsA("Part") then
                    MobNew = v:Clone()
                    MobNew.Parent = game.Workspace.MobSpawns
                    MobNew.Transparency = 1
                end
                if not table.find(l1,v.Name) then 
                    table.insert(l1,tostring(v.Name))
                end 
            end)
        end
    end
end
ReCreateMobFolder()
local MobSpawnClone = {}
local function getMid(vName,gg)
    local total = 0
    local allplus 
    for i,v in pairs(gg) do
        if v.Name == vName then 
            if not allplus then 
                allplus = v.Position
            else
                allplus = allplus+v.Position 
            end
            total = total+1
        end
    end
    if allplus then return allplus/total end 
end
local lss = 0
for i,v in pairs(game.Workspace.MobSpawns:GetChildren()) do 
    if not MobSpawnClone[v.Name] then 
        MobSpawnClone[RemoveLevelTitle(v.Name)] = CFrame.new(getMid(v.Name,game.Workspace.MobSpawns:GetChildren()))
        lss = lss +1
    end 
end
_G.MobSpawnClone = MobSpawnClone
function GetMobSpawnList(a)
    local a = RemoveLevelTitle(a)
    k = {}  
    for i, v in pairs(game.Workspace.MobSpawns:GetChildren()) do
        if v.Name == a then
            table.insert(k, v)
        end
    end
    return k
end

function GetDistance(target1, taget2)
    if not taget2 then
        pcall(function()
            taget2 = game.Players.LocalPlayer.Character.HumanoidRootPart
        end)
    end
    local bbos, bbos2 =
        pcall(
        function()
            a = target1.Position
            a2 = taget2.Position
        end
    )
    if bbos then
        return (a - a2).Magnitude
    end
end 


print("LoadFatatt")
if not game:GetService("Players").LocalPlayer.PlayerScripts.EffectsLocalThread.Disabled then game:GetService("Players").LocalPlayer.PlayerScripts.EffectsLocalThread.Disabled = true end
if getgenv().FpsBooster then
    if game.PlaceId==2753915549 or 4442272183 or 7449423635 then if game:GetService("ReplicatedStorage").Effect.Container.Shared:FindFirstChild("AirDash")then game:GetService("ReplicatedStorage").Effect.Container.Shared.AirDash:Destroy()end;if game:GetService("ReplicatedStorage").Effect.Container.Shared:FindFirstChild("LightningTP")then game:GetService("ReplicatedStorage").Effect.Container.Shared.LightningTP:Destroy()end;if game:GetService("ReplicatedStorage").Effect.Container.Misc:FindFirstChild("Damage")then game:GetService("ReplicatedStorage").Effect.Container.Misc.Damage:Destroy()end;if game:GetService("ReplicatedStorage").Effect.Container.Misc:FindFirstChild("Confetti")then game:GetService("ReplicatedStorage").Effect.Container.Misc.Confetti:Destroy()end;if game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("LevelUp")then game:GetService("ReplicatedStorage").Effect.Container.LevelUp:Destroy()end end
    game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui').Notifications.Enabled = false
    settings().Rendering.QualityLevel = "Level01";
    settings().Rendering.GraphicsMode = "NoGraphics";
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    UserSettings():GetService("UserGameSettings").SavedQualityLevel = 1
    workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
    game:GetService("Lighting").GlobalShadows = false
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
local function ducanhcc(v)
    if v and not v.Name:find('Flower') and tostring(v.Parent.Name) ~= 'MysticIsland' then
        pcall(function()
            if v:IsA('Texture') and not v:GetAttribute('Offset') then
                v:Destroy() 
                return
            end
            v.Transparency = 1
        end)
    end
end
workspace.DescendantAdded:Connect(ducanhcc)
for i, v in pairs(game.workspace:GetDescendants()) do
    ducanhcc(v)
    end
end
repeat wait() until type(CommF:InvokeServer("getInventory")) == "table"
SUCCESS_FLAGS, COMBAT_REMOTE_THREAD = pcall(function()
    return require(Modules.Flags).COMBAT_REMOTE_THREAD or false
end)
SUCCESS_HIT, HIT_FUNCTION = pcall(function()
    return getrenv()._G.SendHitsToServer
end)
function getHead()
    local returntable = {}
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if not table.find({'FishBoat', 'Brigade', 'PirateGrandBrigade'}, v.Name) and skidymf(v) then
            if GetDistance(v.HumanoidRootPart) < 60 then
                if v:HasTag("realmob") then
                    table.insert(returntable, 1, {v, v.HumanoidRootPart})
                elseif v:HasTag("secondmob") then
                    table.insert(returntable, math.min(2, #returntable+1), {v, v.HumanoidRootPart})
                else
                    table.insert(returntable, {v, v.HumanoidRootPart})
                end
            end
        end
    end
    return returntable
end
function FastAttacked()
    local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if Equipped then
        local getHeadAttack = getHead()
        local v1 = tostring(game.Players.LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15)
        if #getHeadAttack > 0 then
            local firstrootpart = table.remove(getHeadAttack,1)[2]
            RegisterAttack:FireServer()
            if SUCCESS_FLAGS and COMBAT_REMOTE_THREAD and SUCCESS_HIT and HIT_FUNCTION then
                HIT_FUNCTION(firstrootpart, getHeadAttack, nil, v1)
            elseif SUCCESS_FLAGS and not COMBAT_REMOTE_THREAD then
                RegisterHit:FireServer(firstrootpart, getHeadAttack)
            end
        end
    end
end
print("LoadFatatt Done")
function checkInventory(name)
    local inventory = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    for _, item in pairs(inventory) do
        if item.Name == name then
            return true
        end
    end
    return false
end

function setlastspawn(Map)
    if not IsPlayerAlive() or not (PlrData:FindFirstChild("LastSpawnPoint") and type(PlrData.LastSpawnPoint.Value) == "string" and (PlrData.LastSpawnPoint.Value ~= Map or GetDistance(Request_Places2[Map]) >= 1500)) then print(1) return end
    if game.Players.LocalPlayer.Character:FindFirstChild('LastSpawnPoint') and not LocalPlayer.Character.LastSpawnPoint.Disabled then LocalPlayer.Character.LastSpawnPoint.Disabled = true end
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer('SetLastSpawnPoint', Map)
    wait()
    game:GetService('Players').LocalPlayer.Data.LastSpawnPoint.Value = Map
    wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].PlayerSpawns.Pirates[Map].Part.CFrame * CFrame.new(0,-5,0)
    wait()
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
end
function checkcanentrance()
    return game.PlaceId ~= 7449423635 or checkInventory("Valkyrie Helm")
end
function rqentrance(request_place)
    if tween then tween:Cancel() end
    if request_place ~= "Green Tree" then
        repeat
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance",
                Request_Places[request_place].Position)
            wait(.5)
        until GetDistance(Request_Places[request_place]) < 50
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character
            .HumanoidRootPart.CFrame * CFrame.new(30, 50, 0)
    else
        if not workspace.NPCs:FindFirstChild("Mysterious Force") and not workspace.NPCs:FindFirstChild("Mysterious Force3") then
            repeat
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance",
                    Request_Places["Temple Of Time"].Position)
                wait()
            until workspace.NPCs:FindFirstChild("Mysterious Force3")
        end
        if workspace.NPCs:FindFirstChild("Mysterious Force3") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28610.1328, 14896.8477,
                105.67765, -0.0388384573, 6.65092799e-08, -0.999245524, -1.15718697e-08, 1, 6.70092675e-08,
                0.999245524, 1.41656757e-08, -0.0388384573)
            repeat
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress",
                    "TeleportBack")
                    wait()
            until workspace.NPCs:FindFirstChild("Mysterious Force")
        end
    end
end
function CheckBackPack(bx)
    BackpackandCharacter = { game.Players.LocalPlayer.Backpack, game.Players.LocalPlayer.Character }
    for al, by in pairs(BackpackandCharacter) do
        for r, v in pairs(by:GetChildren()) do
            if type(bx) == "table" then
                if table.find(bx, v.Name) then
                    return v
                end
            else
                if v.Name == bx then
                    return v
                end
            end
        end
    end
end

function CheckNearestRequestIsland2(pos, tpinstant)
    local nearestIsland = nil
    local nearestDist = math.huge
    for name, cframe in pairs(Request_Places) do
        if GetDistance(pos) < 500 or not checkcanentrance() then break end
        local dist = GetDistance(pos, cframe)
        local distotarget = GetDistance(pos)
        if dist < nearestDist and dist < distotarget then
            nearestDist = dist
            nearestIsland = name
        end
    end
    for name, islandPos in pairs(Request_Places2) do
        if World3 or Level.Value < 10 or GetDistance(pos) < 1500 or not tpinstant then break end
        local dist = GetDistance(islandPos, pos)
        local distoplr = GetDistance(islandPos)
        if distoplr <= 9500 and dist < nearestDist then
            nearestDist = dist
            nearestIsland = name
        end
    end
    if nearestIsland then
        if Request_Places2[nearestIsland] then
            return (LastSpawn.Value ~= nearestIsland or GetDistance(Request_Places2[nearestIsland]) >= 1500) and nearestIsland
        elseif GetDistance(Request_Places[nearestIsland], pos) < GetDistance(pos) then
            return nearestIsland
        end
    end
    return nil
end
local function shouldtp(instant)
    if not instant or CheckBackPack({"Special Microchip", "Flower 1", "Flower 2", "Flower 3", "Fist of Darkness", "Sweet Chalice", "God's Chalice", "Hallow Essence"}) then return false end
    return true
end
function q1(I, II)
    if not II then
        II = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
    end

    return (Vector3.new(I.X, 0, I.Z) - Vector3.new(II.X, 0, II.Z)).Magnitude
end
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    local hum = Character:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if hum.Sit then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            repeat
                wait(0.1) -- Giảm thời gian chờ trong vòng lặp để ít tốn tài nguyên hơn
            until not hum.Sit
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
end)
function TP1(Pos, notinstant)
    local lastPauseTime = tick()
    local tween
    local count = tick()
    repeat
        wait()
        if not IsPlayerAlive() then if tween then tween:Cancel() end return end
        if tick() - lastPauseTime >= 10 then
            if tween then
                tween:Pause()
            end
            wait(.5)
            tween:Play()
            lastPauseTime = tick()
        end
        if World3 then
            if GetDistance(Pos, CFrame.new(10439, -1962, 9697)) <= 5000 then
                if not workspace.Map:FindFirstChild('Submerged Island') then
                    if not workspace.NPCs:FindFirstChild('Submarine Worker') then
                        TP1(CFrame.new(-16270, 25, 1374))
                        return TP1(Pos, notinstant)
                    end
                    if workspace.NPCs:FindFirstChild('Submarine Worker') then
                        repeat
                            game:GetService("ReplicatedStorage").Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                            wait(2)
                        until workspace.Map:FindFirstChild('Submerged Island')
                    end
                end
            elseif GetDistance(CFrame.new(10439, -1962, 9697)) <= 5000 then
                if GetDistance(CFrame.new(11427.9189, -2156.36401, 9726.24023)) > 8 then
                    TP1(CFrame.new(11427.9189, -2156.36401, 9726.24023))
                    return TP1(Pos, notinstant)
                end
                if GetDistance(CFrame.new(11427.9189, -2156.36401, 9726.24023)) <= 8 then
                    repeat
                        game:GetService("ReplicatedStorage").Modules.Net["RF/SubmarineTransportation"]:InvokeServer("InitiateTeleport","Tiki Outpost")
                        wait(2)
                    until GetDistance(CFrame.new(10439, -1962, 9697)) > 5000
                    return TP1(Pos, notinstant)
                end
            end
        end
        Distance = q1(Pos.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
        local request_place = CheckNearestRequestIsland2(Pos, shouldtp(not notinstant))
        if request_place then
            if Request_Places2[request_place] and shouldtp(not notinstant) and (not tween or Character.Humanoid.FloorMaterial ~= Enum.Material.Air) then
                if PlrData:FindFirstChild("LastSpawnPoint") and type(PlrData.LastSpawnPoint.Value) == "string" and PlrData.LastSpawnPoint.Value ~= "SubmergedIsland" and (PlrData.LastSpawnPoint.Value ~= request_place or GetDistance(Request_Places2[request_place]) >= 1500) then
                    if tween then tween:Cancel() end
                    if IsPlayerAlive() then
                        setlastspawn(request_place)
                    end
                    repeat wait() until IsPlayerAlive()
                    return
                end
            elseif Request_Places[request_place] and checkcanentrance() then
                rqentrance(request_place)
                Distance = q1(Pos)
            end
        end
        if Pos.Position.Y > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X,
                Pos.Position.Y,
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z
            )
            wait()
        end
        if Distance <= 200 then
            if Distance <= 50 then
                if tween then tween:Cancel() end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
                return
            else
                Time = 0.25
            end
        else
            Time = Distance/350
        end
        tween = game:GetService("TweenService"):Create(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Time, Enum.EasingStyle.Linear),
            { CFrame = Pos }
        )
        tween:Play()
    until not IsPlayerAlive() or q1(Pos.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position) < 3 or tick() - count >= 60
end
_G.ServerData = {} 
_G.ServerData['Chest'] = {}
_G.ChestsConnection = {}
function SortChest()
    local LOROOT = game.Players.LocalPlayer.Character.PrimaryPart or game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')
    if LOROOT then
        table.sort(_G.ServerData['Chest'], function(chestA, chestB)  
            local distanceA
            local distanceB
            if chestA:IsA('Model') then 
                distanceA = (Vector3.new(chestA:GetModelCFrame()) - LOROOT.Position).Magnitude
            end 
            if chestB:IsA('Model') then 
                distanceB = (Vector3.new(chestB:GetModelCFrame()) - LOROOT.Position).Magnitude 
            end
            if not distanceA then  distanceA = (chestA.Position - LOROOT.Position).Magnitude end
            if not distanceB then  distanceB = (chestB.Position - LOROOT.Position).Magnitude end
            return distanceA < distanceB 
        end)
    end
end
function AddChest(chest)
    wait()
    if table.find(_G.ServerData['Chest'], chest) or not chest.Parent then return end 
    if not string.find(chest.Name,'Chest') or not (chest.ClassName == ('Part') or chest.ClassName == ('BasePart')) then return end
    if (chest.Position-CFrame.new(-1.4128437, 0.292379826, -6.53605461, 0.999743819, -1.41806034e-09, -0.0226347167, 4.24517754e-09, 1, 1.2485377e-07, 0.0226347167, -1.24917875e-07, 0.999743819).Position).Magnitude <= 10 then 
        return 
    end 
    local CallSuccess,Returned = pcall(function()
        return GetDistance(chest)
    end)
    if not CallSuccess or not Returned then return end
    table.insert(_G.ServerData['Chest'], chest)  
    local parentChangedConnection
    parentChangedConnection = chest:GetPropertyChangedSignal('Parent'):Connect(function()
        local index = table.find(_G.ServerData['Chest'], chest)
        table.remove(_G.ServerData['Chest'], index)
        parentChangedConnection:Disconnect()
        SortChest()
    end)
end

function LoadChest()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:find("Chest") and v.Name:match("%d+") and v.CanTouch then
            task.spawn(function()
                AddChest(v)
                local parentFullName = v and v.Parent and tostring(v.Parent:GetFullName())
                if parentFullName and not _G.ChestsConnection[parentFullName] then
                    _G.ChestsConnection[parentFullName] = v.Parent.ChildAdded:Connect(AddChest)
                end
            end)
        end
    end 
    task.delay(3,function()
        print('Loaded total',#_G.ServerData['Chest'],'chests')
        SortChest()
    end)
end
task.spawn(LoadChest) 
function getNearestChest()
    for i,v in pairs(_G.ServerData['Chest']) do
        return v 
    end
end 
local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local h = chr:FindFirstChild("Humanoid") or false
local check = 0
_G.ChestCollect = 0
function PickChest(Chest)
    if not _G.ChestCollect or typeof(_G.ChestCollect) ~= 'number' then 
       _G.ChestCollect = 0 
    end
    if not Chest then 
        task.spawn(LoadChest) 
        return
        elseif not _G.ChestConnection then 
        print('Picking up chest | '..tostring(_G.ChestCollect))
       _G.ChestConnection = Chest:GetPropertyChangedSignal('Parent'):Connect(function()
            _G.ChestCollect = _G.ChestCollect + 1
            _G.ChestConnection:Disconnect()
            _G.ChestConnection = nil
            SortChest()
        end) 
        local OldChestCollect = _G.ChestCollect
        repeat task.wait()
            if not h or h.Health <= 0 then
                chr = plr.Character or plr.CharacterAdded:Wait()
                h = chr:FindFirstChild("Humanoid") or false
            else
                
                TP1(Chest.CFrame)
                SendKey('Space',.5) 
                Chest.CanTouch = false
            end
        until not Chest.CanTouch
        check = check + 1
        if check >= 7 then
            chr:FindFirstChildOfClass("Humanoid"):ChangeState(15)
            check = 0
            task.wait(3)
        end
        if Chest and Chest.Parent then 
            Chest:Destroy() 
        elseif _G.ChestCollect == OldChestCollect then 
            _G.ChestCollect = _G.ChestCollect + 1
        end
    end
end
function IsPlayerAlive(player)
    if not player then
        player = game.Players.LocalPlayer
    end

    
    if not player or not player:IsA("Player") then
        return false 
    end

    local character = player.Character or player:FindFirstChild('Character')
    if not character then
        return false 
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false 
    end

    return true 
end
local Attachment = Instance.new("Attachment")
do
    Attachment.Name = "mr2"
    local AlignOrientation = Instance.new("AlignOrientation")
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.AlignType = Enum.AlignType.PrimaryAxisParallel
    AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(), Vector3.new(0, 0, 1), Vector3.new(0, 1, 0))
    AlignOrientation.Responsiveness = 100
    AlignOrientation.MaxTorque = 700000
    AlignOrientation.Parent = Attachment
    AlignOrientation.Attachment0 = Attachment
end

function sizepart(v)
    local RootPart= v.HumanoidRootPart
    if v.Humanoid:FindFirstChild("Animator") then
        v.Humanoid.Animator:Destroy()
    end
    if not RootPart:FindFirstChild("3tl") then
        local lock = Instance.new("BodyVelocity")
        lock.Parent = RootPart
        lock.Name = "3tl"
        lock.MaxForce = Vector3.new(math.huge,  math.huge, math.huge)
        lock.Velocity = Vector3.new(0, 0, 0)
    end
    local BodyPosition = RootPart:FindFirstChild("forcetp")
    if not BodyPosition then
        BodyPosition = Instance.new("BodyPosition")
        BodyPosition.Name = "forcetp"
        BodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        BodyPosition.P = 4.12
        BodyPosition.D = 1000
        BodyPosition.Parent = RootPart
    end
end

function DetectPartMobBring(name, a, b, c,b1)
    local Mob = {}
    for i,v in pairs(game.Workspace.MobSpawns:GetChildren()) do
        if name == v.Name then
            table.insert(Mob, v)
        end
    end
    if b then
        if b1 then
            local Farest, dist = nil, -math.huge
            for i, v in next, Mob do
                local conconcac = (a.HumanoidRootPart.Position - v.Position).Magnitude
                if dist < conconcac and GetDistance(a.HumanoidRootPart,v) <= 300 then
                    dist = conconcac
                    Farest = v
                end
            end
            return Farest
        else
            local Closest, dist = nil, math.huge
            for i, v in next, Mob do
                local conconcac = (a.WorldPivot.Position - v.Position).Magnitude
                if dist > conconcac then
                    dist = conconcac
                    Closest = v
                end
            end
            return Closest
        end
    else
        local mob2 = {}
        for i, v in next, Mob do
            if (c.Position - v.Position).Magnitude <= 300 then
                table.insert(mob2, v)
            end
        end
        if #mob2 < #Mob then
            --print("condimemay")
            return true
        end
    end
end
local function Bring(Realmob, Enemy, BringCFrame)
    if Enemy:HasTag('Brought') then return end
    Enemy:AddTag("Brought")  
    local RootPart = Enemy:FindFirstChild("HumanoidRootPart")
    local Humanoid = Enemy:FindFirstChild("Humanoid")
    local oldHealth = Humanoid.Health
    local count = tick()
    repeat
        sizepart(Enemy)
        if not skidymf(Enemy) or not skidymf(Realmob) then break end
        if GetDistance(BringCFrame, RootPart.CFrame) <= 200 then
            if GetDistance(BringCFrame, RootPart.CFrame) > 5 then
                RootPart.CFrame = BringCFrame
            end
        else
            break
        end
        wait()
    until not skidymf(Enemy) or not skidymf(Realmob) or Realmob:HasTag('ignore') or tick() - count>=60
    if skidymf(Enemy) then
        if Realmob:HasTag('ignore') then
            Enemy:MoveTo(Enemy.WorldPivot.Position)
        elseif Humanoid.Health == oldHealth and Enemy:HasTag('secondmob') then
            Enemy:MoveTo(Enemy.WorldPivot.Position)
            Enemy:AddTag('ignore')
        end
        Enemy:RemoveTag('Brought')
    end
    --if CloneAttachment then CloneAttachment:Destroy() end
end
function isnetworkowner2(p1)
    for i, v in next, game.Workspace.Characters:GetChildren() do
        if v.Name ~= LocalPlayer.Name and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - p1.Position).Magnitude <= 300 then
            return false
        end
    end
    return true
end
function isnetworkowner(p1)
    local A = gethiddenproperty(LocalPlayer, "SimulationRadius")
    local C = game.WaitForChild(Character, "HumanoidRootPart", 300)
    if C then
        if p1.Anchored then
            return false
        end
        if game.IsDescendantOf(p1, Character) or (C.Position - p1.Position).Magnitude <= A then
            return true
        end
    end
    return false
end
function BringMob(Enemy, BringCFrame, notLimit)
    local hasmob = false
    local secondmob = false
    pcall(sethiddenproperty, LocalPlayer, "SimulationRadius", 5000)
    local EnemyRootPart = Enemy:FindFirstChild('HumanoidRootPart')
    if not EnemyRootPart then return end
    local Arrange = World1 and 250 or 300
    BringCFrame = not BringCFrame and DetectPartMobBring(Enemy.Name, Enemy, true).CFrame or BringCFrame
    local MonPosition = Enemy.HumanoidRootPart.Position 
    local MidPoint, Count = Vector3.zero, 0
    local MobsTable = {Enemy}
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v and v.Name == Enemy.Name and skidymf(v) and isnetworkowner(v.HumanoidRootPart) and isnetworkowner2(v.HumanoidRootPart) then
            local dis = GetDistance(v.HumanoidRootPart.CFrame, BringCFrame)
            if dis <= Arrange and not v:HasTag('realmob') and not v:HasTag("Brought") then
                hasmob = true
                Count = Count + 1 
                Enemy:SetAttribute("OldPosition",MonPosition)
                MidPoint = MidPoint + v.HumanoidRootPart.Position
                table.insert(MobsTable, v)
            end
        end
    end
    MidPoint = CFrame.new( MidPoint / Count )
    if hasmob then
        table.foreach(MobsTable, function(_, ChildInstance)
            if not ChildInstance:HasTag('ignore') then
                if not secondmob then
                    secondmob = true
                    ChildInstance:AddTag('secondmob')
                end
                spawn(function()
                    Bring(Enemy, ChildInstance, MidPoint)
                end)
            end
        end)
        return true
    end
end

function AutoHaki()
  local player = game:GetService("Players").LocalPlayer
  local character = player.Character
  if character and not character:FindFirstChild("HasBuso") then
    local remote = game:GetService("ReplicatedStorage").Remotes.CommF_
    if remote then
      remote:InvokeServer("Buso") 
    end
  end
end
function EquipWeaponMelee()
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == "Melee" and v:IsA('Tool') then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end
function SendKey(key, holdtime,mmb)
    if key and (not mmb or (mmb)) then
        if not holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait()
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        elseif holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait(holdtime)
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        end
    end
end

function GetCFrameADD(v2)
    task.wait()
    if game.Players.LocalPlayer.Character.Humanoid.Sit then 
        SendKey('Space',.5) 
    end
    return CFrame.new(0,20,0)
end 


    

function skidymf(v)
    if v and v.Parent and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 and v:FindFirstChildOfClass("Humanoid") then
        return true
    else
        return false
    end
end
function KillNigga(MobInstance)
    if not skidymf(MobInstance) then return end
    local brought
    local IsBoss = MobInstance:GetAttribute('IsBoss') or MobInstance.Humanoid.DisplayName:find('Boss') or MobInstance.Name == 'Core'
    print("Killing " .. MobInstance.Name)
    if MobInstance:HasTag('secondmob') then MobInstance:RemoveTag('secondmob') end
    MobInstance:AddTag('realmob')
    local mobhumanoid = MobInstance.Humanoid
    local Count, Count2, Debounce = 0, 0, os.time()
    repeat
        task.wait()
        local success, err = pcall(function()
            if not skidymf(MobInstance) or not IsPlayerAlive() then return end
            if GetDistance(MobInstance.HumanoidRootPart.CFrame) > 20 then
                TP1(MobInstance.HumanoidRootPart.CFrame *CFrame.new(0, 30, 0))
            end
            if GetDistance(MobInstance.HumanoidRootPart.CFrame) < 150 then
                if Count >= 8 and mobhumanoid.Health - mobhumanoid.MaxHealth == 0 then
                    Count = 0
                    local akikichiuluon = MobInstance:GetAttribute("OldPosition") 
                    if akikichiuluon then
                    print('tp back')           
                    MobInstance:SetPrimaryPartCFrame(CFrame.new(akikichiuluon))
                    MobInstance:AddTag('ignore')
                    MobInstance:SetAttribute("Count", (MobInstance:GetAttribute("Count") or 0) + 1)  
                    task.wait()
                    return
                    end
                end
                local Weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if not Weapon or Weapon.ToolTip == "" or Weapon.ToolTip == nil then
                    print('equip wp')
                    EquipWeaponMelee()
                end
                FastAttacked()
                if os.time() ~= Debounce then 
                    Debounce = os.time()
                    Count = Count + 1
                    Count2 = Count2 + 1
                end 
            end
        end)
        if not success then
            print('kill function error ' .. tostring(err))
        end
    until not skidymf(MobInstance) or not IsPlayerAlive() 
end

function CheckMob(mobormoblist,rep)
    if typeof(mobormoblist) == 'table' then 
        for i,v in pairs(mobormoblist) do 
            for __,v2 in pairs(game.workspace.Enemies:GetChildren()) do 
                if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                    return v2
                end
            end
        end
        if rep then 
            for i,v in pairs(mobormoblist) do 
                for __,v2 in pairs(game.ReplicatedStorage:GetChildren()) do 
                    if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                        return v2
                    end
                end
            end
        end
    else
        for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
            if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                return v
            end
        end
        if rep then 
            for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
                if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                    return v
                end
            end
        end
    end
end
_G.MobFarest = {}
function getMobSpawnExtra()
    for i2,v2 in pairs(game.Workspace.MobSpawns:GetChildren()) do 
        if GetDistance(v2,MobSpawnClone[v2]) > 350 then 
            local indexg = 0
            if not _G.MobFarest[v2.Name] then 
                _G.MobFarest[v2.Name] = {} 
            else
                indexg = #_G.MobFarest[v2.Name]
            end
            local dist = GetDistance(_G.MobFarest[v2.Name][indexg],v2.CFrame)
            if indexg == 0 or (dist and dist > 350) then 
                table.insert(_G.MobFarest[v2.Name],v2.CFrame)
            end
        end 
    end
end 
task.spawn(getMobSpawnExtra)
function getMobSpawnbyList(MobList)
    local Returner = {}
    for i,v in pairs(MobList) do 
        if MobSpawnClone[v] then 
            table.insert(Returner,MobSpawnClone[v]) 
            if _G.MobFarest[v] and #_G.MobFarest[v] > 0 then 
                for i2,v2 in _G.MobFarest[v] do 
                    table.insert(Returner,v2) 
                end
            end
        end
    end
    return Returner  
end
function KillMobList(MobList)
    for i,v in pairs(MobList) do 
        MobList[i] = RemoveLevelTitle(v)
    end
    local NM = CheckMob(MobList)
    if NM then 
        KillNigga(NM)
    else
        local MS = getMobSpawnbyList(MobList) 
        if MS then 
            for i,v in pairs(MS) do 
                local isV = CheckMob(MobList)
                if not isV and v then 
                    TP1(v * CFrame.new(0,50,0))
                    wait(1)
                elseif isV then 
                    break;
                end
            end
        end
    end
end
function KillBoss(BossInstance)
    if not BossInstance or not BossInstance:FindFirstChildOfClass('Humanoid') or BossInstance:FindFirstChildOfClass('Humanoid').Health <= 0 then
        task.wait(.1)
        return 
    end 
    warn('Killing boss:',BossInstance.Name)
    if not game.Workspace.Enemies:FindFirstChild(BossInstance.Name) then  
        TP1(BossInstance.PrimaryPart.CFrame * CFrame.new(0,40,0))
    end
    KillNigga(BossInstance)
end
function EquipWeaponName(fff)
    if not fff then
        return
    end
    local ToolSe = fff
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end
function TeleportWorld(world)
    if typeof(world) == "string" then
        world = world:gsub(" ", ""):gsub("Sea", "")
        world = tonumber(world)
    end
    if world == 1 then
        local args = {
            [1] = "TravelMain"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 2 then
        local args = {
            [1] = "TravelDressrosa"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 3 then
        local args = {
            [1] = "TravelZou"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    end
end
if not World2 then
TeleportWorld(2)
end
function checkno(searchText)
    local notifications = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not notifications then return false end
    local notifFrame = notifications:FindFirstChild("Notifications")
    if not notifFrame then return false end
    for _, notification in pairs(notifFrame:GetDescendants()) do
        if notification:IsA("TextLabel") or notification:IsA("TextBox") then
            local success, text = pcall(function() return notification.Text end)
            if success and text and string.find(text:lower(), searchText:lower()) then
                return true
            end
        end
    end
    return false
end




cycheck, micro, core = false, false, false
local buyMicrochipAttempts = 0

AutoCyborg = function()
    if not World2 then
        repeat
            TeleportWorld(2)
            task.wait(3)
        until World2
    end
    local CyborgCheck = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Check")
    local BuyResult = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
    if not CyborgCheck then
    
        if not cycheck and not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") then
            fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            cycheck = true
        elseif cycheck and (checkno("Không tìm thấy con Chip.") or checkno("Microchip not found.")) and 
               not game.Players.LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") and 
               not game.Players.LocalPlayer.Character:FindFirstChild("Fist of Darkness") then
            micro = true
        end
        if micro and not game.Players.LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") and 
           not game.Players.LocalPlayer.Character:FindFirstChild("Fist of Darkness") then
            if _G.ChestCollect >= 30 then
                HopServer(9, true, "Find new server for Fist of Darkness")
            else
                local NearestChest = getNearestChest()
                if NearestChest then
                    PickChest(NearestChest)
                elseif #_G.ServerData['Chest'] <= 0 then
                    HopServer(9, true, "Find Chest")
                end
            end
        elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") then
            micro = false
            fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
        elseif (checkno("Core Brain") or checkno("Lõi")) and 
               not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") and 
               not game.Players.LocalPlayer.Character:FindFirstChild("Core Brain") then
            core = true
        end

        if core and not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") and 
           not game.Players.LocalPlayer.Character:FindFirstChild("Core Brain") then
            if (not game.Players.LocalPlayer.Backpack:FindFirstChild("Microchip") and
                not game.Players.LocalPlayer.Character:FindFirstChild("Microchip")) and
               not workspace.Enemies:FindFirstChild("Order") and
               buyMicrochipAttempts < 1 then
                task.wait(1)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "1")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
                buyMicrochipAttempts = buyMicrochipAttempts + 1
                task.wait(2)
                buyMicrochipAttempts = 0
            elseif (game.Players.LocalPlayer.Backpack:FindFirstChild("Microchip") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain")) and
                   not workspace.Enemies:FindFirstChild("Order") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") then
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end

            if workspace.Enemies:FindFirstChild("Order") then
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Order" and v:FindFirstChildOfClass("Humanoid") and 
                       v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        repeat 
                            task.wait(0.1)
                            KillBoss(v)
                        until not v:FindFirstChildOfClass("Humanoid") or 
                              v.Humanoid.Health <= 0 or 
                              not v:FindFirstChild("HumanoidRootPart") or
                              game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") or 
                              game.Players.LocalPlayer.Character:FindFirstChild("Core Brain")
                    end
                end
            end
        elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Core Brain") or 
               game.Players.LocalPlayer.Character:FindFirstChild("Core Brain") then
            core = false
            fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end
        else
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
            return
        end
    end





AutoRaceV2 = function()
    if game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 1') and game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 2') and game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 3') then 
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
        wait(5)
        return
    else
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2") 
        if not game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 1') then 
            if workspace.Flower1.Transparency ~= 1 then
                TP1(workspace.Flower1.CFrame)   
            else  
                HopServer(10,true,"Blue Flower")
            end
        elseif not game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 2') then 
            TP1(workspace.Flower2.CFrame)
        else 
            repeat 
                KillMobList({"Swan Pirate"})
                task.wait()
            until game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 3') or not IsPlayerAlive() 

        end
    end
end
function AddVelocity()
    if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Lavie Hub") then
        local body = Instance.new("BodyVelocity")
        body.Name = "coconcacay"
        body.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        body.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        body.Velocity = Vector3.new(0, 0, 0)
    end
end
function CheckBoss(bg)
    if game:GetService("ReplicatedStorage"):FindFirstChild(bg) then
        for r, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if v.Name == bg and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return v
            end
        end
    end
    if game.workspace.Enemies:FindFirstChild(bg) then
        for r, v in pairs(game.workspace.Enemies:GetChildren()) do
            if v.Name == bg and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return v
            end
        end
    end
end
AutoBartiloQuest = function()
    if not World2 then
        TeleportWorld(2)
    end
    local QuestBartiloId = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
    if QuestBartiloId == 0 then 
        if game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then 
            KillMobList({"Swan Pirate"})
            repeat 
                KillMobList({"Swan Pirate"})
            until not (game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible)
        else
            TP1(CFrame.new(-456.28952, 73.0200958, 299.895966))
            if GetDistance(CFrame.new(-456.28952, 73.0200958, 299.895966)) < 10 then 
                local args = {
                    [1] = "StartQuest",
                    [2] = "BartiloQuest",
                    [3] = 1
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end 
    elseif QuestBartiloId == 1 then 
        if workspace.Enemies:FindFirstChild("Jeremy") then
                    for i, v in next, workspace.Enemies:GetChildren() do
                        if v.Name == "Jeremy" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            repeat task.wait()  KillBoss(v)
                            until not v:FindFirstChildOfClass("Humanoid") or v.Humanoid.Health <= 0 or not v:FindFirstChild("HumanoidRootPart")
                            HopServer(9,true,"Jeremy Boss")
                        end
                    end
                end
    elseif QuestBartiloId == 2 then 
        local StartCFrame =
        CFrame.new(
        -1837.46155,
        44.2921753,
        1656.19873,
        0.999881566,
        -1.03885048e-22,
        -0.0153914848,
        1.07805858e-22,
        1,
        2.53909284e-22,
        0.0153914848,
        -2.55538502e-22,
        0.999881566
    )
        if GetDistance(StartCFrame) > 400 then 
            TP1(StartCFrame)
        else
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1836, 11, 1714)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.87305, 19.3777466, 1712.01807)
            task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1813.51843, 14.8604736, 1724.79541)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "DidPlates")
        end
    end
end 
GetFruitUnder1 = function()
	local fruits = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
	if not fruits then return false end
	for _, v in ipairs(fruits) do
		if v.Type == "Blox Fruit" then
			local ok = pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", v.Name)
			end)
			if ok then return true end
		end
	end
	return false
end
evo, completed = false, false
AutoV3 = function()
    if evo == false then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
			task.wait(1)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
            evo = true
    end
    if evo and not completed and not game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible and game.Players.LocalPlayer.Data.Race.Value == "Cyborg" then
			local found = false
			repeat
				GetFruitUnder1()
				for _, container in ipairs({ game.Players.LocalPlayer.Backpack:GetChildren(), game.Players.LocalPlayer.Character:GetChildren() }) do
					for _, item in ipairs(container) do
						if string.find(item.Name, "Fruit") then
							found = true
						end
					end
				end
				task.wait(1)
			until found
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad", "3") ~= -2 then
				completed = true
			end
		end
end
function CheckRaceVer()
    local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v111 = game.Players.LocalPlayer.Data.Race:FindFirstChild("Evolved")
    if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return "V4"
    end
    if v113 == -2 then
        return "V3"
    end
    if v111 then
        return "V2"
    end
    return "V1"
end
spawn(function()
    while wait() do
        --CommF:InvokeServer("Cousin", "Buy")
        check2 = true
    end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if (v:IsA("BasePart") or v:IsA("Part")) then
            v.CanCollide = false
        end
    end
    AddVelocity()
    AutoHaki()
end)

local Priority = {
    ["Get Cyborg"] = 1,
    ["Upgrade V2"] = 2,
    ["Upgrade V3"] = 3,
}

local PriorityQueue = {}
function PriorityQueue:new()
    local obj = { queue = {} }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function PriorityQueue:push(element, priority)
    for i, task in ipairs(self.queue) do
        if task.element == element then
            return
        end
    end
    table.insert(self.queue, { element = element, priority = priority })
    table.sort(self.queue, function(a, b)
        return a.priority > b.priority
    end)
end

function PriorityQueue:pop(element)
    for i, task in ipairs(self.queue) do
        if task.element == element then
            return table.remove(self.queue, i)
        end
    end
end

function PriorityQueue:top()
    return self.queue[1] and self.queue[1].element
end

function PriorityQueue:empty()
    return #self.queue == 0
end

local queue = PriorityQueue:new()


spawn(function()
    while wait() do
        local status, result = pcall(function()
            local checkrace = CheckRaceVer()
            local race = game.Players.LocalPlayer.Data.Race.Value
            if race ~= "Cyborg" and World2 then
                queue:push("Get Cyborg", Priority["Get Cyborg"])
            else
                queue:pop("Get Cyborg")
            end
            if race == "Cyborg" and checkrace == "V1" and World2 then
                queue:push("Upgrade V2", Priority["Upgrade V2"])
            else
                queue:pop("Upgrade V2")
            end
            if race == "Cyborg" and checkrace == "V2" and World2 then
                queue:push("Upgrade V3", Priority["Upgrade V3"])
            else
                queue:pop("Upgrade V3")
            end
            queuechecked = true
        end)
        if not status then
            print('queue error'..tostring(result))
        end
    end
end)



local taskFunctions = {
    ["Get Cyborg"] = AutoCyborg,
    ["Upgrade V2"] = AutoRaceV2,
    ["Upgrade V3"] = AutoV3,
}


spawn(function()
    while wait() do
        local success, err = pcall(function()
                if taskFunctions[queue:top()] then
                    taskFunctions[queue:top()]()
                end
        end)
        if not success then
            print('function error'..tostring(err))
        end
    end
end)

local function checkchangeacc()
    local checkrace = CheckRaceVer()
    local race = game.Players.LocalPlayer.Data.Race.Value
    if race == "Cyborg" and checkrace == "V3" then
        local filename = game.Players.LocalPlayer.Name .. ".txt"
        local content  = "Completed-Done"
        if writefile and not isfile(filename) then
            writefile(filename, content)
            warn("[TLHUB] Created file: "..filename)
        end
    end
end

task.spawn(function()
    while task.wait(10) do
        pcall(checkchangeacc)
    end

end)
