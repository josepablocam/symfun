##random number generation with weights
rng <- function(n, weights) {
  if(sum(weights) != 1) {
    stop("probabilities do not add to 1")
  }
  sampled <- runif(n)
  .bincode(sampled, breaks=cumsum(c(0,weights)), include.lowest=TRUE)
}

##returns a data frame with the sample distribution, the weights, and the difference
calcdist <- function(sampled, weights) {
  actual <- as.data.frame(table(sampled) / length(sampled))
  names(actual) <- c("id", "sampled_dist")
  theory <- data.frame(id = seq_along(weights), weights = weights)
  dat <- merge(theory, actual, by="id", all.x = T)
  dat$sampled_dist[is.na(dat$sampled_dist)] <- 0
  dat
}

#analyze
analyze <- function(n, weights) {
  sampled <- rng(n, weights)
  calcdist(sampled, weights)
}
  
sizes <- 10 ^ c(1, 2, 3, 4, 5, 6)
set.seed(0)
dice <- (function(x) x / sum(x))(runif(6))
dat <- lapply(sizes, function(x){ dat <- analyze(x, dice); dat$sample_size <- x; dat })
dat <- do.call(rbind, dat)

library(ggplot2)

ggplot(dat, aes(x = factor(sample_size), y = sampled_dist)) + geom_bar(stat="identity") + 
      geom_hline(aes(yintercept = weights, color = "red", linetype = "dashed")) +
      facet_wrap( ~id) + theme(axis.text.x = element_text(angle = 90)) + 
      labs(title = "RNG Comparison", x = "Sample Size", y = "Frequency Distribution")

