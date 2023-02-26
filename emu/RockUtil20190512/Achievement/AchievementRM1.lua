AC.Session.Property.NoETank = nil
AC.Session.Property.NoPause = {}

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
                AC.NAC("NoPause","No Pause","NoPause"),
                AC.NAC("NoContinue","No Continue","NoCont"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
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
                AC.NAC("NoPause","No Pause","NoPause"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Cu","Cut Man","Cut"),
            AC.NewSection("Ic","Ice Man","Ice"),
            AC.NewSection("Bo","Bomb Man","Bomb"),
            AC.NewSection("Fi","Fire Man","Fire"),
            AC.NewSection("El","Elec Man","Elec"),
            AC.NewSection("Gu","Guts Man","Guts"),
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
                AC.NAC("NoPause","No Pause","NoPause"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Cu","Cut Man","Cut"),
            AC.NewSection("Ic","Ice Man","Ice"),
            AC.NewSection("Bo","Bomb Man","Bomb"),
            AC.NewSection("Fi","Fire Man","Fire"),
            AC.NewSection("El","Elec Man","Elec"),
            AC.NewSection("Gu","Guts Man","Guts"),
            AC.NewSection("W1","Yellow Devil","YDevil"),
            AC.NewSection("W2","Copy Robot","Copy"),
            AC.NewSection("W3","CWU-01P","CWU01P"),
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
                AC.NAC("NoPause","No Pause","NoPause"),
                AC.NAC("NoMiss","No Miss","NoMiss"),
                AC.NAC("NoDamage","No Damage","NoDmg"),
                TableWidth=44
            },
            {
                AC.NAC("NA","*","*"),
                AC.NAC("BusterOnly","Buster Only","b"),
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("Cu","Cut Man","Cut"),
            AC.NewSection("Ic","Ice Man","Ice"),
            AC.NewSection("Bo","Bomb Man","Bomb"),
            AC.NewSection("Fi","Fire Man","Fire"),
            AC.NewSection("El","Elec Man","Elec"),
            AC.NewSection("Gu","Guts Man","Guts"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
        },
   },
}
AC.ActivateCategory_Level = function(n)
    local level = memory.readbyte(0x31)
    if level <= 0x9 then
        AC.ActivateCategory(2,level+1)
        AC.ActivateCategory(4,level+1)
    end
    AC.InactivateCategory(3)
end
AC.ActivateCategory_Boss = function()
    local bosstype = memory.readbyte(0xAC)
    local level = memory.readbyte(0x31)
    if bosstype ~= level then
        AC.SleepCategory(2)
    else
        AC.AchieveCategory(2)
    end
    if bosstype ~= 0xA then
        AC.ActivateCategory(3,bosstype+1)
    end
end
AC.AchieveCategory_Boss = function()
    local bosstype = memory.readbyte(0xAC)
    local level = memory.readbyte(0x31)
    AC.WakeCategory(2)
    if level >= 6 and bosstype ~= 0x9 then
        AC.AchieveCategory(3)
    end
end
AC.AchieveCategory_CWU = function()
    local a = memory.getregister("a")
    if a == 0 then
        AC.AchieveCategory(3)
    end
end
AC.MayLoseBusterProperty = function(n)
    local weapon = memory.readbyte(0x5F)
    local addrdmgtable = memory.readword(0xBF44)
    local type = memory.getregister("y")
    local busterdmg = memory.readbyte(addrdmgtable+type)
    if weapon ~= 0 and busterdmg ~= 0 then
        AC.LoseProperty({"BusterOnly"})
    end
end
AC.MayLoseBusterProperty_b = function(n)
    local bosstype = memory.readbyte(0xAC)
    local weapon = memory.readbyte(0x5F)
    local dmg = memory.readbyte(({[0]=0xFE22,0xA942})[RU.RomMegaman]+bosstype*8)
    if weapon ~= 0 and dmg ~= 0 then
        AC.LoseProperty({"BusterOnly"})
    end
end


Rexe.register(({[0]=0x0A907B,0x0A907B})[RU.RomMegaman],AC.ActivateCategory_Level,nil,"Achievement")

Rexe.register(({[0]=0x0EDBAF,0x0EDBAF})[RU.RomMegaman],AC.ActivateCategory_Boss,nil,"Achievement")

Rexe.register(({[0]=0x0ECA2D,0x0ECA2D})[RU.RomMegaman],AC.AchieveCategory_Boss,nil,"Achievement")
Rexe.register(({[0]=0x0EC890,0x0EC890})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement")
Rexe.register(({[0]=0x0FF4F1,0x0FF4F1})[RU.RomMegaman],AC.AchieveCategory_CWU,nil,"Achievement")
Rexe.register(({[0]=0x0A907E,0x0A907E})[RU.RomMegaman],AC.WakeCategory,2,"Achievement")

Rexe.register(({[0]=0x0A91CF,0x0A91CF})[RU.RomMegaman],AC.LoseProperty,{"NoPause"},"Achievement")

Rexe.register(({[0]=0x0EC219,0x0EC219})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x0EC2D1,0x0EC2D1})[RU.RomMegaman],AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(({[0]=0x0BA242,0x0BA242})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")

Rexe.register(({[0]=0x0BBEDD,0x0BBEDD})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement")
Rexe.register(({[0]=0x0EC90F,0x0EC90F})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement")

Rexe.register(({[0]=0x0EC063,0x0EC063})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement")

Rexe.register(({[0]=0x0FFA4C,0x0FFA16})[RU.RomMegaman],AC.ActivateCategory,1,"Achievement")
Rexe.register(({[0]=0x0ECB03,0x0ECB03})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")
