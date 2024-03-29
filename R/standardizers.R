source("R/globals.R")

std_uppercase <- function(df, cols) {
  #' Uppercase string values
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param except Column or columns to remain untouched.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        stringr::str_to_upper
      ),
    )
}

std_directions <- function(df, cols) {
  #' Standardizes abbreviated cardinal directions.
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_trim(stringr::str_replace_all(., c(
          # Directions
          "(^| )N\\.? " = " NORTH ",
          "(^| )N\\.?W\\.? " = " NORTHWEST ",
          "(^| )N\\.?E\\.? " = " NORTHEAST ",
          "(^| )S\\.? " = " SOUTH ",
          "(^| )S\\.?W\\.? " = " SOUTHWEST ",
          "(^| )S\\.?E\\.? " = " SOUTHEAST ",
          "(^| )E\\.? " = " EAST",
          "(^| )W\\.? " = " WEST "
        )
        )
        )
      )
    )
}

std_andslash <- function(df, cols) {
  #' Standardizes slashes to have a space on either side and
  #' replaces all instances of an ampersand with the word "AND"
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          # Put space around slashes
          " ?/ ?" = " / ",
          # Replace & with AND
          " ?& ?" = " AND "
        )
        )
      )
    )
}

std_onewordaddress <- function(df, cols) {
  #' Currently, std_simplify address just strips numbers from the end of
  #' address fields that contain only e.g., "APT" and #. This is a cludgy
  #' clean-up.
  #' TODO: Replace with better regex in std_simplify ::shrug::
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          # Put space around slashes
          "^[A-Z0-9]+$" = NA_character_
        )
        )
      )
    )
}

std_trailingwords <- function(df, cols) {
  #' Standardizes slashes to have a space on either side and
  #' replaces all instances of an ampersand with the word "AND"
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          # Put space around slashes
          " OF$" = "",
          # Replace & with AND
          " AND$" = "",
          "^THE " = ""
        )
        )
      )
    )
}

std_remove_special <- function(df, cols) {
  #' Removes all special characters from columns, except slash
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          "[^[:alnum:][:space:]/-]" = ""
        )
        )
      )
    )
}

std_small_numbers <- function(df, cols) {
  #' Standardize small leading numbers.
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          "^ZERO(?=[ -])" = "0",
          "^ONE(?=[ -])" = "1",
          "^TWO(?=[ -])" = "2",
          "^THREE(?=[ -])" = "3",
          "^FOUR(?=[ -])" = "4",
          "^FIVE(?=[ -])" = "5",
          "^SIX(?=[ -])" = "6",
          "^SEVEN(?=[ -])" = "7",
          "^EIGHT(?=[ -])" = "8",
          "^NINE(?=[ -])" = "9",
          "^TEN(?=[ -])" = "10",
          "(?<= |^)FIRST(?= )" = "1ST",
          "(?<= |^)SECOND(?= )" = "2ND",
          "(?<= |^)THIRD(?= )" = "3RD",
          "(?<= |^)FOURTH(?= )" = "4TH",
          "(?<= |^)FIFTH(?= )" = "5TH",
          "(?<= |^)SIXTH(?= )" = "6TH",
          "(?<= |^)SEVENTH(?= )" = "7TH",
          "(?<= |^)EIGHTH(?= )" = "8TH",
          "(?<= |^)NINTH(?= )" = "9TH",
          "(?<= |^)TENTH(?= )" = "10TH"
        )
        )
      )
    )
}

std_remove_middle_initial <- function(df, cols) {
  #' Replace middle initial when formatted like "ERIC R HUNTLEY"
  #' 
  #' @param df A dataframe.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace(., "(?<=[A-Z] )[A-Z] (?=[A-Z])", "")
      )
    )
}



std_replace_blank <- function(df, cols) {
  #' Replace blank string with NA and remove leading and trailing whitespace.
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~dplyr::case_when(
          stringr::str_detect(
            .,
            "^X+$|^N(ONE)?$|^UNKNOWN$|ABOVE|^N / A$|^[- ]*SAME( ADDRESS)?") ~
            NA_character_,
          TRUE ~ stringr::str_squish(.)
        )
      )
    )
}

