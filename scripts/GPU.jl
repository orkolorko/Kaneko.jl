using Kaneko

means = zeros((length(KanekoParam), length(KanekoSizes)))
stddeviations = zeros((length(KanekoParam), length(KanekoSizes)))

using Statistics

using CUDA

function experiment_gpu(a, K; T = Float64, ϵ = 0.1, Ntrans = 10^4, Norbit = 10^5)
    x0 = CUDA.rand(T, K)
    x = f.(a, x0)
    y = CUDA.zeros(T, K)

    for _ in 1:Ntrans
        y .= f.(a, x)
        val = reduce(+, y)/K
        x .= (1-ϵ)*y .+ (ϵ*val)
    end 

    h = zeros(T, Norbit)

    for i in 1:Norbit
        y .= f.(a, x)
        val = reduce(+, y)/K

        h[i] = val
        x .= (1-ϵ)*y .+ (ϵ*val)
    end 

    return h
end

@time for (i, a) in enumerate(KanekoParam)
    for (j, K) in enumerate(KanekoSizes)
        h = experiment(a, CUDA.rand(K).-0.5)
        means[i, j] = mean(h)
        stddeviations[i, j] = stdm(h, means[i,j])
    end
end

using Plots
plot(log.(KanekoSizes), stddeviations')