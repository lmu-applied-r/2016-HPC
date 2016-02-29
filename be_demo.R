library(BatchExperiments)
library(mlr)
library(mlbench)
data(Sonar)

# demo: run some machine learning algos on some data

# create experiment registry
unlink("be_demo-files", recursive = TRUE)
reg = makeExperimentRegistry("be_demo", packages = "mlr")

# problems = data sets
addProblem(reg, id = "iris", static = list(task = 
  makeClassifTask(data = iris, target = "Species")))
addProblem(reg, id = "sonar", static = list(task = 
  makeClassifTask(data = Sonar, target = "Class")))


# algo code = crossval a learner. 
# learner is a arg, so we can formulate a design of options to try
addAlgorithm(reg, "cv_learner", 
  fun = function(static, learner) {
    r = crossval(learner = learner, task = static$task, iters = 3)
    r$aggr["mmce.test.mean"]
})


learners = c("classif.rpart", "classif.lda")

# add the experiments
addExperiments(reg, 
  algo.designs = makeDesign("cv_learner", 
    exhaustive = list(learner = learners)),
  repls = 2
)

submitJobs(reg)
waitForJobs(reg)
res = reduceResultsExperiments(reg)
print(res)