std_the <- function(df, cols) {
  #' Strips away leading or trailing the
  #'
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(
          .,
          c(
            " THE$" = "",
            "^THE " = "")
        )
      )
    )
}

std_and <- function(df, cols){
  #' Strips away leading or trailing and
  #' 
  #' @param df A dataframe containing only string datatypes.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols), 
        ~ stringr::str_replace_all(
          .,
          c(
            " AND$" = "",
            "^AND " = "")
        )
      )
    )
}

std_street_types <- function(df, cols) {
  #' Standardize street types.
  #'
  #' @param df A dataframe.
  #' @param cols Column or columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(
          .,
          c(
            # Correct for spaces between numbers and suffixes.
            # (Prevents errors like 3 RD > 3 ROAD after type std.)
            "(?<=[1-9 ][1-9]) (?=(ST|RD|TH|ND) |$)" = "",
            "(?<= )ST(?=$|\\s|\\.)" = "STREET",
            "(?<= )AVE?(?=$|\\s|\\.)" = "AVENUE",
            "(?<= )LA?N(?=$|\\s|\\.)" = "LANE",
            "(?<= )BLV?R?D?(?=$|\\s|\\.)" = "BOULEVARD",
            "(?<= )PR?KWA?Y(?=$|\\s|\\.)" = "PARKWAY",
            "(?<= )DRV?(?=$|\\s|\\.)" = "DRIVE",
            "(?<= )RD(?=$|\\s|\\.)" = "ROAD",
            "(?<= )TE?[R]+CE?(?=$|\\s|\\.)" = "TERRACE",
            "(?<= )PLC?E?(?=$|\\s|\\.)" = "PLACE",
            "(?<= )(CI?RC?)(?=$|\\s|\\.)" = "CIRCLE",
            "(?<= )A[L]+E?Y(?=$|\\s|\\.)" = "ALLEY",
            "(?<= )SQR?(?=$|\\s|\\.)" = "SQUARE",
            "(?<= )HG?WY(?=$|\\s|\\.)" = "HIGHWAY",
            "(?<= )FR?WY(?=$|\\s|\\.)" = "FREEWAY",
            "(?<= )CR?T(?=$|\\s|\\.)" = "COURT",
            "(?<= )PLZ?(?=$|\\s|\\.)" = "PLAZA",
            "(?<= )W[HR]+F(?=$|\\s|\\.)" = "WHARF",
            "(?<= |^)P\\.? ?O\\.? ?BO?X(?=$|\\s|\\.)" = "PO BOX"
          )
        )
      )
    )
}

std_zip <- function(df, cols) {
  #' Standardize and simplify (i.e., remove 4-digit suffix) US Postal codes.
  #'
  #' @param df A dataframe.
  #' @param cols Column or columns containing the ZIP code to be simplified.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & 
          tidyselect::all_of(cols), 
          ~ dplyr::case_when(
            stringr::str_detect(., "[0-9] [0-9]") ~ stringr::str_extract(
              .,
              ".*(?=\\ )"
            ),
            stringr::str_detect(., "-") ~ stringr::str_extract(
              .,
              ".*(?=\\-)"
            ),
            stringr::str_detect(., "^0+$") ~ NA_character_,
            TRUE ~ .
          )
        )
      )
}

std_massachusetts <- function(df, cols) {
  #' Replace "MASS" with "MASSACHUSETTS"
  #'
  #' @param df A dataframe.
  #' @param cols Column or columns in which to replace "MASS"
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          "MASS " = "MASSACHUSETTS "
        )
        )
      )
    )
}

