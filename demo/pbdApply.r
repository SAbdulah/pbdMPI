### SHELL> mpiexec -np 2 Rscript --vanilla [...].r

library(pbdMPI, quiet = TRUE)
init()

N <- 100
x <- matrix((1:N) + N * .comm.rank, ncol = 10)
comm.print(x)

y <- pbdApply(x, 1, sum, pbd.mode = "spmd")
comm.print(y)

y <- pbdApply(x, 1, sum)
comm.print(y)

finalize()

