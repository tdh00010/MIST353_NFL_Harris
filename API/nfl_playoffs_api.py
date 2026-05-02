from datetime import date, time

from fastapi import FastAPI
from get_teams_by_conference_division import get_teams_by_conference_division
from get_teams_in_same_conference_division_as_specified_team import get_teams_in_same_conference_division_as_specified_team
from validate_user import validate_user
from get_teams_for_specified_fan import get_teams_for_specified_fan
from schedule_game import schedule_game
from get_all_teams import get_all_teams
from get_all_stadiums import get_all_stadiums

app = FastAPI()

@app.get("/get_teams_by_conference_division")
def get_teams_by_conference_division_api(conference: str = None, division: str = None):
    return get_teams_by_conference_division(conference, division)

@app.get("/get_teams_in_same_conference_division_as_specified_team")
def get_teams_in_same_conference_division_as_specified_team_api(team_name: str):
    return get_teams_in_same_conference_division_as_specified_team(team_name)

@app.get("/validate_user")
def validate_user_api(email: str, password_hash: str):
    return validate_user(email=email, password_hash=password_hash)

@app.get("/get_teams_for_specified_fan")
def get_teams_for_specified_fan_api(nfl_fan_id: int):
    return get_teams_for_specified_fan(nfl_fan_id)

@app.post("/schedule_game")
def schedule_game_api(
    home_team_id: int,
    away_team_id: int,
    game_round: str,
    game_date: date,
    game_time: time,
    stadium_id: int,
    nfl_admin_id: int
):
    return schedule_game(
        home_team_id=home_team_id,
        away_team_id=away_team_id,
        game_round=game_round,
        game_date=game_date,
        game_time=game_time,
        stadium_id=stadium_id,
        nfl_admin_id=nfl_admin_id
    )

@app.get("/get_all_teams")
def get_all_teams_api():
    return get_all_teams()

@app.get("/get_all_stadiums")
def get_all_stadiums_api():
    return get_all_stadiums()