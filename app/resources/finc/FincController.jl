module FincController
# Build something great
using Genie.Renderer.Html,  Genie.Requests
using DataFrames
using fin_stats
#include("../fin_stats.jl")

# for sample_plot function
using Plots
using Dates

# To read the basic sample data from csv
using CSV

export get_fincance

struct Stock
  name::String
  symbol::String
  #df::DataFrames.DataFrame   #DataFrame containig all history data of open/close...
end


macro log_fmt(msg)
  return "Module $(@__MODULE__): in $(@__FILE__)+$(@__LINE__):: $msg"
end

"""
basic test function to get data out of test_symbols (defined in fin_stats Module)
"""
function get_finance()
  @info @log_fmt "test 1: get finance"
  dfs = get_stats(test_symbols)
  #=
  plots_dict = Dict(sym => fin_stats.plot_stock(df) for (sym,df) in dfs)

  # stocks_html_arr = [repr(MIME("text/html"), df) for df in dfs ]
  debug_msg = "df keys: $(dfs.keys) shapes = $(dfs)"
  html(:finc, :stock_simple_info, data_dict=plots_dict )
  =#
  pl = plot_stocks(dfs)
  html(:finc, :dataframe, symbol_name=join(test_symbols, " "), data=pl)
end

"""
collect new stock by symbol given from POST payload
"""
function show_single_stock()
  sym = postpayload(:stock_sym, "CSCO")
  println("showing stock prices for $sym;  payload= $(postpayload())")
  #getpayload(:interval, "1d")
  df = get_stats(sym)
  pl = fin_stats.plot_stock(df)
  @info "showing stock prices for $sym payload=$(postpayload())"
  html(:finc, :dataframe, symbol_name=sym, data=pl)
end
"""
Select some stock by name
"""
function choose_stock_form()
  form = """
  <form action="/test_new_stock" method="POST" enctype="multipart/form-data">
    <input type="text" name="stock_sym" value="" placeholder="select stock symbol" />
    <input type="submit" value="Continue" />
  </form>
  """
  @info @log_fmt "servnig NO specifing version", payload=postpayload
  html(form)
end


"""
Returns some inner properties of the fin_stats module and it's PyCall usage
"""
function test_pycall()
  println("test 3: test pycall (tag)")
  msg = fin_stats.version_ext()
  html(msg)
end

# ==========================================================================
# utility function to use with some static data saved as csv
# ==========================================================================
"""
Read the csv
"""
function get_sample_data()
  CSV.read("public/finc/sample_data_df.csv")
end
# TODO try and implement these two function with param
"""
plot a graph to the browser using a static dataframe (csv format)
this is used for test/debug in order to create the framework for the first time
"""
function sample_finance()
  @info "sample_finance called"
  println("sample_finance() called to show stock df to the browser")
  df = get_sample_data()
  #html(df)   # found in Genie.Render.Html
  # html(Base.show(stdout, MIME"text/html"(), df) ) # spits out the df in html format

  html(:finc, :dataframe, symbol_name="CSCO", data=df)
  # (resource_name, vies_name, argumerts)
  # https://genieframework.github.io/Genie.jl/guides/Working_With_Genie_Apps.html
end

function sample_plot_finance()
  @info "sample_plot_finance called"
  println("sample_plot_finance() called to plot static stock to the browser")
  df = get_sample_data()
  # Plot
  plotly()
  my_dates = [DateTime(d) for d in df[!, :Date]]
  my_plot = plot(my_dates ,df[!, :Close])  # try fmt = :html
  html(:finc, :dataframe, symbol_name="CSCO", data=my_plot)
end

end # module FincController
