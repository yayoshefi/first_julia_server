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


"""
basic test function to get data out of test_symbols (defined in fin_stats Module)
"""
function get_finance()
  @info  "test 1: get finance"
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

function test_new_finance()
  @debug "lodaing new finance view"
  println("post params: \n", join(["$k : $v\n" for (k,v) in postpayload()]) )
  # search properties
  sym_list = split(postpayload(:state, ""), ",")
  sym_list = sym_list == [""] ? [] : sym_list  # remove list in case the state is empty
  interval_set = postpayload(:day, false)=="on" ? "1d" : postpayload(:week, false)=="on" ? "1wk" : "1mo"
  new_sym_list = Array{String}(vcat(sym_list, postpayload(:new_stock, [])))
  begin_date = postpayload(:start, nothing)
  # FIXME - how to pass a dict through string form    {eval(Meta.parse(sting(dict)))}
  state=Dict(:sym_list => new_sym_list, :interval => interval_set, :begin => begin_date)

  @info "Properties set for get_stats: symbols=$(new_sym_list), interval=$(interval_set), Begin date=$(begin_date) $(typeof(begin_date))"

  dfs_dict = get_stats(new_sym_list, interval=interval_set, start=begin_date)
  pl=plot_stocks(dfs_dict)
  html(:finc, :show_stocks, data_dict=dfs_dict, pl=pl)
end

"""Initial page for setting which stocks to monitor"""
function inital_stock()
  @debug "lodaing inital stock form"
  state=Dict(:sym_list => [], ) #:interval => interval_set, :begin => begin_date)
  html(:finc, :new_stock_form, sym_csv="")
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
