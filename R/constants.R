# JAMES OBJECT
ID          <- "id"
TAB         <- "tab"
STYLE       <- "style"
DEFAULT     <- "default"
LOCK        <- "lock"
NO_TITLE    <- "no-title"
REPLICATE   <- "replicate"
INTERACTIVE <- "interactive"
LIST_TYPE   <- "list-type" # subtype
TYPE        <- "type" # chart types
EXAMPLE     <- "example"
# TYPE        <- "type"  # parameter type (don't confuse with TYPES)
DATA        <- "data"
META        <- "meta"
GLOBALS     <- "globals"
FIGS        <- "figs"
JID         <- "jid" # James ID
USER        <- "user"
TIMESTAMP   <- "timestamp"
REPORT      <- "report"
REPORT_TEXT <- "report_text"
CREATE      <- "create"
CBS_URL     <- "cbs_url"
GEO_REGION_DATA <- "geo_region_data"
UNIT        <- "unit"
TITLE       <- "title"

# PARAMTERS
TURN          <- "turn"
HIGHLIGHT_X   <- "highlight_x"
AUTO          <- "auto"
DO_NOT_CHANGE <- "do-not-change"
DOT_SHAPE     <- "dot_shape"

# DATA TYPES
NUMERIC   <- "numeric"
SEP0      <- ","
SEP1      <- ";"
SEP2      <- ";;"
LIST_SEPS <- c(SEP0, SEP1, SEP2)
STRING    <- "string"
BOOL      <- "bool"
NO        <- c("n", "N", "no", "No", "NO", "F", "FALSE", FALSE)
YES       <- c("y", "Y", "yes", "Yes", "YES", "T", "TRUE", TRUE)
BOOL_SET  <- c(NO, YES)
DATE      <- "Date"
PATH      <- "path"
R         <- "r"

# AVAILABLE FILE FORMATS
FILE_FORMATS <- c("gif", "jpg", "pdf", "png", "svg")

# PLATFORMS
AUTO_DETECT <- "auto_detect"
LINUX       <- "linux"
OSX         <- "osx"
OSX_LOCAL   <- "osx_local"
WINDOWS     <- "windows"

# ERROR HANDLING
ERROR <- "error"

# PLOT TYPES
PARAM         <- "param"
LABEL         <- "label"
LINE          <- "line"
LINE_DASH     <- "line_dash"
LINE_SET      <- c(LINE, LINE_DASH)
AREA_STACK    <- "area="
AREA          <- "area"
AREA_SET      <- c(AREA, AREA_STACK)
HEATMAP       <- "heatmap"
HIST          <- "histogram"
BAR_NEXT      <- "bar--"
BAR_STACK     <- "bar="
BAR_SET       <- c(BAR_NEXT, BAR_STACK)
DOT           <- "dot"
WHISKER       <- "whisker"
BOX           <- "box"
MAP           <- "map"
WORLD_MAP     <- "world-map"
WORLD_MAP_WWW <- "world-map-www"
Y_AXIS        <- "y_axis"
LEFT          <- "l"
RIGHT         <- "r"

# AXES
ALIGNMENT     <- c("left", "center", "right")

# DATES
TIME_UNITES   <- c("years", "quarters", "months", "weeks", "days")
MONTH_NL      <- c("jan", "feb", "mar", "apr", "mei", "jun", "jul", "aug", "sep", "okt", "nov", "dec")
MONTH_EN      <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "okt", "nov", "dec")

# HEATMAP COLOR PALETTES
CUSTOM   <- "custom"
LOW_HIGH <- "low_high"
PALETTE_HEATMAP_EXTREME <- "palette_heatmap_extreme"
PALETTE_HEATMAP_MIDDLE  <- "palette_heatmap_middle"

# LEGEND
LEGEND_BLOCK    <- c(AREA_SET, BAR_SET, MAP)
LEGEND_STACK    <- "legend_stack"
LEGEND_FORECAST <- "legend_forecast"
LEGEND_WHISKER  <- "legend_whisker"

# REPORT
DEST       <- "./generated"
SRCE       <- "./ext"
SRCE_INPUT <- file.path(SRCE, "input")
REPORT_DOC_FORMATS          <- c("html", "pdf", "word")                       # append _document
REPORT_PRESENTATION_FORMATS <- c("ioslides", "slidy", "powerpoint", "beamer") # append _presentation
# REPORT_DEFAULT_INTRO_TAB <- "report_default_intro_tab"

# DEBUG
LORUM  <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
LORUM1 <- "Lorem ipsum dolor sit amet"
LORUM2 <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
LORUM3 <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."