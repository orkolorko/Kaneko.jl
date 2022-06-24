using Kaneko

means = zeros((length(KanekoParam), length(KanekoSizes)))
stddeviations = zeros((length(KanekoParam), length(KanekoSizes)))

using Statistics

@time for (i, a) in enumerate(KanekoParam)
    for (j, K) in enumerate(KanekoSizes)
        h = experiment(a, rand(K).-0.5)
        means[i, j] = mean(h)
        stddeviations[i, j] = stdm(h, means[i,j])
    end
end

using Plots
plot(log10.(KanekoSizes), stddeviations', labels = KanekoParam')