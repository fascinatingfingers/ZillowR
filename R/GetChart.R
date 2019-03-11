
#' Make request to Zillow API GetChart Web Service
#'
#' The GetChart API generates a URL for an image file that displays historical
#' Zestimates for a specific property. The API accepts as input the Zillow
#' Property ID as well as a chart type: either percentage or dollar value
#' change. Optionally, the API accepts width and height parameters that
#' constrain the size of the image. The historical data can be for the past 1
#' year, 5 years or 10 years.
#'
#' @param zpid The Zillow Property ID for the property for which to obtain
#'     information. Required.
#' @param unit_type A string value that specifies whether to show the percent
#'     change (unit_type = 'percent') or dollar change (unit_type = 'dollar').
#'     Required.
#' @param width An integer value that specifies the width of the generated
#'     image; the value must be between 200 and 600, inclusive.
#' @param height An integer value that specifies the height of the generated
#'     image; the value must be between 100 and 300, inclusive.
#' @param chartDuration The duration of past data that needs to be shown in the
#'     chart. Valid values are '1year', '5years' and '10years'. If unspecified,
#'     the value defaults to '1year'.
#' @param zws_id The Zillow Web Service Identifier. Required.
#' @param url URL for the GetChart Web Service. Required.
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
#' GetChart(zpid = 48749425)
#' GetChart(zpid = 48749425, unit_type = 'dollar', width = 600, height = 300,
#'          chartDuration = '10years')}
GetChart <- function(
    zpid = NULL, unit_type = c('percent', 'dollar'),
    width = NULL, height = NULL, chartDuration = c('1year', '5years', '10years'),
    zws_id = getOption('ZillowR-zws_id'),
    url = 'http://www.zillow.com/webservice/GetChart.htm'
) {
    validation_errors <- c(
        validate_arg(zpid, required = TRUE, format = '^\\d+$', length_min = 1, length_max = 1),
        validate_arg(unit_type, required = TRUE, inclusion = c('percent', 'dollar'), length_min = 1, length_max = 2),
        validate_arg(width, inclusion = 200:600, length_min = 1, length_max = 1),
        validate_arg(height, inclusion = 100:300, length_min = 1, length_max = 1),
        validate_arg(chartDuration, inclusion = c('1year', '5years', '10years'), length_min = 1, length_max = 3),
        validate_arg(zws_id, required = TRUE, class = 'character', length_min = 1, length_max = 1),
        validate_arg(url, required = TRUE, class = 'character', length_min = 1, length_max = 1)
    )

    if (length(validation_errors) > 0) {
        stop(paste(validation_errors, collapse = '\n'))
    }

    request <- url_encode_request(url,
        'zpid' = zpid,
        'unit-type' = unit_type,
        'width' = width,
        'height' = height,
        'chartDuration' = chartDuration,
        'zws-id' = zws_id
    )

    response <- tryCatch(
        RCurl::getURL(request),
        error = function(e) {stop(sprintf("Zillow API call with request '%s' failed with %s", request, e))}
    )

    return(preprocess_response(response))
}
