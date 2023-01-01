use Mix.Config

config :xmavlink, dialect: APM, connections: [
                                 "tcpout:127.0.0.1:5760",
                                 "serial:/dev/cu.usbmodem401101:115200",
                                 "udpout:127.0.0.1:14550"]
