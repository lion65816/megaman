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
            AC.NewSection("Br","Bright Man","Bright"),
            AC.NewSection("To","Toad Man","Toad"),
            AC.NewSection("Dr","Drill Man","Drill"),
            AC.NewSection("Ph","Pharaoh Man","Pharaoh"),
            AC.NewSection("Ri","Ring Man","Ring"),
            AC.NewSection("Du","Dust Man","Dust"),
            AC.NewSection("Di","Dive Man","Dive"),
            AC.NewSection("Sk","Skull Man","Skull"),
            AC.NewSection("C1","Cossack #1","C1"),
            AC.NewSection("C2","Cossack #2","C2"),
            AC.NewSection("C3","Cossack #3","C3"),
            AC.NewSection("C4","Cossack #4","C4"),
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
            AC.NewSection("Br","Bright Man","Bright"),
            AC.NewSection("To","Toad Man","Toad"),
            AC.NewSection("Dr","Drill Man","Drill"),
            AC.NewSection("Ph","Pharaoh Man","Pharaoh"),
            AC.NewSection("Ri","Ring Man","Ring"),
            AC.NewSection("Du","Dust Man","Dust"),
            AC.NewSection("Di","Dive Man","Dive"),
            AC.NewSection("Sk","Skull Man","Skull"),
            AC.NewSection("C1","Mothraya","Moth"),
            AC.NewSection("C2","Square Machine","Square"),
            AC.NewSection("C3","Cockroach Twin","CTwin"),
            AC.NewSection("C4","Cossack Catcher","Catcher"),
            AC.NewSection("W1","Metall Daddy","MDaddy"),
            AC.NewSection("W2","Tako Trash","TTrash"),
            AC.NewSection("W3","Wily Machine","Machine"),
            AC.NewSection("W4","Wily Capsule","Capsule"),
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
            AC.NewSection("Br","Bright Man","Bright"),
            AC.NewSection("To","Toad Man","Toad"),
            AC.NewSection("Dr","Drill Man","Drill"),
            AC.NewSection("Ph","Pharaoh Man","Pharaoh"),
            AC.NewSection("Ri","Ring Man","Ring"),
            AC.NewSection("Du","Dust Man","Dust"),
            AC.NewSection("Di","Dive Man","Dive"),
            AC.NewSection("Sk","Skull Man","Skull"),
            AC.NewSection("C1","Cossack #1","C1"),
            AC.NewSection("C2","Cossack #2","C2"),
            AC.NewSection("C3","Cossack #3","C3"),
            AC.NewSection("C4","Cossack #4","C4"),
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
        AC.ActivateCategory(2,memory.readbyte(0x0022)+1)
        AC.ActivateCategory(4,memory.readbyte(0x0022)+1)
        AC.InactivateCategory(3)
    end
end
AC.ActivateCategory_Boss = function()
    local x = memory.getregister("x")
    local type = memory.readbyte(0x300+x)
    if type ~= 0xC0 then
        AC.AchieveCategory(2)
        AC.ActivateCategory(3,memory.readbyte(0x0022)+1)
    end
end
AC.ActivateCategory_Boss8 = function()
    local y = memory.getregister("y")
    AC.AchieveCategory(2)
    AC.ActivateCategory(3,y+1)
end

AC.MayLoseBusterProperty_sub = function(type,tbl)
    local total = 0
    for k,v in ipairs(tbl) do
        local dmg = rom.readbyte(0x1710+0x2000*v+type)
        total = total + dmg
    end
    return total
end
AC.MayLoseBusterProperty = function()
    --バスター:見かけが豆でなければBeansOnlyを剥奪
    --ブライト:問題なし
    --ラッシュ3種:問題なし
    --ワイヤー:見かけが豆でなければ両方剥奪
    --ただし、バスター・ラッシュ3種でダメージが入らないなら剥奪しない

    local weapon = memory.readbyte(0xA0)
    local offset = memory.readbyte(0x10)
    local anim = memory.readbyte(0x558+offset)
    local prop = nil

    if weapon == 0 then
        if anim ~= 0x18 then prop = {"BeansOnly"} end
    elseif weapon == 0xC or  weapon == 0x1 or weapon == 0x2 or weapon == 0x3 then
        --処理無し
    elseif weapon == 0x5 then
        if anim ~= 0x18 then prop = {"BeansOnly","BusterOnly"} end
    else
        prop = {"BeansOnly","BusterOnly"}
    end
    if prop then
        local x = memory.getregister("x")
        local type = memory.readbyte(0x300+x)
        if AC.MayLoseBusterProperty_sub(type,{0x20,0x21,0x22,0x23}) ~= 0 then
            AC.LoseProperty(prop)
        end
    end
end
AC.AchieveCategory_LevelBoss = function()
    local rs = memory.readbyte(0x30)
    if rs == 0x8 then
        AC.AchieveCategory(4)
    end
end
Rexe.register(({[0]=0x39807E,0x39808E})[RU.RomMegaman],AC.ActivateCategory_LevelFlag,nil,"Achievement")
Rexe.register(({[0]=0x3EC846,0x3EC846})[RU.RomMegaman],AC.ActivateCategory_LevelFlag,nil,"Achievement")
Rexe.register(({[0]=0x3EC6CA,0x3EC6CA})[RU.RomMegaman],AC.ActivateCategory_Level,nil,"Achievement")
Rexe.register(({[0]=0x35A806,0x35A806})[RU.RomMegaman],AC.AchieveCategory,2,"Achievement") --再入場

Rexe.register(({[0]=0x3FFD9C,0x3FFD9C})[RU.RomMegaman],AC.ActivateCategory_Boss,nil,"Achievement")
Rexe.register(({[0]=0x35A81C,0x35A81C})[RU.RomMegaman],AC.ActivateCategory_Boss8,nil,"Achievement")

Rexe.register(({[0]=0x35AE7C,0x35AE7C})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --8Boss C3 W34
Rexe.register(({[0]=0x35A8EE,0x35A8EE})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --C12 W12
Rexe.register(({[0]=0x3DB95E,0x3DB959})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --C4

Rexe.register(({[0]=0x3C96F2,0x3C96F2})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement")
Rexe.register(({[0]=0x3A824E,0x3A824E})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x3EDC25,0x3EDC25})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x398EE6,0x398EF7})[RU.RomMegaman],AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(({[0]=0x3A81E4,0x3A81E4})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")

Rexe.register(({[0]=0x3A8131,0x3A8131})[RU.RomMegaman],AC.LoseProperty,{"BeansOnly","BusterOnly"},"Achievement") --Skull Weapon
Rexe.register(({[0]=0x3A80D4,0x3A80D4})[RU.RomMegaman],AC.LoseProperty,{"BeansOnly","BusterOnly"},"Achievement") --Bright Weapon
Rexe.register(({[0]=0x3A832E,0x3A832E})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --common

Rexe.register(({[0]=0x3C8689,0x3C8689})[RU.RomMegaman],AC.AchieveCategory_LevelBoss,nil,"Achievement")
Rexe.register(({[0]=0x35B69F,0x35B69F})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement")
Rexe.register(({[0]=0x3DB95E,0x3DB959})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --C4

Rexe.register(({[0]=0x39807E,0x39808E})[RU.RomMegaman],AC.ActivateCategory,1,"Achievement")
Rexe.register(({[0]=0x35B69F,0x35B69F})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")