std_city_names <- function(df, cols) {
  #' Replace Boston neighborhoods with Boston
  #' @param df A dataframe.
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  neighs <- file.path(
      DATA_DIR, 
      stringr::str_c(BOS_NEIGH, "csv", sep = ".")
    ) |>
    readr::read_delim(
      delim = ",", 
      show_col_types = FALSE
      ) |>
    std_uppercase(c("Name")) |>
    dplyr::pull(Name)
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ dplyr::case_when(
          . %in% c(
            neighs,
            c("ROXBURY CROSSING", "DORCHESTER CENTER")
          ) ~ "BOSTON",
          . %in% c("NORTHWEST BEDFORD") ~ "BEDFORD",
          TRUE ~ .
        )
      )
    )
}

std_simplify_address <- function(df, cols) {
  #' Standardize street types.
  #'
  #' @param df A dataframe.
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  replace <- c(
    # Matching unit word.
    "[ -]+((BLDG)|(UN?I?T)|(S(UI)?T?E)|(AP(ARTMEN)?T)|(NO)|(P ?O BOX)|(FLO?O?R)|(R(OO)?M)|(PMB))( *#?[A-Z]?[0-9-]*([A-Z]|([A-Z][A-Z])|(ABC))? ?$)" = "",
    # NTH FLOOR
    "[ -]+[1-9]+((ND)|(ST)|(RD)|(TH))? (FLO?O?R?)" = "",
    # Ends with series of letters and numbers.
    "[ -]+[A-Z]?[0-9-]+([A-Z]|(ABC))? ?$" = "",
    # Ends with a single number or letter.
    "[ -]+[A-Z0-9-]$" = ""
  )
  for (col in cols) {
    # Flag PO Boxes.
    df <- df |>
      dplyr::mutate(
        pobox = dplyr::case_when(
          stringr::str_detect(get(col), "^PO BOX") ~ TRUE,
          TRUE ~ FALSE
        )
      )
    po_box <- dplyr::filter(df, pobox)
    df <- dplyr::filter(df, !pobox) |>
      dplyr::mutate(
        dplyr::across(
          tidyselect::matches(col),
          ~ stringr::str_replace_all(., replace)
        )
      ) |>
      dplyr::bind_rows(po_box)
  }
  df |>
    dplyr::select(-c(pobox))
}

std_corp_types <- function(df, cols) {
  #' Standardize street types.
  #'
  #' @param df A dataframe.
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., c(
          "LIMITED PARTNER?(SHIP)?" = "LP",
          "LIMITED LIABILITY PARTNER?(SHIP)?" = "LLP",
          "LIMITED LIABILITY (COMPANY|CORPORATION)" = "LLC",
          "PRIVATE LIMITED" = "LTD",
          "INCO?R?P?O?R?A?T?E?D ?$" = "INC",
          "CORPO?R?A?T?I?O?N ?$" = "CORP",
          "COMP(ANY)? ?$" = "CO",
          "LIMITED$" = "LTD",
          " TRU?S?T?E?E?S?( OF)?$" = " TRUST"
        )
        )
      )
    )
}

std_remove_co <- function(df, cols) {
  #' Remove "C / O" prefix.
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(., " ?C / O? ?", "")
      )
    )
}

std_hyphenated_numbers <- function(df, cols) {
  #' Strips away second half of hyphenated number
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    # Remove "C / O" prefix.
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ stringr::str_replace_all(
            stringr::str_replace_all(., "(?<=[0-9]{1,4}[A-Z]?)-[0-9]+[A-Z]?", ""),
            "(?<=[0-9]{1,4}[A-Z]?)-(?=[A-Z]{1,2})",
            ""
        )
      )
    )
}

std_select_address <- function(df,
                               addr_col1,
                               addr_col2,
                               output_col = "address") {
  #' Choose address column on simple criteria.
  #'
  #' @param df A dataframe.
  #' @param addr_col1 First address column to be compared.
  #' @param addr_col2 Second address column to be compared.
  #' @param output_col Name of column that stores selected address.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      !!output_col := dplyr::case_when(
        stringr::str_detect(
          get({{ addr_col2 }}), "^[0-9]") &
          !stringr::str_detect(get({{ addr_col1 }}), "^[0-9]")
        ~ get({{ addr_col2 }}),
        stringr::str_detect(
          get({{ addr_col2 }}), "^[0-9]") &
          stringr::str_detect(get({{ addr_col1 }}), "LLC")
        ~ get({{ addr_col2 }}),
        TRUE ~ get({{ addr_col1 }})
      )
    )
}

