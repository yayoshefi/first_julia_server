using Genie.Router
using FincController

route("/") do
  serve_static_file("welcome.html")
end

function my_exp()
  "WTF?! - this is calling loacl function"
end

route("/yair", my_exp)  # calling simple local function

route("/test_pycall", FincController.test_pycall)

route("/static_plot") do  # serving a full html page with staticly created plot
  serve_static_file("static_plot.html")
end

# TODO: implement these two versions with @params and use of GET params
route("/sample_fin", FincController.sample_finance)  #  read CSV and shows as table
route("/sample_plot", FincController.sample_plot_finance ) # read CSV and shows plot

# FIXME
route("/finance", FincController.get_finance)

route("/test_data_from_py", FincController.get_data_from_py)


#=
NOTE:  some usfull functions:
Router.named_routes() - shown each function to what route
Router.routes() - each of the specified routes
=#
