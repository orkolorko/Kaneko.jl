using Kaneko

means = zeros((length(KanekoParam), length(KanekoSizes)))
varias = zeros((length(KanekoParam), length(KanekoSizes)))

using Statistics

@info Threads.nthreads()

@time Threads.@threads for a in KanekoParam
    i = Threads.threadid()
    for (j, K) in enumerate(KanekoSizes)
        h = experiment(a, rand(K).-0.5)
        means[i, j] = mean(h)
        varias[i, j] = var(h; mean = means[i,j])
    end
end

using Plots
plot(log10.(KanekoSizes), varias', labels = KanekoParam')