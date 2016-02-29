library(BatchJobs)

reg = makeRegistry(id="bj_demo")

# functions with lots of errors
faulty <- function(n) {
  if (n == 1) {
    1
  } else if (n == 2) {
    # bug that raises exception
   stop("I don't like 2s!")
  } else if (n == 3) {
    # infinite loop, example of a job we have to kill before fixing
    while(TRUE) {}
  } else {
    4
  }
}

batchMap(reg, faulty, 1:4)

# test jobs before you submit them
x = testJob(reg, 1)
testJob(reg, 2)

submitJobs(reg)

# check computational status of jobs
# (runnind, done, error)
showStatus(reg)

# wait for jobs to terminate
waitForJobs(reg)

# if unwanted jobs are running we can kill them
id = findRunning(reg)
getJob(reg, id)
killJobs(reg, id)

showStatus(reg)

showLog(reg, findErrors(reg)[1], pager = "less")

reduceResultsList(reg, findDone(reg))
