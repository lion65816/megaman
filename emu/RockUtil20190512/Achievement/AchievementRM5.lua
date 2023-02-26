AC.Session.Property.BeansOnly = {}

AC.Category = 
{
    {
        Name="Play Through",
        Key="PT",
        ShowTable=AC.ShowCategory,
        Achievements=
        {
            {
                AC.NAC("NA","*","*"),
                AC.NAC("NoContinue","No Continue","NoCont"),
                AC.NAC("NoETank","No Tanks","NoTank"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                AC.NAC("BeansOnly","Beans Only","m"),
                TableWidth=10
            }
        },
        Sections={AC.NewSection("","","")},
    },
    {
        Name="Level",
        Key="Lv",
        ShowTable=AC.ShowCategory,
        Achievements=
        {
            {
                AC.NAC("NA","*","*"),
                AC.NAC("NoETank","No Tanks","NoTank"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                AC.NAC("BeansOnly","Beans Only","m"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Gra","Gravity Man","Gravity"),
            AC.NewSection("Wav","Wave Man","Wave"),
            AC.NewSection("Sto","Stone Man","Stone"),
            AC.NewSection("Gyr","Gyro Man","Gyro"),
            AC.NewSection("Sta","Star Man","Star"),
            AC.NewSection("Cha","Charge Man","Charge"),
            AC.NewSection("Nap","Napalm Man","Napalm"),
            AC.NewSection("Cry","Crystal Man","Crystal"),
            AC.NewSection("D1","Darkman #1","D1"),
            AC.NewSection("D2","Darkman #2","D2"),
            AC.NewSection("D3","Darkman #3","D3"),
            AC.NewSection("D4","Darkman #4","D4"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
        },
   },
    {
        Name="Boss",
        Key="Bo",
        ShowTable=AC.ShowCategory,
        Achievements=
        {
            {
                AC.NAC("NA","*","*"),
                AC.NAC("NoETank","No Tanks","NoTank"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                AC.NAC("BeansOnly","Beans Only","m"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Gra","Gravity Man","Gravity"),
            AC.NewSection("Wav","Wave Man","Wave"),
            AC.NewSection("Sto","Stone Man","Stone"),
            AC.NewSection("Gyr","Gyro Man","Gyro"),
            AC.NewSection("Sta","Star Man","Star"),
            AC.NewSection("Cha","Charge Man","Charge"),
            AC.NewSection("Nap","Napalm Man","Napalm"),
            AC.NewSection("Cry","Crystal Man","Crystal"),
            AC.NewSection("D1","Darkman #1","D1"),
            AC.NewSection("D2","Darkman #2","D2"),
            AC.NewSection("D3","Darkman #3","D3"),
            AC.NewSection("D4","Darkman #4","D4"),
            AC.NewSection("W1","Big Pets","BPets"),
            AC.NewSection("W2","Circring Q9","CQ9"),
            AC.NewSection("W3","Wily Press","WPress"),
            AC.NewSection("W4","Wily","Wily"),
        },
    },
    {
        Name="Level&Boss",
        Key="LB",
        ShowTable=AC.ShowCategory,
        Achievements=
        {
            {
                AC.NAC("NA","*","*"),
                AC.NAC("NoETank","No Tanks","NoTank"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                AC.NAC("BeansOnly","Beans Only","m"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Gra","Gravity Man","Gravity"),
            AC.NewSection("Wav","Wave Man","Wave"),
            AC.NewSection("Sto","Stone Man","Stone"),
            AC.NewSection("Gyr","Gyro Man","Gyro"),
            AC.NewSection("Sta","Star Man","Star"),
            AC.NewSection("Cha","Charge Man","Charge"),
            AC.NewSection("Nap","Napalm Man","Napalm"),
            AC.NewSection("Cry","Crystal Man","Crystal"),
            AC.NewSection("D1","Darkman #1","D1"),
            AC.NewSection("D2","Darkman #2","D2"),
            AC.NewSection("D3","Darkman #3","D3"),
            AC.NewSection("D4","Darkman #4","D4"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
        },
   },
}

AC.ActivateCategory_LevelFlag = function()
    AC.Session.LevelFlag = true
    AC.InactivateCategory(2)
    AC.InactivateCategory(3)
end
AC.ActivateCategory_Level = function()
    if AC.Session.LevelFlag then
        AC.Session.LevelFlag = nil
        AC.ActivateCategory(2,memory.readbyte(0x006C)+1)
        AC.ActivateCategory(4,memory.readbyte(0x006C)+1)
        AC.InactivateCategory(3)
    end
end
AC.ActivateCategory_Boss = function(n)
    AC.AchieveCategory(2)
    if n == 0 then
        n = memory.getregister("a") + 1
    end
    AC.ActivateCategory(3,n)
end

AC.MayLoseBusterProperty_sub = function(type,tbl)
    local total = 0
    for k,v in ipairs(tbl) do
        local dmg = rom.readbyte(0x810+0x2000*v+type)
        total = total + dmg
    end
    return total
end
AC.MayLoseBusterProperty = function()
    --バスター:見かけが豆でなければBeansOnlyを剥奪
    --ラッシュ2種:無条件で問題なし
    --ビート:見かけが豆でなければ両方剥奪
    --ただし、バスター・ラッシュ2種でダメージが入らないなら剥奪しない

    local weapon = memory.readbyte(0x32)
    local offset = memory.readbyte(0x10)
    local anim = memory.readbyte(0x558+offset)
    local prop = nil

    if weapon == 0 then
        if anim ~= 0x18 then prop = {"BeansOnly"} end
    elseif weapon == 0xA or weapon == 0xB then
        --処理無し
    elseif weapon == 0xC then
        if anim ~= 0x18 then prop = {"BeansOnly","BusterOnly"} end
    else
        prop = {"BeansOnly","BusterOnly"}
    end
    if prop then
        local x = memory.getregister("x")
        local type = memory.readbyte(0x300+x)
        if AC.MayLoseBusterProperty_sub(type,{0x0,0xA,0xB}) ~= 0 then
            AC.LoseProperty(prop)
        end
    end
end

Rexe.register(({[0]=0x1780D4,0x1780D4})[RU.RomMegaman],AC.ActivateCategory_LevelFlag,nil,"Achievement")
Rexe.register(({[0]=0x1FF465,0x1FF465})[RU.RomMegaman],AC.ActivateCategory_LevelFlag,nil,"Achievement")
Rexe.register(({[0]=0x1EDE48,0x1EDE48})[RU.RomMegaman],AC.ActivateCategory_Level,nil,"Achievement")
Rexe.register(({[0]=0x0AA2E4,0x0AA2E4})[RU.RomMegaman],AC.AchieveCategory,2,"Achievement") --再入場

Rexe.register(({[0]=0x0AA317,0x0AA317})[RU.RomMegaman],AC.ActivateCategory_Boss,0,"Achievement")
Rexe.register(({[0]=0x09A417,0x09A417})[RU.RomMegaman],AC.ActivateCategory_Boss,12,"Achievement")
Rexe.register(({[0]=0x02A000,0x02A000})[RU.RomMegaman],AC.ActivateCategory_Boss,13,"Achievement")
Rexe.register(({[0]=0x02A291,0x02A291})[RU.RomMegaman],AC.ActivateCategory_Boss,14,"Achievement")
Rexe.register(({[0]=0x02A61A,0x02A61A})[RU.RomMegaman],AC.ActivateCategory_Boss,15,"Achievement")
Rexe.register(({[0]=0x04A000,0x04A000})[RU.RomMegaman],AC.ActivateCategory_Boss,16,"Achievement")

Rexe.register(({[0]=0x0AA129,0x0AA129})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --8Boss/D1234
Rexe.register(({[0]=0x0AA053,0x0AA053})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --W1/W2
Rexe.register(({[0]=0x0AA000,0x0AA000})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --W3
Rexe.register(({[0]=0x0AA1F8,0x0AA1F8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --W4

Rexe.register(({[0]=0x018156,0x018156})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement") --E
Rexe.register(({[0]=0x0182D9,0x0182D9})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement") --M
Rexe.register(({[0]=0x1C8332,0x1C8332})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x1FE037,0x1FE037})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x1785DF,0x1785E2})[RU.RomMegaman],AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(({[0]=0x1C82D6,0x1C82D6})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")
--Rexe.register(({[0]=0x1C82B1,})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement") --未使用ダメージエリア/保留

Rexe.register(({[0]=0x1C80C7,0x1C80C7})[RU.RomMegaman],AC.LoseProperty,{"BeansOnly","BusterOnly"},"Achievement") --Wave/Star Weapon
Rexe.register(({[0]=0x1C81AA,0x1C81AA})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --common

Rexe.register(({[0]=0x1B880C,0x1B880C})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement")
Rexe.register(({[0]=0x1B89D3,0x1B89D3})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --D4
Rexe.register(({[0]=0x0AA1F8,0x0AA1F8})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W4

Rexe.register(({[0]=0x1780D4,0x1780D4})[RU.RomMegaman],AC.ActivateCategory,1,"Achievement")
Rexe.register(({[0]=0x0AA1F8,0x0AA1F8})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")

