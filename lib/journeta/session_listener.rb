require 'socket'

module Journeta
  
  class SessionListener < Journeta::Asynchronous
    
    def go #(engine)
      begin
        port = engine.configuration[:session_port]
        socket = TCPServer.new(port) 
        putsd "Listening on port #{port}"
        
        begin
          loop do             
            session = socket.accept
            Thread.new do 
              data = ''
              # Read every last bit from the socket before passing off to the handler.
              while more = session.gets
                data += more
              end
#              pp data
              msg     = YAML::load(data)
              h = @engine.session_handler
              h.handle msg              
            end
          end
        rescue
          putsd "Session closed."
        end 
      ensure 
        putsd "Closing event listener socket."
        # session.close
        # socket.close
      end
    end
    
  end
  
end