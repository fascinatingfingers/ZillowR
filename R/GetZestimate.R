
#' Make request to Zillow API GetZestimate Web Service
#'
#' For a specified Zillow property identifier (zpid), the GetZestimate API
#' returns:
#'
#' \itemize{
#'   \item The most recent property Zestimate
#'   \item The date the Zestimate was computed
#'   \item The valuation range
#'   \item The Zestimate ranking within the property's ZIP code.
#'   \item The full property address and geographic location (latitude/longitude)
#'       and a set of identifiers that uniquely represent the region (ZIP code,
#'       city, county & state) in which the property exists.
#' }
#'
#' The GetZestimate API will only surface properties for which a Zestimate
#' exists. If a request is made for a property that has no Zestimate, an error
#' code is returned. Zillow doesn't have Zestimates for all the homes in its
#' database. For such properties, we do have tax assessment data, but that is
#' not provided through the API. For more information, see our Zestimate
#' coverage.
#'
#' @param zpid The Zillow Property ID for the property for which to obtain
#'     information. Required.
#' @param rentzestimate Return Rent Zestimate information if available (logical,
#'     default: false).
#' @param zws_id The Zillow Web Service Identifier. Required.
#' @param url URL for the GetZestimate Web Service. Required.
#'
#' @return A named list with the following elements:
#'     \describe{
#'         \item{\strong{request}}{a list with the request parameters}
#'         \item{\strong{message}}{a list of status code(s) and message(s)
#'             returned by the API}
#'         \item{\strong{response}}{an XMLNode with the API-specific response
#'             values. At this time, no further coercion is performed, so you
#'             may have to use functions from the `XML` package to extract
#'             the desired output.}
#'     }
#'
#' @export
#' @importFrom RCurl getURL
#'
#' @examples
#' \dontrun{
#' GetZestimate(zpid = 48749425)
#' GetZestimate(zpid = 48749425, rentzestimate = TRUE)}
GetZestimate <- function(
    zpid = NULL,
    rentzestimate = FALSE,
    zws_id = getOption('ZillowR-zws_id'),
    url = 'http://www.zillow.com/webservice/GetZestimate.htm'
) {
    validation_errors <- c(
        validate_arg(zpid, required = TRUE, format = '^\\d+$', length_min = 1, length_max = 1),
        validate_arg(rentzestimate, inclusion = c(FALSE, TRUE), length_min = 1, length_max = 1),
        validate_arg(zws_id, required = TRUE, class = 'character', length_min = 1, length_max = 1),
        validate_arg(url, required = TRUE, class = 'character', length_min = 1, length_max = 1)
    )

    if (length(validation_errors) > 0) {
        stop(paste(validation_errors, collapse = '\n'))
    }

    request <- url_encode_request(url,
        'zpid' = zpid,
        'rentzestimate' = rentzestimate,
        'zws-id' = zws_id
    )

    response <- tryCatch(
        RCurl::getURL(request),
        error = function(e) {stop(sprintf("Zillow API call with request '%s' failed with %s", request, e))}
    )

    return(preprocess_response(response))
}
