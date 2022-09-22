defmodule PROJECT1 do
  @moduledoc """
  Documentation for PROJECT1.
  """
  def main(args) do
    
    input_arguements = (List.to_string(args))
    numberOfMiningThreadsPerCore=25
    localIP=findIP() #change with getting localIP address for different operating systems

    if String.contains?(input_arguements,".") do
      #IO.puts("This is a slave machine, it should contact the server and only do mining, it will spawn only mining actors")
      serverIP = input_arguements
      
      #get random connection atom to spawn this node
      #Elixir Node connection code
      Node.start(PROJECT1.ConnectionAtomGenerator.get_connection_atom(localIP))
      Node.set_cookie(:"DesiBitcoinFarm")
      
      #Genserver create/call code
      try do
      serveratom=String.to_atom("Server"<>"@"<>serverIP)
      Node.connect(serveratom)
      sname = {:CoinServer, serveratom}
      k = PROJECT1.Server.getK(sname)
      string2 = String.duplicate("0",k)
      spawnXminingThreads(sname, 0,  :erlang.system_info(:logical_processors_available)*numberOfMiningThreadsPerCore,  string2, 1)
      catch
        :exit,_ -> IO.puts("Server thread not active at the given IP")
      end
    else
      #IO.puts("This IS a SERVER machine, it will spawn atleast 3 actors, for mining, generating input string and printing output on the terminal")
      inputstring = "pbrahme;"
      serverIP=localIP
      serveratom=String.to_atom("Server"<>"@"<>serverIP)
      Node.start(serveratom)
      Node.set_cookie(:"DesiBitcoinFarm")
      k = String.to_integer(input_arguements)
      string2 = String.duplicate("0",k)
      PROJECT1.Server.start_link(k,inputstring)
      sname = {:CoinServer, serveratom}
      spawnXminingThreads(sname, 0,:erlang.system_info(:logical_processors_available)*numberOfMiningThreadsPerCore,  string2, 0)
    end
  end

  def spawnXminingThreads(sname, count, intx,  string2, val) when count < intx do
    spawn(PROJECT1.Miner,:minecoins, [sname, 0, PROJECT1.Server.getInputString(sname), string2, val])
    spawnXminingThreads(sname, count+1,intx,  string2, val)
  end

  def spawnXminingThreads(sname, count, intx,  string2, val) when count >= intx do
    #Start unlimited loop so that the program doesnot close after spawning required actors and models
    unlimitedLoop(sname)
  end

  #This function returns the local IP address for different operating systems. DOESNOT work on CISE THUNDER or CISE STORM
  def findIP do
    {ops_sys, versionof } = :os.type
    ip = 
    case ops_sys do
     :unix -> 
      case versionof do
        :darwin -> {:ok, [addr: ip]} = :inet.ifget('en0', [:addr])
        to_string(:inet.ntoa(ip)) 
        :linux ->  {:ok, [addr: ip]} = :inet.ifget('wlp1s0', [:addr])
        to_string(:inet.ntoa(ip))
      end    
      :win32 -> {:ok, ip} = :inet.getiflist
      to_string(hd(ip))
    end
    (ip)
  end

  #This function prevents the program from ending unless it is killed externally
  def unlimitedLoop(sname) do
    try do
    #PROJECT1.Server.isALive(sname)
    unlimitedLoop(sname)
    catch
      :exit, _ -> IO.puts("Server has ended its process")
    end
  end
  
end
