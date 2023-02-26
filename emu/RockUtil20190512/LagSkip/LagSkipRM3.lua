LS.AtNMI = function()
    if memory.readbyte(0x80) == 0x02 then
        LS.Status = 1
    end
end

Rexe.register(0x1EC006,LS.AtNMI,nil,"LagSkip")
