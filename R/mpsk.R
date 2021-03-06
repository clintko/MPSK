#' Fit SMPK model
#'
#' This function generates a sample from the posterior of CREMID.
#'
#' @param Y Matrix of the data. Each row represents an observation.
#' @param C Vector of the group label of each observation. Labels are integers starting from 1.
#' @param prior A list giving the prior information. If unspecified, a default prior is used.
#' The list includes the following hyparameters:
#' \code{K} Number of mixture components.
#' \code{merge_step} Introduce step to merge mixture components with small KL divergence. Default is \code{merge_step = TRUE}.
#' \code{merge_par} Parameter controlling merging radius. Default is \code{merge_par = 0.1}.
#' @export
mpsk = function(Y, C, prior = NULL, pmc = NULL, state = NULL)
{
  Y = as.matrix(Y)
  p = ncol(Y)

  # R wrapper (this code is general):
  if(is.null(prior)) {
    prior = list(    K = 10,
                     tau_a = c(1, 1),
                     m0 = ncol(Y)+2,
                     Lambda = cov(Y),
                     a_varphi = 0.5,
                     b_varphi = 0.5,
                     e0 = ncol(Y) + 2,
                     E0 = 0.1 * cov(Y),
                     merge_step = TRUE,
                     merge_par = 0.01  )
  } else {
    if(is.null(prior$K))
      prior$K = 10;
    if(is.null(prior$tau_a))
      prior$tau_a = c(1, 1);
    if(is.null(prior$Lambda))
      prior$Lambda = cov(Y);
    if(is.null(prior$m0))
      prior$m0 = ncol(Y)+2;
    if(is.null(prior$a_varphi))
      prior$a_varphi = 0.5;
    if(is.null(prior$b_varphi))
      prior$b_varphi = 0.5;
    if(is.null(prior$e0))
      prior$e0 = ncol(Y) + 2;
    if(is.null(prior$E0))
      prior$E0 = 0.1 * cov(Y);
    if(is.null(prior$merge_step))
      prior$merge_step = TRUE;
    if(is.null(prior$merge_par))
      prior$merge_par = 0.01;
  }


  if(is.null(pmc)) {
    pmc = list(npart = 10, nburn = 2000, nsave = 500, nskip = 1, ndisplay = 50)
  } else {
    if(is.null(pmc$npart))
      pmc$npart = 10
    if(is.null(pmc$nburn))
      pmc$nburn = 2000
    if(is.null(pmc$nsave))
      pmc$nsave = 500
    if(is.null(pmc$nskip))
      pmc$nskip = 1
    if(is.null(pmc$ndisplay))
      pmc$ndisplay = 50
  }

  if(is.null(state$t)) {
    state$t = kmeans(Y, prior$K, iter.max = 100)$cluster - 1
  }

  J = length(unique(C))
  if( sum( sort(unique(C)) == 1:J )  != J )
  {
    print("ERROR: unique(C) should look like 1, 2, ...")
    return(0);
  }
  C = C - 1

  ans = perturbedSNcpp(Y, C, prior, pmc, state)
  colnames(ans$data$Y) = colnames(Y)
  ans$data$C = ans$data$C + 1
  ans$chain$t = ans$chain$t + 1
  class(ans) = "MPSK"
  return(ans)
}

