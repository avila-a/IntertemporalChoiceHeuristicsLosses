source("lib/deps.R")

all.parameters <- data.frame()

for (condition in c(0, 1, 2, 3, 4)) { #I get rid of n� 5
    data <- load.data(condition)

    ITCH.fit <- ITCH.fit.function(data)

    parameters <- as.data.frame(summary(ITCH.fit)$coef)

    parameters <- transform(
        parameters,
        Term=c(
            "Other Factors",
            "Absolute Money",
            "Relative Money",
            "Absolute Time",
            "Relative Time"
        )
    )

    parameters <- transform(
        parameters,
        LowerBound95=Estimate - 2 * Std..Error
    )

    parameters <- transform(
        parameters,
        UpperBound95=Estimate + 2 * Std..Error
    )

    parameters <- cbind(condition, parameters)

    all.parameters <- rbind(
        all.parameters,
        parameters[
            ,
            c("condition", "Term", "Estimate", "LowerBound95", "UpperBound95")
        ]
    )
}

all.parameters <- transform(all.parameters, Condition=factor(condition))

levels(all.parameters$Condition) <- c(
  "Pooled",
  "Delay $, Gain Framing",
  "Speedup $, Gain Framing",
  #    "Standard MEL",
  "Delay $, Loss Framing",
  "Speedup $, Loss Framing"
)

m <- cast(all.parameters, Condition ~ Term, value="Estimate")
m <- as.matrix(m[, 2:6])
d <- cor(t(m))
d
print(t.test(d))
