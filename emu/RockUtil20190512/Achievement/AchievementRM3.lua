
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
            AC.NewSection("Ne","Needle Man","Needle"),
            AC.NewSection("Ma","Magnet Man","Magnet"),
            AC.NewSection("Ge","Gemini Man","Gemini"),
            AC.NewSection("Ha","Hard Man","Hard"),
            AC.NewSection("To","Top Man","Top"),
            AC.NewSection("Sn","Snake Man","Snake"),
            AC.NewSection("Sp","Spark Man","Spark"),
            AC.NewSection("Sh","Shadow Man","Shadow"),
            AC.NewSection("Ne2","Needle Man2","A.Needle"),
            AC.NewSection("Ge2","Gemini Man2","A.Gemini"),
            AC.NewSection("Sp2","Spark Man2","A.Spark"),
            AC.NewSection("Sh2","Shadow Man2","A.Shadow"),
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
            AC.NewSection("Ne","Needle Man","Needle"),
            AC.NewSection("Ma","Magnet Man","Magnet"),
            AC.NewSection("Ge","Gemini Man","Gemini"),
            AC.NewSection("Ha","Hard Man","Hard"),
            AC.NewSection("To","Top Man","Top"),
            AC.NewSection("Sn","Snake Man","Snake"),
            AC.NewSection("Sp","Spark Man","Spark"),
            AC.NewSection("Sh","Shadow Man","Shadow"),
            AC.NewSection("DF","Doc Robot(Flash)","Doc(F)"),
            AC.NewSection("DB","Doc Robot(Bubble)","Doc(B)"),
            AC.NewSection("DQ","Doc Robot(Quick)","Doc(Q)"),
            AC.NewSection("DW","Doc Robot(Wood)","Doc(W)"),
            AC.NewSection("DC","Doc Robot(Clash)","Doc(C)"),
            AC.NewSection("DA","Doc Robot(Air)","Doc(A)"),
            AC.NewSection("DM","Doc Robot(Metal)","Doc(M)"),
            AC.NewSection("DH","Doc Robot(Heat)","Doc(H)"),
            AC.NewSection("Br","Break Man","Break"),
            AC.NewSection("W1","Kamegoro Maker","KMaker"),
            AC.NewSection("W2","Yellow Devil MK-II","YDevil2"),
            AC.NewSection("W3","Holograph Rockmans","HoloR"),
            AC.NewSection("W5","Wily Machine 3","Machine"),
            AC.NewSection("W6","Gamma","Gamma"),
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
            AC.NewSection("Ne","Needle Man","Needle"),
            AC.NewSection("Ma","Magnet Man","Magnet"),
            AC.NewSection("Ge","Gemini Man","Gemini"),
            AC.NewSection("Ha","Hard Man","Hard"),
            AC.NewSection("To","Top Man","Top"),
            AC.NewSection("Sn","Snake Man","Snake"),
            AC.NewSection("Sp","Spark Man","Spark"),
            AC.NewSection("Sh","Shadow Man","Shadow"),
            AC.NewSection("Ne2","Needle Man2","A.Needle"),
            AC.NewSection("Ge2","Gemini Man2","A.Gemini"),
            AC.NewSection("Sp2","Spark Man2","A.Spark"),
            AC.NewSection("Sh2","Shadow Man2","A.Shadow"),
            AC.NewSection("W1","Wily #1","W1"),
            AC.NewSection("W2","Wily #2","W2"),
            AC.NewSection("W3","Wily #3","W3"),
            AC.NewSection("W4","Wily #4","W4"),
            AC.NewSection("W5","Wily #5","W5"),
            AC.NewSection("W6","Wily #6","W6"),
        },
   },
}


AC.ActivateCategory_Level = function()
    local level = memory.readbyte(0x22)
    AC.ActivateCategory(2,level+1)
    AC.ActivateCategory(4,level+1)
    AC.InactivateCategory(3)
end
AC.ActivateCategory_Boss = function(n)

    if n < 0 then
        local x = memory.getregister("x")
        local type = memory.readbyte(0x320+x)
        n = n + type
    end
    AC.ActivateCategory(3,n)

    local level = memory.readbyte(0x22)
    local screen = memory.readbyte(0xF9)
    local threshold = rom.readbyte(0x10+({[0]=0x1A87,0x1A8F})[RU.RomMegaman]+0x2000*0x1E)
    if level<8 or level>=0xC or screen >= threshold then
        AC.AchieveCategory(2)
    else
        AC.SleepCategory(2)
    end
