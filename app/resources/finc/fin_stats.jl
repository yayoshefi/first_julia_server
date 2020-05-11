module fin_stats

using PyCall, DataFrames, Plots
using Dates

export get_stats
export test_symbols
export version_ext


test_symbols = ["MSFT", "CSCO"]  # used for debuggin purpose

"""
Shows info about the version of python working with PyCall
"""
function version_ext()
  global yf
  yf_temp = pyimport("yfinance")
  v_str = PyCall.python
  lib_str = PyCall.libpython

  yf_str = string(yf_temp)
  yf_str = replace(yf_str, "<" => "&lt")
  yf_str = replace(yf_str, ">" => "&gt")

  msg = "python path: $v_str lib path : $lib_str      yf (temp local var): $yf_str"
  @info msg
  return msg
end

"""
gets the stats of single stock by String of the stock symbol
Returns a DataFrame of all stats
"""
function get_stats(sym::String)::DataFrame
  yf = pyimport("yfinance")
  tickerData = yf.Ticker(sym)
  hist = tickerData.history()

  #@info "hist info = $(tickerData.info)"
  colnames = map(Symbol, hist.columns);
  rownames = map(string, hist.index)

  #df = DataFrame(Array[hist[c] for c in colnames[begin:end-1]], colnames[begin:end-1])
  df = DataFrame(Array[get(hist, c) for c in colnames], colnames)
  # NOTE: in the stackoverflow answer they use Any(Array....) - not sure why
  # Add the rownames - Dates
  df[!, :Date] = collect(rownames)
  df
end

"""
gets stats of multiple stocks by list of stock symbols
Returns a dict {"sym" -> DataFrame}
"""
function get_stats(sym::Array)
  @info "get stats called for $sym array"
  dfs = Dict()
  for s in sym
    df = get_stats(s)
    dfs[s] = df
  end
  @info "got all data for $sym"
  return dfs
end

"""
Plot the stock closing price
"""
function plot_stock(df)
  my_dates = [DateTime(d) for d in df[!, :Date]]
  plot(my_dates ,df[!, :Close])
end


"""
FIXME:
Plots multiple stock graph on the same axis
"""
function stocks_info_and_plot(symbols::Array)
  # set to plotlyjs backend
  #plotlyjs()
  @info "Parsing stocks $symbols"
  plotly()
  dfs = get_stats(symbols)
  display(plot())
  for sym in symbols
    my_dates = [DateTime(d) for d in dfs[sym][!, :Date]]
    @debug "plotting for $sym from $(dfs[sym][begin, :Date]) to $(dfs[sym][end, :Date])"
    #display(plot!(dfs[sym][!, :Date] ,dfs[sym][!, :Close]))
    display(plot!(my_dates ,dfs[sym][!, :Close]))
  end
  return dfs
end


end  # module fin_stats
