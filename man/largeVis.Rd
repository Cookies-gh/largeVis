% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/largeVis-package.r, R/largeVis.R
\docType{package}
\name{largeVis}
\alias{largeVis}
\alias{largeVis-package}
\title{largeVis: high-quality visualizations for large, high-dimensionality datasets}
\usage{
largeVis(x, dim = 2, K = 40, n_trees = 50, tree_threshold = max(10,
  ncol(x)), max_iter = 1, distance_method = "Euclidean", perplexity = 50,
  sgd_batches = NULL, M = 5, alpha = 1, gamma = 7, rho = 1,
  coords = NULL, save_neighbors = TRUE, verbose = TRUE, ...)
}
\arguments{
\item{x}{A matrix, where the features are rows and the examples are columns.}

\item{dim}{The number of dimensions in the output}

\item{K}{The number of nearest-neighbors to use in computing the kNN graph}

\item{n_trees}{See \code{\link{randomProjectionTreeSearch}}.  The default is set at 50, which is the number
used in the examples in the original paper.}

\item{tree_threshold}{See \code{\link{randomProjectionTreeSearch}}.  By default, this is the number of features
in the input set.}

\item{max_iter}{See \code{\link{randomProjectionTreeSearch}}.}

\item{distance_method}{One of "Euclidean" or "Cosine."  See \code{\link{randomProjectionTreeSearch}}.}

\item{perplexity}{See \code{\link{buildWijMatrix}}.}

\item{sgd_batches}{See \code{\link{projectKNNs}}.}

\item{M}{See \code{\link{projectKNNs}}.}

\item{alpha}{See \code{\link{projectKNNs}}.}

\item{gamma}{See \code{\link{projectKNNs}}.}

\item{rho}{See \code{\link{projectKNNs}}.}

\item{coords}{A [N,K] matrix of coordinates to use as a starting point -- useful for refining an embedding in stages.}

\item{save_neighbors}{Whether to include in the output the adjacency matrix of nearest neighbors.}

\item{verbose}{Verbosity}

\item{...}{Additional arguments passed to \code{\link{projectKNNs}}.}
}
\value{
A `largeVis` object with the following slots:
 \describe{
   \item{'knns'}{An [N,K] 0-indexed integer matrix, which is an adjacency list of each vertex' identified nearest neighbors.
   If the algorithm failed to find \code{K} neighbors, the matrix is padded with \code{NA}'s.}
   \item{'wij'}{A sparse [N,N] matrix where each cell represents \eqn{w_{ij}}.}
   \item{'call'}{The call.}
   \item{'coords'}{A [N,D] matrix of the embedding of the dataset in the low-dimensional space.}
 }
}
\description{
This is an implementation of the \code{largeVis} algorithm by Tang et al.

Apply the LargeVis algorithm for visualizing large high-dimensional datasets.
}
\details{
\code{largeVis} estimates a low-dimensional embedding for high-dimensional data, where the distance between vertices
in the low-dimensional space is proportional to the distance between them in the high-dimensional space. The algorithm
works in 4 phases:

\itemize{
\item  Estimate candidate nearest-neighbors for each vertex by building \code{n.trees} random projection trees.
\item  Estimate \code{K} nearest-neighbors for each vertex by visiting each vertex' 2d-degree neighbors (its neighbors' neighbors).
This is repeated \code{max.iter} times.  Note that the original paper suggested a \code{max.iter} of 1, however a larger number
may be appropriate for some datasets if the algorithm has trouble finding K neighbors for every vertex.
\item Estimate \eqn{p_{j|i}}, the conditional probability that each edge found in the previous step is actually to a
nearest neighbor of each of its nodes.
\item Using stochastic gradient descent, estimate an embedding for each vertex in the low-dimensional space.
}
}
\examples{
# iris
data(iris)
dat <- as.matrix(iris[,1:4])
dat <- scale(dat)
dupes = which(duplicated(dat))
dat <- dat[-dupes,] # duplicates can cause the algorithm to fail
dat <- t(dat)
visObject <- largeVis(dat, max_iter = 20, K = 10)
\dontrun{
# mnist
load("./mnist.Rda")
dat <- mnist$images
dim(dat) <- c(42000, 28 * 28)
dat <- (dat / 255) - 0.5
dat <- t(dat)
coords <- largeVis(dat, n_trees = 50, tree_th = 200, K = 50)
}

}
\references{
Jian Tang, Jingzhou Liu, Ming Zhang, Qiaozhu Mei. \href{https://arxiv.org/abs/1602.00370}{Visualizing Large-scale and High-dimensional Data.}

Jian Tang, Jingzhou Liu, Ming Zhang, Qiaozhu Mei. \href{https://arxiv.org/abs/1602.00370}{Visualizing Large-scale and High-dimensional Data.}
}

