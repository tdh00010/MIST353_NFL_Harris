from pathlib import Path
import sys

import pyodbc

from get_db_connection import get_db_connection


LOGO_DIR = Path(__file__).resolve().parent / "TeamLogos"


def print_permission_help(error):
    print("Could not insert logos because the database login is missing permission.")
    print("Run the TeamLogo section in Data/DatabaseProgrammingObjectsHarris.sql")
    print("using a database owner/admin account, then run this script again.")
    print(f"SQL Server said: {error}")

def insert_logos():
    teams = [
        "Baltimore Ravens",
        "Cincinnati Bengals",
        "Cleveland Browns",
        "Pittsburgh Steelers",
        "New England Patriots",
        "Tampa Bay Buccaneers"
    ]

    conn = get_db_connection()
    cursor = conn.cursor()

    for team in teams:
        filepath = LOGO_DIR / f"{team.replace(' ', '_')}.png"

        with open(filepath, "rb") as image_file:
            logo_data = image_file.read()

        cursor.execute(
            "{CALL dbo.procUpdateTeamLogo(?, ?)}",
            (team, logo_data)
        )

    conn.commit()
    cursor.close()
    conn.close()

    print("Logos inserted successfully.")

if __name__ == "__main__":
    try:
        insert_logos()
    except pyodbc.ProgrammingError as error:
        print_permission_help(error)
        sys.exit(1)
