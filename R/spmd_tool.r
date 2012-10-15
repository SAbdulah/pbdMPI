### Tool functions.

spmd.hostinfo <- function(comm = .SPMD.CT$comm){
  if(spmd.comm.size(comm) == 0){
    stop(paste("It seems no members running on comm", comm))
  }
  HOST.NAME <- spmd.get.processor.name()
  COMM.RANK <- spmd.comm.rank(comm)
  COMM.SIZE <- spmd.comm.size(comm)
  cat("\tHost:", HOST.NAME, "\tRank(ID):", COMM.RANK, "\tof Size:", COMM.SIZE,
      "on comm", comm, "\n")
  invisible()
} # End of spmd.hostinfo().

comm.hostinfo <- spmd.hostinfo

spmd.comm.print <- function(x, all.rank = .SPMD.CT$print.all.rank,
    rank.print = .SPMD.CT$rank.source, comm = .SPMD.CT$comm,
    quiet = FALSE, flush = TRUE, con = stdout(), ...){
  COMM.RANK <- spmd.comm.rank(comm)

  spmd.barrier(comm)
  if(all.rank){
    for(i.rank in 0:(spmd.comm.size(comm) - 1)){
      spmd.barrier(comm)
      if(i.rank == COMM.RANK){
        if(! quiet){
          cat("COMM.RANK = ", COMM.RANK, "\n", sep = "")
          if(flush){
            flush(con)
          }
        }
        print(x, ...)
        if(flush){
          flush(con)
        }
      }
      spmd.barrier(comm)
    }
  } else{
    for(i.rank in rank.print){
      spmd.barrier(comm)
      if(i.rank == COMM.RANK){
        if(! quiet){
          cat("COMM.RANK = ", COMM.RANK, "\n", sep = "")
          if(flush){
            flush(con)
          }
        }
        print(x, ...)
        if(flush){
          flush(con)
        }
      }
      spmd.barrier(comm)
    }
  }
  spmd.barrier(comm)

  invisible()
} # End of spmd.comm.print().

comm.print <- spmd.comm.print

spmd.comm.cat <- function(..., all.rank = .SPMD.CT$print.all.rank,
    rank.print = .SPMD.CT$rank.source, comm = .SPMD.CT$comm, quiet = FALSE,
    sep = " ", fill = FALSE, labels = NULL, append = FALSE,
    flush = TRUE, con = stdout()){
  COMM.RANK <- spmd.comm.rank(comm)

  spmd.barrier(comm)
  if(all.rank){
    for(i.rank in 0:(spmd.comm.size(comm) - 1)){
      spmd.barrier(comm)
      if(i.rank == COMM.RANK){
        if(! quiet){
          cat("COMM.RANK = ", COMM.RANK, "\n", sep = "")
          if(flush){
            flush(con)
          }
        }
        cat(..., sep = sep, fill = fill, labels = labels, append = append)
        if(flush){
          flush(con)
        }
      }
      spmd.barrier(comm)
    }
  } else{
    for(i.rank in rank.print){
      spmd.barrier(comm)
      if(i.rank == COMM.RANK){
        if(! quiet){
          cat("COMM.RANK = ", COMM.RANK, "\n", sep = "")
          if(flush){
            flush(con)
          }
        }
        cat(..., sep = sep, fill = fill, labels = labels, append = append)
        if(flush){
          flush(con)
        }
      }
      spmd.barrier(comm)
    }
  }
  spmd.barrier(comm)

  invisible()
} # End of spmd.comm.cat().

comm.cat <- spmd.comm.cat

