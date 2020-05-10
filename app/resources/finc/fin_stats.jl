module fin_stats

using PyCall, DataFrames, Plots
using Dates
yf = pyimport("yfinance")

export get_stats
export test_symbols


test_symbols = ["MSFT", "CSCO"]  # used for debuggin purpose
"""
gets the stats of single stock by String of the stock symbol
"""
function get_stats(sym::String)::DataFrame
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
UNDER CONSTRUCTION
"""
function plot_stock(df)
  plot(df[!, :Date] ,df[!, :Close])
  #using Dates
  #my_dates = [DateTime(d) for d in df[!, :Date]]
end

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
