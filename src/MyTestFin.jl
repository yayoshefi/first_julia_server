module MyTestFin

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = MyTestFin))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = MyTestFin.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
