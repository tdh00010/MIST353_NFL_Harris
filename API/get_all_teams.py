from get_db_connection import get_db_connection

def get_all_teams():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("{call procGetAllTeams}")
    rows = cursor.fetchall()

    results = [
        {
            "TeamID": row.TeamID,
            "TeamName": row.TeamName
        }
        for row in rows
    ]

    cursor.close()
    conn.close()

    return {"data": results}