import streamlit as st
from get_teams_by_conference_division_ui import get_teams_by_conference_division_ui
from get_teams_in_same_conference_division_as_specified_team_ui import get_teams_in_same_conference_division_as_specified_team_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui
from get_teams_with_logos_for_specified_fan_ui import get_teams_with_logos_for_specified_fan_ui
from validate_user_ui import validate_user_ui
from schedule_game_ui import schedule_game_ui

def nfl_playoffs_ui():
    st.title("NFL Playoffs App")
    st.caption("Use the sidebar to navigate through different features.")

    # Sidebar menu
    with st.sidebar:
        st.title("NFL Playoff Functionalities")

        api_endpoint = st.selectbox(
            "Select a functionality:",
            [
                "Get Teams by Conference and Division",
                "Get Teams in Same Conference and Division as Specified Team",
                "Get Teams for Specified Fan",
                "Get Teams with Logos for Specified Fan",
                "Validate User",
                "Schedule Game"
            ]
        )

    # Routing to correct UI
    if api_endpoint == "Get Teams by Conference and Division":
        get_teams_by_conference_division_ui()

    elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
        get_teams_in_same_conference_division_as_specified_team_ui()

    elif api_endpoint == "Get Teams for Specified Fan":
        get_teams_for_specified_fan_ui()

    elif api_endpoint == "Get Teams with Logos for Specified Fan":
        get_teams_with_logos_for_specified_fan_ui()

    elif api_endpoint == "Validate User":
        validate_user_ui()

    elif api_endpoint == "Schedule Game":
        schedule_game_ui()


if __name__ == "__main__":
    nfl_playoffs_ui()
