
#' Make request to Zillow API GetComps Web Service
#'
#' The GetComps API returns a list of comparable recent sales for a specified
#' property. The result set returned contains the address, Zillow property
#' identifier, and Zestimate for the comparable properties and the principal
#' property for which the comparables are being retrieved.
#'
#' @param zpid The Zillow Property ID for the property for which to obtain
#'     information. Required.
#' @param count The number of comparable recent sales to obtain (between 1 and
#'     25)
#' @param rentzestimate Return Rent Zestimate information if available (logical,
#'     default: false).
#' @param zws_id The Zillow Web Service Identifier. Required.
#' @param url URL for the GetComps Web Service. Required.
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
#' GetComps(zpid = 48749425, count = 5)
#' GetComps(zpid = 48749425, count = 5, rentzestimate = TRUE)}
GetComps <- function(
    zpid = NULL, count = NULL,
    rentzestimate = FALSE,
    zws_id = getOption('ZillowR-zws_id'),
    url = 'http://www.zillow.com/webservice/GetComps.htm'
) {
    validation_errors <- c(
        validate_arg(zpid, required = TRUE, format = '^\\d+$', length_min = 1, length_max = 1),
        validate_arg(count, required = TRUE, inclusion = 1:25, length_min = 1, length_max = 1),
        validate_arg(rentzestimate, inclusion = c(FALSE, TRUE), length_min = 1, length_max = 1),
        validate_arg(zws_id, required = TRUE, class = 'character', length_min = 1, length_max = 1),
        validate_arg(url, required = TRUE, class = 'character', length_min = 1, length_max = 1)
    )

    if (length(validation_errors) > 0) {
        stop(paste(validation_errors, collapse = '\n'))
    }

    request <- url_encode_request(url,
        'zpid' = zpid,
        'count' = count,
        'rentzestimate' = rentzestimate,
        'zws-id' = zws_id
    )

    response <- tryCatch(
        RCurl::getURL(request),
        error = function(e) {stop(sprintf("Zillow API call with request '%s' failed with %s", request, e))}
    )

    return(preprocess_response(response))
}
