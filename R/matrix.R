#' Openrouteservice Matrix
#'
#' Obtain one-to-many, many-to-one and many-to-many matrices for time and
#' distance.
#'
#' @param locations A list of `longitude, latitude` coordinate pairs, or a two column `data.frame`
#' @template param-profile
#' @param metrics Returned metrics. Use `"distance"` for distance matrix in
#'   defined `units`, and/or `duration`` for time matrix in seconds.
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint matrix
#' @return Duration or distance matrix for multiple source and destination
#'   points.
#' @examples
#' coordinates = list(
#'   c(9.970093, 48.477473),
#'   c(9.207916, 49.153868),
#'   c(37.573242, 55.801281),
#'   c(115.663757,38.106467)
#' )
#'
#' # query for duration and distance in km
#' res = ors_matrix(coordinates, metrics = c("duration", "distance"), units = "km")
#'
#' # duration in hours
#' res$durations / 3600
#'
#' # distance in km
#' res$distances
#' @template author
#' @export
ors_matrix <- function(locations,
                       profile = c('driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-safe', 'cycling-mountain', 'cycling-tour', 'cycling-electric', 'foot-walking', 'foot-hiking', 'wheelchair'),
                       metrics = c('distance', 'duration'),
                       ...,
                       api_key = ors_api_key(),
                       parse_output = NULL) {
  if (missing(locations))
    stop('Missing argument "locations"')

  names(locations) <- NULL

  profile = match.arg(profile)

  metrics = match.arg(metrics, several.ok=TRUE)
  metrics = collapse_vector(metrics)

  query = api_query(api_key)

  body = list(locations = locations, profile = profile, metrics = metrics, ...)

  api_call("matrix", "POST", query, body = body, encode = "json", parse_output = parse_output)
}
