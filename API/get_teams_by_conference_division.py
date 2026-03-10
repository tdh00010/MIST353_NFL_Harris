from get_db_connection import get_db_connection

def get_teams_by_conference_division(conference, division):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC procGetTeamsByConferenceDDivision @ConferenceName=?, @DivisionName=?", conference, division)
    teams = cursor.fetchall()
    cursor.close()
    return teams