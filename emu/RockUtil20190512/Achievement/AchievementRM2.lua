
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
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("He","Heat Man","Heat"),
            AC.NewSection("Ai","Air Man","Air"),
            AC.NewSection("Wo","Wood Man","Wood"),
            AC.NewSection("Bu","Bubble Man","Bubb"),
            AC.NewSection("Qu","Quick Man","Quick"),
            AC.NewSection("Fl","Flash Man","Flash"),
            AC.NewSection("Me","Metal Man","Metal"),
            AC.NewSection("Cl","Clash Man","Clash"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
            AC.NewSection("W5","Wily #5","W5"),
            AC.NewSection("W6","Wily #6","W6"),
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
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("He","Heat Man","Heat"),
            AC.NewSection("Ai","Air Man","Air"),
            AC.NewSection("Wo","Wood Man","Wood"),
            AC.NewSection("Bu","Bubble Man","Bubb"),
            AC.NewSection("Qu","Quick Man","Quick"),
            AC.NewSection("Fl","Flash Man","Flash"),
            AC.NewSection("Me","Metal Man","Metal"),
            AC.NewSection("Cl","Clash Man","Clash"),
            AC.NewSection("MDra","Mecha Dragon","Dragon"),
            AC.NewSection("Pico","Picopico-kun","Pico"),
            AC.NewSection("GTank","Guts Tank","GTank"),
            AC.NewSection("BBeam","Boobeam Trap","BBeam"),
            AC.NewSection("Wily","Wily Machine 2","Wily"),
            AC.NewSection("Alien","Alien","Alien"),
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
                TableWidth=10
            }
        },
        Sections=
        {
            AC.NewSection("He","Heat Man","Heat"),
            AC.NewSection("Ai","Air Man","Air"),
            AC.NewSection("Wo","Wood Man","Wood"),
            AC.NewSection("Bu","Bubble Man","Bubb"),
            AC.NewSection("Qu","Quick Man","Quick"),
            AC.NewSection("Fl","Flash Man","Flash"),
            AC.NewSection("Me","Metal Man","Metal"),
            AC.NewSection("Cl","Clash Man","Clash"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
            AC.NewSection("W5","Wily #5","W5"),
            AC.NewSection("W6","Wily #6","W6"),
        },
   },
}
AC.MayStart = function(n)
    if memory.readbyte(0xBE) == 0 then
        AC.ActivateCategory(1,1)
	end
end
AC.ActivateCategory_Level = function(n)
    local level = memory.readbyte(0x2A)
    AC.ActivateCategory(2,level+1)
    AC.ActivateCategory(4,level+1)
    AC.InactivateCategory(3)
end
AC.ActivateCategory_Boss = function(n)
    AC.AchieveCategory(2)
    AC.ActivateCategory(3,memory.readbyte(0xB3)+1)
end

AC.MayLoseBusterProperty = function(n)
    local off = memory.readbyte(0x2B)
    local type = memory.readbyte(0x400+off)
    local dmg = memory.readbyte(({[0]=0xE976,0xE998})[RU.RomMegaman]+type)
    if dmg ~= 0 then
        AC.LoseProperty({"BusterOnly"})
    end
end
AC.MayLoseBusterProperty_b = function(n)
    local off = memory.readbyte(0xB3)
    local dmg = memory.readbyte(({[0]=0xA923,0xA942})[RU.RomMegaman]+off)
    if dmg ~= 0 and dmg < 0x80 then
        AC.LoseProperty({"BusterOnly"})
    end
end

Rexe.register(({[0]=0x1C809B,0x1C809B})[RU.RomMegaman],AC.ActivateCategory_Level,2,"Achievement")

Rexe.register(({[0]=0x1EC809,0x1EC80C})[RU.RomMegaman],AC.ActivateCategory_Boss,0,"Achievement")
Rexe.register(({[0]=0x1DB8AA,0x1DB8AA})[RU.RomMegaman],AC.ActivateCategory_Boss,0,"Achievement") --Dragon

Rexe.register(({[0]=0x1EC1F8,0x1EC1F8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement")
Rexe.register(({[0]=0x169FE8,0x169FE8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --Boss Rush
Rexe.register(({[0]=0x1C842D,0x1C842D})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --Boss Rush(warp)

Rexe.register(({[0]=0x1A9296,0x1A9296})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement")
Rexe.register(({[0]=0x1EC10B,0x1EC10B})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x1EC1BA,0x1EC1BA})[RU.RomMegaman],AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(({[0]=0x17A56E,0x17A56E})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")
Rexe.register(({[0]=0x1FE59B,0x1FE59E})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")

Rexe.register(({[0]=0x17A6A2,0x17A6A8})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss He
Rexe.register(({[0]=0x17A6EC,0x17A6F5})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Ai
Rexe.register(({[0]=0x17A740,0x17A74C})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Wo
Rexe.register(({[0]=0x17A7A1,0x17A7B0})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Bu
Rexe.register(({[0]=0x17A7F5,0x17A807})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Qu
Rexe.register(({[0]=0x17A866,0x17A87B})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Cl
Rexe.register(({[0]=0x17A8C5,0x17A8DD})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Me
Rexe.register(({[0]=0x1680A8,0x1680A8})[RU.RomMegaman],AC.MayLoseBusterProperty_b,nil,"Achievement") --Boss Fl

Rexe.register(({[0]=0x1FE6E9,0x1FE6F2})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --He
Rexe.register(({[0]=0x1FE738,0x1FE744})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Ai
Rexe.register(({[0]=0x1FE791,0x1FE7A0})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Wo
Rexe.register(({[0]=0x1FE7F7,0x1FE809})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Bu
Rexe.register(({[0]=0x1FE850,0x1FE865})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Qu
Rexe.register(({[0]=0x1FE8C4,0x1FE8DC})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Cl
Rexe.register(({[0]=0x1FE928,0x1FE943})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --Me

Rexe.register(({[0]=0x1EDC3B,0x1EDC3E})[RU.RomMegaman],AC.LoseProperty,"BusterOnly","Achievement") --Fl

Rexe.register(({[0]=0x17A0D5,0x17A0D5})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement")
Rexe.register(({[0]=0x169987,0x169987})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W5
Rexe.register(({[0]=0x169D32,0x169D32})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W6

Rexe.register(({[0]=0x1BA211,0x1BA247})[RU.RomMegaman],AC.MayStart,nil,"Achievement")
Rexe.register(({[0]=0x169D32,0x169D32})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")

