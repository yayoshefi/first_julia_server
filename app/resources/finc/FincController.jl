module FincController
# Build something great
using Genie.Renderer.Html
using DataFrames
using fin_stats
#include("../fin_stats.jl")

# for sample_plot function
using Plots
using Dates

# To read the basic sample data from csv
using CSV


export get_fincance
export get_title

struct Stock
  name::String
  symbol::String
  #df::DataFrames.DataFrame   #DataFrame containig all history data of open/close...
end

function get_title()
  println("get title function")
  [
      Html.h1() do
        "Under construction"
      end
      Html.h3() do
        "building the backend..."
      end
  ]
end

function get_finance()
  println("test 1: get finance")
  sample_title_arr = get_title()
  dfs = get_stats(test_symbols)
  # stocks_html_arr = [repr(MIME("text/html"), df) for df in dfs ]
  html(:finc, :stock_simple_info, data_dict=dfs )
end

function get_data_from_py()
  println("test 2: get_data_from_py")
  sample_title_arr = get_title()
  dfs = get_stats(test_symbols)
  @info "got data for $test_symbols"
  stocks_html_arr = [repr(MIME("text/html"), df) for (sym_name, df) in dfs ]# This shows the data in unformatted way
  # append!(sample_title_arr, stocks_html_arr)
end

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