end

AC.MayLoseBusterProperty = function(n)
    --ラッシュ3種は許容
    --ラッシュバスターバグで他の武器の攻撃力を利用するのは禁止
    local weapon = memory.readbyte(0xA0)
    if weapon == 0x0 or weapon == 0x7 or weapon == 0x9 or weapon == 0xB then
        --特になし
    else
        local x = memory.getregister("x")
        local type = memory.readbyte(0x320+x)
        local dmg = rom.readbyte(0x0110+0x2000*0xA+type)
        if dmg ~= 0 then
            AC.LoseProperty({"BusterOnly"})
        end
    end
end

Rexe.register(({[0]=0x1EC8FF,0x1EC8FF})[RU.RomMegaman],AC.ActivateCategory_Level,nil,"Achievement")
Rexe.register(({[0]=0x1EDB9A,0x1EDBA2})[RU.RomMegaman],AC.WakeCategory,2,"Achievement")
Rexe.register(({[0]=0x1EC9B3,0x1EC9B3})[RU.RomMegaman],AC.WakeCategory,2,"Achievement")

Rexe.register(({[0]=0x1DB811,0x1DB853})[RU.RomMegaman],AC.ActivateCategory_Boss,-0x58+1,"Achievement")
Rexe.register(({[0]=0x1DB6A6,0x1DB6E8})[RU.RomMegaman],AC.ActivateCategory_Boss,-0x90+9,"Achievement")
Rexe.register(({[0]=0x1DA264,0x1DA286})[RU.RomMegaman],AC.ActivateCategory_Boss,17,"Achievement")
Rexe.register(({[0]=0x12B67C,0x12B67F})[RU.RomMegaman],AC.ActivateCategory_Boss,18,"Achievement")
Rexe.register(({[0]=0x12A07F,0x12A07F})[RU.RomMegaman],AC.ActivateCategory_Boss,19,"Achievement")
Rexe.register(({[0]=0x12BC93,0x12BC96})[RU.RomMegaman],AC.ActivateCategory_Boss,20,"Achievement")
Rexe.register(({[0]=0x12A7E7,0x12A7E7})[RU.RomMegaman],AC.ActivateCategory_Boss,21,"Achievement")
Rexe.register(({[0]=0x12ADFC,0x12ADFC})[RU.RomMegaman],AC.ActivateCategory_Boss,22,"Achievement")

Rexe.register(({[0]=0x1C82AA,0x1C82B8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement")
Rexe.register(({[0]=0x1DA1B6,0x1DA1D8})[RU.RomMegaman],AC.AchieveCategory,3,"Achievement") --Break

Rexe.register(({[0]=0x02A067,0x02A067})[RU.RomMegaman],AC.LoseProperty,"NoETank","Achievement")
Rexe.register(({[0]=0x1ED781,0x1ED789})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")
Rexe.register(({[0]=0x1FF0CD,0x1FF0D5})[RU.RomMegaman],AC.LoseProperty,{"NoMiss","NoDamage"},"Achievement")

Rexe.register(({[0]=0x1ECBB1,0x1ECBB1})[RU.RomMegaman],AC.LoseProperty,"NoContinue","Achievement")
Rexe.register(({[0]=0x1C80DA,0x1C80DA})[RU.RomMegaman],AC.LoseProperty,"NoDamage","Achievement")

Rexe.register(({[0]=0x1C817E,0x1C817E})[RU.RomMegaman],AC.LoseProperty,{"BusterOnly"},"Achievement") --Spark
Rexe.register(({[0]=0x1C81C7,0x1C81C7})[RU.RomMegaman],AC.MayLoseBusterProperty,nil,"Achievement") --common

Rexe.register(({[0]=0x1EDC49,0x1EDC51})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --warp out
Rexe.register(({[0]=0x1EDDB2,0x1EDDBA})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W4
Rexe.register(({[0]=0x12B153,0x12B153})[RU.RomMegaman],AC.AchieveCategory,4,"Achievement") --W6

Rexe.register(({[0]=0x1890A0,0x1890D0})[RU.RomMegaman],AC.ActivateCategory,1,"Achievement")
Rexe.register(({[0]=0x12B153,0x12B153})[RU.RomMegaman],AC.AchieveCategory,1,"Achievement")
