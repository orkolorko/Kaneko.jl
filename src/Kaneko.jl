module Kaneko

export T, f, experiment, experiment2, KanekoParam, KanekoSizes

T(a, x) = a*x*(1-x)

f(a, x) = 1-a*x^2

KanekoParam = [1.75; 1.77; 1.80; 1.83; 1.85; 1.87; 1.90; 1.92; 1.95; 1.97; 1.99; 2.00]
KanekoSizes = [collect(10:10:90); collect(100:100:900); 1000; 5000; 10000 ]

experiment(a::T, K::Int) where {T} = experiment(a, rand(T, K).-0.5)

function experiment(a::T, x0; ϵ = 0.1, Ntrans = 10^4, Norbit = 10^5) where {T}
    x = f.(a, x0)
    N = length(x0)
    y = zeros(T, N)
    
    val = 0.0
    for _ in 1:Ntrans
        y .= f.(a, x)
        val = reduce(+, y)/N
        x .= (1-ϵ)*y .+ ϵ*val
    end 
    h = zeros(T, Norbit)
    for i in 1:Norbit
        y = f.(a, x)
        val = reduce(+, y)/N
        h[i] = val
        x = (1-ϵ)*y .+ ϵ*val
    end
    return h
end

experiment2(a::T, K::Int) where {T} = experiment2(a, rand(T, K).-0.5)
function experiment2(a::T, x0; ϵ = 0.1, Ntrans = 10^4, Norbit = 10^5) where {T}
    x = f.(a, x0)
    N = length(x0)
    
    val = 0.0
    for _ in 1:Ntrans
        x .= f.(a, x)
        val = reduce(+, x)/N
        x .= (1-ϵ)*x .+ ϵ*val
    end 
    h = zeros(T, Norbit)
    for i in 1:Norbit
        x = f.(a, x)
        val = reduce(+, x)/N
        h[i] = val
        x = (1-ϵ)*x .+ ϵ*val
    end
    return h
end


end