st_get_zips <- function(sdf, zip_col, state = "MA", crs = 2249) {
  #' Get ZIP codes based on actual parcel location.
  #' (These are frequently misreported.)
  #'
  #' @param sdf A sf dataframe.
  #' @param zip_col Name the column to which you want postal codes written.
  #' @param state State of your study. (TODO: multiple states?)
  #' @param crs EPSG code of appropriate coordinate reference system.
  #' @returns A dataframe.
  #' @export
  sdf |>
    dplyr::mutate(
      point = sf::st_point_on_surface(geometry)
    ) |>
    sf::st_set_geometry("point") |>
    sf::st_join(
      tigris::zctas(cb = FALSE, state = state, year = 2010) |>
        sf::st_transform(crs) |>
        dplyr::select(ZCTA5CE10)
    ) |>
    sf::st_set_geometry("geometry") |>
    dplyr::select(
      -c(point)
    ) |>
    dplyr::mutate(
      !!zip_col := ZCTA5CE10
    ) |>
    dplyr::select(-c(ZCTA5CE10))
}

st_get_censusgeo <- function(sdf, state = "MA", crs = 2249) {
  #' Bind census geography IDs to geometries of interest.
  #'
  #' @param sdf A sf dataframe.
  #' @param state State of your study. (TODO: multiple states?)
  #' @param crs EPSG code of appropriate coordinate reference system.
  #' @returns A dataframe.
  #' @export
  censusgeo <- tigris::block_groups(state = state) |>
    sf::st_transform(crs) |>
    dplyr::rename(
      geoid_bg = GEOID
    ) |>
    dplyr::select(geoid_bg)
  sdf |>
    dplyr::mutate(
      point = sf::st_point_on_surface(geometry)
    ) |>
    sf::st_set_geometry("point") |>
    sf::st_join(
      censusgeo
    ) |>
    sf::st_set_geometry("geometry") |>
    dplyr::mutate(
      geoid_t = stringr::str_sub(geoid_bg, start = 1L, end = 11L)
    ) |>
    dplyr::select(
      -c(point)
    )
}

std_corp_rm_sys <- function(df, cols) {
  #' Replace variations on "CORPORATION SYSTEMS" with NA in corp addresses.
  #'
  #' @param df A dataframe.
  #' @param cols The columns containing the addresses to be standardized.
  #' @returns A dataframe.
  #' @export
  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.character) & tidyselect::all_of(cols),
        ~ dplyr::case_when(
          stringr::str_detect(
            .,
            "(((CORP(ORATION)?)|(LLC)|) (SYS)|(SER))|(AGENT)|(BUSINESS FILINGS)"
          ) ~ NA_character_,
          TRUE ~ .
        )
      )
    )
}

std_flow_strings <- function(df, cols) {
  #' Generic string standardization workflow.
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    std_andslash(cols) |>
    std_remove_special(cols) |>
    std_replace_blank(cols) |>
    std_the(cols) |>
    std_small_numbers(cols) |>
    std_trailingwords(cols) |>
    std_uppercase(cols)
}

std_flow_addresses <- function(df, cols) {
  #' Address standardization workflow.
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    std_street_types(cols) |>
    std_simplify_address(cols) |>
    std_directions(cols) |>
    std_hyphenated_numbers(cols) |>
    std_onewordaddress(cols) |> 
    std_massachusetts(cols)
}

std_flow_cities <- function(df, cols) {
  #' Address standardization workflow.
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    std_city_names(cols) |>
    std_directions(cols)
}

std_flow_names <- function(df, cols) {
  #' Name standardization workflow.
  #'
  #' @param cols Columns to be processed.
  #' @returns A dataframe.
  #' @export
  df |>
    std_corp_types(cols) |>
    std_corp_rm_sys(cols) |>
    std_remove_middle_initial(cols) 
}
