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
            AC.NewSection("Bliz","Blizzard Man","Bliz"),
            AC.NewSection("Wind","Wind Man","Wind"),
            AC.NewSection("Plant","Plant Man","Plant"),
            AC.NewSection("Flame","Flame Man","Flame"),
            AC.NewSection("Yamato","Yamato Man","Yamato"),
            AC.NewSection("Toma","Tomahawk Man","Toma"),
            AC.NewSection("Knight","Knight Man","Knight"),
            AC.NewSection("Cent","Centaur Man","Cent"),
            AC.NewSection("X1","Mr.X #1","X1"),
            AC.NewSection("X2","Mr.X #2","X2"),
            AC.NewSection("X3","Mr.X #3","X3"),
            AC.NewSection("X4","Mr.X #4","X4"),
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
            AC.NewSection("Bliz","Blizzard Man","Bliz"),
            AC.NewSection("Cent","Centaur Man","Cent"),
            AC.NewSection("Flame","Flame Man","Flame"),
            AC.NewSection("Knight","Knight Man","Knight"),
            AC.NewSection("Plant","Plant Man","Plant"),
            AC.NewSection("Toma","Tomahawk Man","Toma"),
            AC.NewSection("Wind","Wind Man","Wind"),
            AC.NewSection("Yamato","Yamato Man","Yamato"),
            AC.NewSection("Round","Rounder II","Round"),
            AC.NewSection("Piston","Power Piston","Piston"),
            AC.NewSection("Metton","Mettonger Z","Metton"),
            AC.NewSection("XCrush","X Crusher","XCrush"),
            AC.NewSection("MechaZ","Mechazaurus","MechaZ"),
            AC.NewSection("TankCS","Tank CSII","TankCS"),
            AC.NewSection("Wily","Wily","Wily"),
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
            AC.NewSection("Bliz","Blizzard Man","Bliz"),
            AC.NewSection("Wind","Wind Man","Wind"),
            AC.NewSection("Plant","Plant Man","Plant"),
            AC.NewSection("Flame","Flame Man","Flame"),
            AC.NewSection("Yamato","Yamato Man","Yamato"),
            AC.NewSection("Toma","Tomahawk Man","Toma"),
            AC.NewSection("Knight","Knight Man","Knight"),
            AC.NewSection("Cent","Centaur Man","Cent"),
            AC.NewSection("X1","Mr.X #1","X1"),
            AC.NewSection("X2","Mr.X #2","X2"),
            AC.NewSection("X3","Mr.X #3","X3"),
            AC.NewSection("X4","Mr.X #4","X4"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
        },
   },
}

AC.ActivateCategory_Level = function(n)
    AC.ActivateCategory(2,memory.readbyte(0x0051)+1)
    AC.ActivateCategory(4,memory.readbyte(0x0051)+1)
    AC.InactivateCategory(3)
end
AC.ActivateCategory_Boss = function(n)
    AC.AchieveCategory(2)
    if n == 0 then
        local Tbl = {[0]=0,6,4,2,7,5,3,1}
        n = Tbl[memory.readbyte(0x063D)]+1
    end
    AC.ActivateCategory(3,n)
end
--武器側の着弾処理で行うか、敵が受ける側で行うのか迷ったが
--受ける側は範囲が広すぎるので、着弾側で行うことにした
AC.MayLoseBusterProperty_b = function(n)
    local tmp = memory.getregister("a")
    local x = memory.getregister("x")
    local type = memory.readbyte(0x03A0+x)
    if tmp >= 0x20 or memory.readbyte(0x9B)==2 then
        AC.LoseProperty({"BeansOnly","BusterOnly"})
    elseif tmp > 0x11 or type==0x0A then
        AC.LoseProperty("BeansOnly")
    end
