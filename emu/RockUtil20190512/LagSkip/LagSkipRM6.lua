LS.AtNMI = function()
    if memory.readbyte(0x21) == 0x02 then
        LS.Status = 1
    end
end

Rexe.register(0x3EC005,LS.AtNMI,nil,"LagSkip")
