function sma{T,N}(ta::TimeArray{T,N}, n::Int)
    vals    = zeros(length(ta))
    cname   = ["sma$n"]
    for i in n:length(ta)
        vals[i] = mean(ta.values[i-(n-1):i])
    end  
    TimeArray(ta.timestamp, vals, cname) 
end

function ema{T,N}(ta::TimeArray{T,N}, n::Int; wilder=false)

  if  wilder 
    k  = 1/n 
  else
    k = 2/(n+1)
  end

  tstamps = ta.timestamp[n:end]
  vals    = ones(length(ta))
  vals[n] = sma(ta, n).values[1] # seed with first value an sma value
  for i = n+1:length(ta)
    vals[i] =  ta.values[i] * k + vals[i-1] * (1-k)
  end
  cname   = ["ema$n"]
  TimeArray(tstamps, vals[n:length(ta)], cname)
end

# Array dispatch for use by ta algorithms

function sma(a::Array{Float64,1}, n::Int)
    vals    = zeros(length(a))
    for i in n:length(a)
        vals[i] =  mean(a[i-(n-1):i])
    end
    vals
end

function ema(a::Array{Float64,1}, n::Int; wilder=false)

  if  wilder 
    k  = 1/n 
  else
    k = 2/(n+1)
  end

  vals    = ones(length(a))
  vals[n] = sma(a, n)[1] # seed with first value an sma value
 
  for i = n+1:length(a)
    vals[i] =  a[i] * k + vals[i-1] * (1-k)
  end
  vals[n:end]
end
