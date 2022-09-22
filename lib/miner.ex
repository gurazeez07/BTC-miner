defmodule PROJECT1.Miner do
    #Code for implementing hashcash algorithm and mining bitcoins
    def minecoins(sname, count, inputstring, string2, val) do 
        countStr = Integer.to_string(count,36)
        shaString = String.downcase(:crypto.hash(:sha256, inputstring <> countStr) |> Base.encode16)
        if String.starts_with?(shaString, string2) do
          #output = ((Integer.to_string val) <> "   " <> inputstring <> countStr <> "\t" <> shaString)
          output = (inputstring <> countStr <> "\t" <> shaString)
          PROJECT1.Server.printOutputString(sname, output)
        end
        minecoins(sname,  count+1, inputstring, string2, val)
    end
end
