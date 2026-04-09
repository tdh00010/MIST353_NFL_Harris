from get_db_connection import get_db_connection

def get_teams_for_specified_fan(nfl_fan_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "{call procGetTeamsForSpecifiedFan(?)}",
        (nfl_fan_id,)
    )

    rows = cursor.fetchall()

    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColor": row.TeamColor,
            "PrimaryTeam": row.PrimaryTeam
        }
        for row in rows
    ]

    cursor.close()
    conn.close()

    return {"data": results}