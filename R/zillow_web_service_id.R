
#' Get/Set Zillow Web Service ID
#'
#' Convienience functions to set your Zillow Web Service ID as a global option
#'
#' Each subscriber to Zillow Web Services is uniquely identified by an ID
#' sequence, and every request to Web Services requires this ID. You may pass
#' your ID to each ZillowR function explicitly, but by default each function
#' uses the value saved in the global 'ZillowR-zws_id' option. The
#' `get_zillow_web_service_id` and `set_zillow_web_service_id`
#' functions make it easy to manipulate this option.
#'
#' Visit the following URL to register for your own Zillow Web Service ID: \cr
#' http://www.zillow.com/webservice/Registration.htm
#'
#' @return
#' `get_zillow_web_service_id` returns a character value with the current
#' 'ZillowR-zws_id' option, or `NULL` if unset.
#'
#' `set_zillow_web_service_id` invisibly returns `NULL`.
#'
#' @examples
#' set_zillow_web_service_id('ZWSID')
#' get_zillow_web_service_id()
#'
#' @name zillow_web_service_id
NULL

#' @export
#' @rdname zillow_web_service_id
get_zillow_web_service_id <- function() {
    getOption('ZillowR-zws_id')
}

#' @export
#' @rdname zillow_web_service_id
#' @param x A character string of length 1 with your Zillow Web Service ID.
set_zillow_web_service_id <- function(x) {
    validate_arg(x, required = TRUE, class = 'character', length_min = 1, length_max = 1)
    options('ZillowR-zws_id' = x)
    return(invisible())
}
