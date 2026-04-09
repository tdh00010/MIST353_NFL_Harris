import streamlit as st
from get_teams_by_conference_division_ui import get_teams_by_conference_division_ui
from get_teams_in_same_conference_division_as_specified_team_ui import get_teams_in_same_conference_division_as_specified_team_ui
from validate_user_ui import validate_user_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui

def nfl_playoffs_ui():
    st.title("NFL Playoffs Dashboard")
    st.write("Welcome to the NFL Playoffs Dashboard!")

    with st.sidebar:
        st.title("NFL Playoff Functionalities")
        api_endpoint = st.selectbox(
            "Select a functionality:",
            [
                "Get Teams by Conference and Division",
                "Get Teams in Same Conference and Division as Specified Team",
                "Validate User",
                "Get Teams for Specified Fan"
            ]
        )

    if api_endpoint == "Get Teams by Conference and Division":
        get_teams_by_conference_division_ui()

    elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
        get_teams_in_same_conference_division_as_specified_team_ui()

    elif api_endpoint == "Validate User":
        validate_user_ui()

    elif api_endpoint == "Get Teams for Specified Fan":
        get_teams_for_specified_fan_ui()

if __name__ == "__main__":
    nfl_playoffs_ui()