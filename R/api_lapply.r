### These functions are supposed to run in SPMD, even when pbd.mode = "mw"

list.to.list <- function(i, X){
  X[i]
} # End of list.to.list().

pbdLapply <- function(X, FUN, ..., pbd.mode = c("mw", "spmd"),
    rank.source = .SPMD.CT$rank.root, comm = .SPMD.CT$comm){
  COMM.SIZE <- spmd.comm.size(comm)
  COMM.RANK <- spmd.comm.rank(comm)

  ### Redistributing data for MW.
  if(pbd.mode[1] == "mw"){
    new.X <- NULL 
    if(COMM.RANK == rank.source){
      if(! is.vector(X) || is.object(X)){
        X <- as.list(X)
      }

      alljid <- get.jid(length(X), comm = comm, all = TRUE)
      new.X <- lapply(alljid, list.to.list, X) 
    }

    if(length(new.X) < COMM.SIZE){
      new.X <- c(new.X, rep(list(NULL), COMM.SIZE - length(new.X)))
    }

    X <- spmd.scatter.object(new.X, rank.source = rank.source, comm = comm)
  }

  ### Run as SPMD.
  ret <- lapply(X, FUN, ...)

  ### Gather data for MW.
  if(pbd.mode[1] == "mw"){
    ret <- spmd.gather.object(ret, rank.dest = rank.source, comm = comm)
    if(COMM.RANK != rank.source){
      ret <- NULL
    }
  }

  ret
} # End of pbdLapply().

