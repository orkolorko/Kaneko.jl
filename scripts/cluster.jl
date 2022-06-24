# we first rsync the source files

comm = `rsync --cvs-exclude -aP /home/isaia/code/Kaneko/ isaia@albatross:/home/isaia/code/Kaneko/`
run(comm)

mac_mini = ["ptarmigan", "sparrow"]

for mac in mac_mini
    comm = `rsync --cvs-exclude -aP /home/isaia/code/Kaneko/ isaia.nisoli@$mac:/Users/isaia.nisoli/code/Kaneko/`
    run(comm)
end


# we start the "cluster"
using Distributed
loc_proc = addprocs(4; restrict = true)
rem_procs_albatross = addprocs([("isaia@albatross.local", 4)])
rem_proc_mac_mini = addprocs([("isaia.nisoli@sparrow", 4)], dir =  "/Users/isaia.nisoli/code/Kaneko/")

@everywhere import Pkg;
@everywhere Pkg.activate(".")
@everywhere Pkg.instantiate()
@everywhere using Kaneko, DistributedArrays

means = zeros((length(KanekoParam), length(KanekoSizes)))
varias = zeros((length(KanekoParam), length(KanekoSizes)))

@everywhere using Statistics

@everywhere function remote_experiment(a::T, K) where {T}
    @info a, T
    h = experiment(a, rand(T, K).-0.5)
    m = mean(h)
    return mean(h), var(h; mean = m)
end

const jobs = RemoteChannel(()->Channel{Any}(length(KanekoParam)*length(KanekoSizes)));
const results = RemoteChannel(()->Channel{Any}(length(KanekoParam)*length(KanekoSizes)))

# this populates the job list
for (i, a) in enumerate(BigFloat.(KanekoParam))
    for (j, K) in enumerate(KanekoSizes[1:10])
        put!(jobs, (i, j, a, K))
    end
end

#this runs the experiments on the machines, this is done to take advantage
# of the heterogeneous cluster: if someone finishes the job fast, it takes another job
@everywhere function do_work(jobs, results)
    while true
        i, j, a, K = take!(jobs)
        m, v = remote_experiment(a, K)
        put!(results, (i, j, m, v))
    end
end

for p in workers() # start tasks on the workers to process requests in parallel
    remote_do(do_work, p, jobs, results)
end

for _ in 1:length(KanekoParam)*length(KanekoSizes[1:10])
    i, j, m, v = take!(results)
    @info i, j, m, v
    means[i, j] = m
    varias[i, j] = v
end

rmprocs(rem_proc_mac_mini)
rmprocs(rem_procs_albatross)

using Plots
plot(log10.(KanekoSizes[1:10]), varias[:, 1:10]', labels = KanekoParam')

