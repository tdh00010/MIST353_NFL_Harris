from fastapi import FastAPI
from get_teams_by_conference_division import get_teams_by_conference_division

app = FastAPI()

@app.get("/teams")
def read_teams(conference: str = None, division: str = None):
    return get_teams_by_conference_division(conference, division)

@app.get("/")
def home():
    return {"message": "NFL Playoffs API is running"}