# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

hungarian_cc <- function(cost) {
    .Call(`_MPSK_hungarian_cc`, cost)
}

relabel <- function(res) {
    .Call(`_MPSK_relabel`, res)
}

calib <- function(Y, C, Z, mu_input, mu_dim, mu0_input, mu0_dim, S) {
    .Call(`_MPSK_calib`, Y, C, Z, mu_input, mu_dim, mu0_input, mu0_dim, S)
}

perturbedSNcpp <- function(Y, C, prior, pmc, state) {
    .Call(`_MPSK_perturbedSNcpp`, Y, C, prior, pmc, state)
}

