
#' Make request to Zillow API GetMonthlyPayments Web Service
#'
#' For a specific loan amount, the GetMonthlyPayments API returns the estimated
#' monthly payment that includes principal and interest based on today's
#' mortgage rate. The API returns the estimated monthly payment per loan type
#' (30-year fixed, 15-year fixed, and 5/1 ARM). If a ZIP code is entered, the
#' estimated taxes and insurance are returned in the result set.
#'
#' @param price The price of the property for which monthly payment data will be
#'     calculated. Required.
#' @param down The percentage of the total property price that will be placed as
#'     a down payment. If omitted, a 20% down payment is assumed. If the down
#'     payment is less than 20%, a monthly private mortgage insurance amount is
#'     specified for each returned loan type.
#' @param dollarsdown The dollar amount that will be placed as a down payment.
#'     This amount will be used for the down payment if the 'down' parameter is
#'     omitted. If the down payment is less than 20% of the purchase price, a
#'     monthly private mortgage insurance amount is specified for each returned
#'     loan type.
#' @param zip The ZIP code in which the property is located. If omitted, monthly
#'     property tax and hazard insurance data will not be returned.
#' @param zws_id The Zillow Web Service Identifier. Required.
#' @param url URL for the GetMonthlyPayments Web Service. Required.
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
#' GetMonthlyPayments(price = 300000L)
#' GetMonthlyPayments(price = 300000L, down = 10)
#' GetMonthlyPayments(price = 300000L, dollarsdown = 10000L)
#' GetMonthlyPayments(price = 300000L, zip = 98109)}
GetMonthlyPayments <- function(
    price = NULL,
    down = NULL, dollarsdown = NULL, zip = NULL,
    zws_id = getOption('ZillowR-zws_id'),
    url = 'http://www.zillow.com/webservice/GetMonthlyPayments.htm'
) {
    validation_errors <- c(
        validate_arg(price, required = TRUE, format = '^\\d+$', length_min = 1, length_max = 1),
        validate_arg(down, format = '^\\d+$', length_min = 1, length_max = 1, value_min = 0, value_max = 100),
        validate_arg(dollarsdown, format = '^\\d+$', length_min = 1, length_max = 1, value_min = 0),
        validate_arg(zip, format = '^\\d+$', length_min = 1, length_max = 1),
        validate_arg(zws_id, required = TRUE, class = 'character', length_min = 1, length_max = 1),
        validate_arg(url, required = TRUE, class = 'character', length_min = 1, length_max = 1)
    )

    if (length(validation_errors) > 0) {
        stop(paste(validation_errors, collapse = '\n'))
    }

    request <- url_encode_request(url,
        'price' = price,
        'down' = down,
        'dollarsdown' = dollarsdown,
        'zip' = zip,
        'zws-id' = zws_id
    )

    response <- tryCatch(
        RCurl::getURL(request),
        error = function(e) {stop(sprintf("Zillow API call with request '%s' failed with %s", request, e))}
    )

    return(preprocess_response(response))
}
