using Genie.Router
using FincController

route("/") do
  serve_static_file("welcome.html")
end

route("/shefi") do
  "very simple greetings"
end

function my_exp()
  "WTF?! - this is calling loacl function"
end

route("/yair", my_exp)  # calling simple local function

route("/yael", FincController.get_title)  # calling relativly basic remote function (in other module)

route("/static_plot") do  # serving a full html page with staticly created plot
  serve_static_file("static_plot.html")
end

route("/sample_fin", FincController.sample_finance)  #  read CSV and shows as table
route("/sample_plot", FincController.sample_plot_finance ) # read CSV and shows plot

# FIXME
route("/finance", FincController.get_finance)



#=
NOTE:  some usfull functions:
Router.named_routes() - shown each function to what route
Router.routes() - each of the specified routes
=#
