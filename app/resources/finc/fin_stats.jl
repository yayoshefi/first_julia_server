module fin_stats

using PyCall, DataFrames, Plots
using Dates

export get_stats
export plot_stocks
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

interval: valid vlues: 1m,2m,5m,15m,30m,60m,90m,1h,1d,5d,1wk,1mo,3mo
          time periods to meassure the stock rate

start: "YYY-MM-DD"  begin of period
end: "YYY-MM-DD"  begin of period
period: shortcut to describe the period that ends today
        valied values 1d,5d,1mo,3mo,6mo,1y,2y,5y,10y,ytd,max
"""
function get_stats(sym::String; interval::String="1d", period::String="1mo", start::Union{String,Nothing}=nothing)::DataFrame
  yf = pyimport("yfinance")
  tickerData = yf.Ticker(sym)
  if isnothing(start)
    hist = tickerData.history(interval=interval, period=period)
  else
    hist = tickerData.history(interval=interval, start=start)  #Assuming todat for end of period
  end

  colnames = map(Symbol, hist.columns);
  rownames = map(string, hist.index)

  #df = DataFrame(Array[hist[c] for c in colnames[begin:end-1]], colnames[begin:end-1])
  #df = DataFrame(Array[get(hist, c) for c in colnames if !(c in [Symbol("Stock Splits")] )], colnames)  # if c != "Stock Splits", "Volume"
  df = DataFrame(Array[get(hist, c) for c in colnames], colnames)  # if c != "Stock Splits", "Volume"
  # NOTE: in the stackoverflow answer they use Any(Array....) - not sure why

  # Manipulate the Basic DataFrame object
  # ======================================
  df[!, :Date] = collect(rownames) # Add the rownames - Dates
  # Clean all PyObject (numpy) to primitive julia
  @debug "change dividens Type"
  try
    new_dividends = [d.tolist() for d in df[!, :Dividends]]
    df[!, :Dividends] = new_dividends
  catch
    @debug "dividends are in numpy format"
  end
  @debug "change Volume type"
  df[!, :Volume] = [d.tolist() for d in df[!, :Volume]]
  @debug "removing 'stock splits'"
  try
    delete!(df, Symbol("Stock Splits"))  # Remoce unknow column
  catch
  end
  df
end

"""
gets stats of multiple stocks by list of stock symbols
Returns a dict {"sym" -> DataFrame}
"""
function get_stats(sym::Array; interval::String="1d", period::String="1mo", start::Union{String,Nothing}=nothing)
  @debug "get stats called for $sym array"
  dfs = Dict()
  for s in sym
    df = get_stats(s, interval=interval, period=period, start=start)
    dfs[s] = df
  end
  @debug "got all data for $sym"
  return dfs
end

"""
Plot the stock closing price
"""
function plot_stock(df; sym_name::Union{String, Nothing}=nothing)
  my_dates = [DateTime(d) for d in df[!, :Date]]
  plot(my_dates ,df[!, :Close], label=sym_name)
end

"""
Plots multiple plots in 1 Axis
Returns the plot object
"""
function plot_stocks(dfs)
  plotly()
  pl = plot()
  for (sym,df) in dfs
    my_dates = [DateTime(d) for d in df[!, :Date]]
    if sym !== ""
      #@info "plotting for $sym from $(df[begin, :Date]) to $(df[end, :Date])"
      @info "plotting for $sym from $(my_dates[begin]) to $(my_dates[end])"
    end
    plot!(my_dates ,dfs[sym][!, :Close], label=sym)
  end
  plot!()  # Retuns the plots object
end

"""
Plots gets defualt mode data of stocks and plots multiple stock graph on the same axis
Returns thd dictionaty of DataFrame
"""
function stocks_info_and_plot(symbols::Array)
  # set to plotlyjs backend
  #plotlyjs()
  @info "Parsing stocks $symbols"
  plotly()
  dfs = get_stats(symbols)
  pl = plot()  # used to be display(plot())
  for sym in symbols
    my_dates = [DateTime(d) for d in dfs[sym][!, :Date]]
    @debug "plotting for $sym from $(dfs[sym][begin, :Date]) to $(dfs[sym][end, :Date])"
    #display(plot!(dfs[sym][!, :Date] ,dfs[sym][!, :Close]))
    plot!(my_dates ,dfs[sym][!, :Close], label=sym)
  end
  return dfs
end


end  # module fin_stats
