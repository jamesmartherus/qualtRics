% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch_survey.R
\name{fetch_survey}
\alias{fetch_survey}
\title{Download a survey and import it into R}
\usage{
fetch_survey(
  surveyID,
  limit = NULL,
  start_date = NULL,
  end_date = NULL,
  time_zone = NULL,
  include_display_order = TRUE,
  include_metadata = NULL,
  include_questions = NULL,
  include_embedded = NULL,
  unanswer_recode = NULL,
  unanswer_recode_multi = unanswer_recode,
  breakout_sets = TRUE,
  import_id = FALSE,
  label = TRUE,
  convert = TRUE,
  add_column_map = TRUE,
  add_var_labels = TRUE,
  col_types = NULL,
  force_request = FALSE,
  verbose = TRUE,
  save_dir = NULL,
  last_response = deprecated()
)
}
\arguments{
\item{surveyID}{String. Unique ID for the survey you want to download.
Returned as \code{id} by the \link[=all_surveys]{all_surveys} function.}

\item{limit}{Integer. Maximum number of responses exported. Defaults to
\code{NULL} (all responses).}

\item{start_date}{String. Filter to only exports responses recorded after the
specified date. Accepts dates as character strings in format "YYYY-MM-DD".
Defaults to \code{NULL}.}

\item{end_date}{String. Filter to only exports responses recorded before the
specified date. Accepts dates as character strings in format "YYYY-MM-DD".
Defaults to \code{NULL}.}

\item{time_zone}{String. A local timezone to determine response date values.
Defaults to \code{NULL}, which corresponds to system local time. See \href{https://api.qualtrics.com/}{"Dates and Times"} from Qualtrics for more information on
format.}

\item{include_display_order}{Display order information (such as for surveys
with randomization).}

\item{include_metadata, include_questions, include_embedded}{Character vector.
Specify variables to include in download.  Defaults to \code{NULL} (keep all).
\code{NA} or \code{character()} excludes all variables for that category. See Details
for unique requirements for each inclusion argument.}

\item{unanswer_recode}{Integer. Recode seen but unanswered questions with an
integer-like value, such as 999. Defaults to \code{NULL}.}

\item{unanswer_recode_multi}{Integer. Recode seen but unanswered multi-select
questions with an integer-like value, such as 999. Defaults to value for
\code{unaswer_recode}.}

\item{breakout_sets}{Logical. If \code{TRUE}, then the \code{\link[=fetch_survey]{fetch_survey()}}
function will split multiple choice question answers into columns. If
\code{FALSE}, each multiple choice question is one column. Defaults to \code{TRUE}.}

\item{import_id}{Logical. If \code{TRUE}, use Qualtrics import IDs instead of
question IDs as column names. Will also alter names in the column map, if
used. Defaults to \code{FALSE}.}

\item{label}{Logical. \code{TRUE} to export survey responses as Choice Text or
\code{FALSE} to export survey responses as values.}

\item{convert}{Logical. If \code{TRUE}, then the \code{\link[=fetch_survey]{fetch_survey()}}
function will convert certain question types (e.g. multiple choice) to
proper data type in R. Defaults to \code{TRUE}.}

\item{add_column_map}{Logical. If \code{TRUE}, then a column map data frame will
be added as an attribute to the main response data frame. This column map
captures Qualtrics-provided metadata associated with the response download,
such as an item description and internal ID's. Defaults to \code{TRUE}.}

\item{add_var_labels}{Logical. If \code{TRUE}, then the item description from each
variable (equivalent to the one in the column map) will be added as a
"label" attribute using \code{\link[sjlabelled:set_label]{sjlabelled::set_label()}}. Useful for reference as
well as cross-compatibility with other stats packages (e.g., Stata, see
documentation in \code{sjlabelled}). Defaults to \code{TRUE}.}

\item{col_types}{Optional. This argument provides a way to manually overwrite
column types that may be incorrectly guessed. Takes a \code{\link[readr:cols]{readr::cols()}}
specification. See example below and \code{\link[readr:cols]{readr::cols()}} for formatting
details. Defaults to \code{NULL}. Overwritten by \code{convert = TRUE}.}

\item{force_request}{Logical. fetch_survey() saves each survey in a temporary
directory so that it can quickly be retrieved later. If force_request is
\code{TRUE}, fetch_survey() always downloads the survey from the API instead of
loading it from the temporary directory. Defaults to \code{FALSE}.}

\item{verbose}{Logical. If \code{TRUE}, verbose messages will be printed to the R
console. Defaults to \code{TRUE}.}

\item{save_dir}{String. Directory where survey results will be stored.
Defaults to a temporary directory which is cleaned when your R session is
terminated. This argument is useful if you'd like to store survey results.
The downloaded survey will be stored as an RDS file (see
\code{\link[base:readRDS]{base::readRDS()}}).}

\item{last_response}{Deprecated.}
}
\description{
Download a Qualtrics survey you own via API and import the survey directly
into R.
}
\details{
If the request to the Qualtrics API made by this function fails, the request
will be retried. If you see these failures on a 500 error (such as a 504
error) be patient while the request is retried; it will typically succeed
on retrying. If you see other types of errors, retrying is unlikely to help.

The three \verb{include_*} arguments each have different requirements to
properly specify what  to the Qualtrics API.

\emph{include_metadata}:

Elements must be one of the 17 Qualtrics metadata variables, listed here in
their default order: \emph{StartDate} (\emph{startDate}), \emph{EndDate} (\emph{endDate}),
\emph{Status} (\emph{status}), \emph{IPAddress} (\emph{ipAddress}), \emph{Progress} (\emph{progress}),
\emph{Duration (in seconds)} (\emph{duration}), \emph{Finished} (\emph{finished}),
\emph{RecordedDate} (\emph{recordedDate}), \emph{ResponseId} (\emph{_recordId}),
\emph{RecipientLastName} (\emph{recipientLastName}), \emph{RecipientFirstName}
(\emph{recipientFirstName}), \emph{RecipientEmail} (\emph{recipientEmail}),
\emph{ExternalReference} (\emph{externalDataReference}), \emph{LocationLatitude}
(\emph{locationLatitude}), \emph{LocationLongitude} (\emph{locationLongitude}),
\emph{DistributionChannel} (\emph{distributionChannel}), \emph{UserLanguage}
(\emph{userLanguage}).  Names in parentheses represent those returned when
argument \code{import_id} is set to \code{TRUE}. However, the function can always
generate a suitable request from either format, and names are not
case-sensitive. Duplicate names will be silently dropped, and data frame
will contain variables in the order specified after de-duplication.

\emph{include_questions}:

Desired variables must be specified using Qualtrics's own unique internal
ID's, rather than any user-specified names. All such ID's start with "QID"
followed by a number.  If needed, a column map linking user-specified ID's
to QID's can be quickly obtained by calling:

\if{html}{\out{<div class="sourceCode">}}\preformatted{
fetch_survey(
     surveyID = \{survey ID\},
     limit = 1,
     add_column_map = TRUE
) |>
  extract_colmap()

}\if{html}{\out{</div>}}

Note that while QID's are unique for each "question" in the Qualtrics
sense, there may not be a 1:1 relationship between QID's and columns in the
response data frame. If, for example, the question with ID \emph{QID5} is a
multiple choice item with a text box added to the third choice, the
downloaded response data frame may include two associated variables:
\emph{"QID5"} (the multiple choice selection) and \emph{"QID5_3_TEXT"} (the text
box). Both variables will be returned by \code{include_questions = "QID5"}.
Additionally, if randomization is used any associated display ordering
variables will also be present (assuming \code{include_display_order = TRUE}).
Currently, separating these via the API does not appear possible (e.g.,
\code{include_questions = "QID5_3_TEXT"} will produce an API error).

\code{include_embedded}:

This argument accepts the user-specified names of any embedded
data variables in the survey being accessed.
}
\examples{
\dontrun{
# Register your Qualtrics credentials if you haven't already
qualtrics_api_credentials(
  api_key = "<YOUR-API-KEY>",
  base_url = "<YOUR-BASE-URL>"
)

# Retrieve a list of surveys
surveys <- all_surveys()

# Retrieve a single survey
mysurvey <- fetch_survey(surveyID = surveys$id[6])

mysurvey <- fetch_survey(
  surveyID = surveys$id[6],
  save_dir = tempdir(),
  start_date = "2018-01-01",
  end_date = "2018-01-31",
  limit = 100,
  label = TRUE,
  unanswer_recode = 999,
  verbose = TRUE,
  # Manually override EndDate to be a character vector
  col_types = readr::cols(EndDate = readr::col_character())
)

}

}
\seealso{
See \url{https://api.qualtrics.com/} for documentation on the Qualtrics
API.
}
