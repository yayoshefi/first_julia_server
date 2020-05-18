using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests
#using Genie.Router
using FincController
using yair_devController


route("/") do
  serve_static_file("welcome.html")
end

route("/static_plot") do  # serving a full html page with staticly created plot
  serve_static_file("static_plot.html")
end

# TODO: implement these two versions with @params and use of GET params
route("/sample_fin", FincController.sample_finance)        #  read CSV and shows as table
route("/sample_plot", FincController.sample_plot_finance ) # read CSV and shows plot

route("/test_pycall", FincController.test_pycall)
route("/finance", FincController.get_finance)

# ==============================
# Development section
#   POST testing
# ==============================
route("/dev1", yair_devController.in_form)
route("/dev1", yair_devController.out_form, method=POST)
# ==============================
# END OF Development section
# ==============================

route("/test_new_finance", FincController.test_new_finance, method=POST)
route("/test_inital_stock", FincController.inital_stock)



#=
NOTE:  some usfull functions:
Router.named_routes() - shown each function to what route
Router.routes() - each of the specified routes
# To reload all sub-Modules
Revise.revise(MyTestFin)
=#