end
--[[
AC.MayLoseBusterProperty_e = function(n)
    local x = memory.getregister("x")
    local hitstat = memory.readbyte(0x56C+x)
    local attr = AND(hitstat,0xF0)
    local dmg = AND(hitstat,0x0F)
    if attr == 0x00 or attr == 0x30 or dmg == 0 then
    else
        if attr == 0x10 then
            if memory.readbyte(0x9B)==2 then
                AC.LoseProperty({"BeansOnly","BusterOnly"})
            elseif dmg >= 2 then
                AC.LoseProperty({"BeansOnly"})
            end
        else
            AC.LoseProperty({"BeansOnly","BusterOnly"})
        end
    end
end
--]]

Rexe.register(({[0]=0x3ECD43,0x3ECD49})[RU.RomMegaman],AC.ActivateCategory_Level,2,"Achievement")

Rexe.register(({[0]=0x3FF951,0x3FF94D})[RU.RomMegaman],AC.ActivateCategory_Boss,0,"Achievement")
Rexe.register(({[0]=0x398FE4,0x398FE4})[RU.RomMegaman],AC.ActivateCategory_Boss,9,"Achievement")
Rexe.register(({[0]=0x398BE9,0x398BE9})[RU.RomMegaman],AC.ActivateCategory_Boss,10,"Achievement")
Rexe.register(({[0]=0x398BD6,0x398BD6})[RU.RomMegaman],AC.ActivateCategory_Boss,11,"Achievement")
Rexe.register(({[0]=0x398C1C,0x398C1C})[RU.RomMegaman],AC.ActivateCategory_Boss,12,"Achievement")
Rexe.register(({[0]=0x398B24,0x398B24})[RU.RomMegaman],AC.ActivateCategory_Boss,13,"Achievement")
Rexe.register(({[0]=0x398BC5,0x398BC5})[RU.RomMegaman],AC.ActivateCategory_Boss,14,"Achievement")
Rexe.register(({[0]=0x398FF5,0x398FF5})[RU.RomMegaman],AC.ActivateCategory_Boss,15,"Achievement")
Rexe.register(({[0]=0x398EE7,0x398EE7})[RU.RomMegaman],AC.ActivateCategory_Boss,0,"Achievement")
Rexe.register(({[0]=0x3FF968,0x3FF964})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement")
Rexe.register(({[0]=0x398EF8,0x398EF8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement")
Rexe.register(({[0]=0x398CD1,0x398CD1})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --X4
Rexe.register(({[0]=0x3990E5,0x3990E5})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --W4

Rexe.register(({[0]=0x389537,0x389537})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement")
Rexe.register(0x388E62,AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(0x388F08,AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(0x388E8E,AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(0x388F80,AC.LoseProperty,"NoDamage","Achievement")

Rexe.register(0x38902F,AC.LoseProperty,{"BeansOnly","BusterOnly"},"Achievement") --Plant Barrier
Rexe.register(0x38906A,AC.MayLoseBusterProperty_b,nil,"Achievement") --common
--Rexe.register(0x3890E1,AC.BusterProperty,nil,"Achievement") --反射/許容する
Rexe.register(0x389E74,AC.LoseProperty,{"BeansOnly","BusterOnly"},"Achievement") --CFlash
--Rexe.register(0x3FEA01,AC.MayLoseBusterProperty_e,nil,"Achievement") --common
--Rexe.register(0x3FEA4A,AC.MayLoseBusterProperty_e,nil,"Achievement") --MidExp
--Rexe.register(0x3FEB12,AC.MayLoseBusterProperty_e,nil,"Achievement") --element
--Rexe.register(0x3FEF8F,AC.MayLoseBusterProperty_e,nil,"Achievement") --Gamarn/XBoss/WBoss

Rexe.register(({[0]=0x38923A,0x38923A})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement")
Rexe.register(({[0]=0x398CD1,0x398CD1})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --X4
Rexe.register(({[0]=0x398EC3,0x398EC3})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W3
Rexe.register(({[0]=0x399152,0x399152})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W4

Rexe.register(({[0]=0x3ECEDF,0x3ECEE3})[RU.RomMegaman],AC.ActivateCategory,1,"Achievement")
Rexe.register(({[0]=0x399152,0x399152})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")
