defmodule PROJECT1.Server do
    use GenServer

      #used by server to initialize the 
      def start_link(k, commonString) do
        GenServer.start_link(__MODULE__,%{k: k, pc: 0, commonString: commonString}, name: :CoinServer)
      end
      
      def init(init_data) do
        {:ok,init_data} 
        end
        
      #used by clients to contact the server  
      def getInputString(sname) do
          GenServer.call(sname, {:getInputString})
      end
      
      def printOutputString(sname, outputString ) do
          GenServer.cast(sname, {:printOutputString, outputString})
      end

      def getK(sname) do
        GenServer.call(sname, {:get_k})
      end

      def isALive(sname) do
        GenServer.call(sname,{:isAlive},5000 )
      end


      #callbacks
      
      #async calls
      def handle_cast({:printOutputString, outputString}, my_state) do
        IO.puts outputString
        {:noreply, my_state}
        
      end 
      
      #blocking calls
      def handle_call({:getInputString}, _from, my_state) do
        x = Integer.to_string(Map.get(my_state, :pc),36)
        
        commonString=Map.get(my_state, :commonString)
        {:reply, (commonString <> String.duplicate("0",5-String.length(x)) <> x ), Map.put(my_state, :pc, Map.get(my_state, :pc) + 1)}
      end    

      def handle_call({:get_k}, _from, state) do
        {:reply, Map.get(state, :k), state}
      end

      def handle_call({:isAlive}, _from, state) do
        {:reply, true, state}
      end
end

