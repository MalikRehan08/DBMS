import streamlit as st
import mysql.connector

# Connect to the database
db_connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="malikrehan@1910",
    database="crime_record_management"
)

# Create a cursor object
cursor = db_connection.cursor()

# Function to get category ID based on category name
def get_category_id(category_name):
    cursor.execute("SELECT category_id FROM crime_categories WHERE name = %s", (category_name,))
    result = cursor.fetchone()
    if result:
        return result[0]
    else:
        st.error(f"Category '{category_name}' not found.")
        return None

# Function to get team ID based on team name
def get_team_id(team_name):
    cursor.execute("SELECT investigation_team_id FROM investigation_teams WHERE name = %s", (team_name,))
    result = cursor.fetchone()
    if result:
        return result[0]
    else:
        st.error(f"Team '{team_name}' not found.")
        return None

# Streamlit UI
st.title("Crime Record Management System")

# User Authentication
username = st.text_input("Username:")
password = st.text_input("Password:", type="password")
login_button = st.button("Login")

if login_button:
    # Perform user authentication based on your requirements
    # You might want to query a 'users' table for authentication

    # Placeholder authentication (change this based on your implementation)
    if username == "admin_user" and password == "admin_password":
        st.success("Login successful!")
        # Add code to show the main application after a successful login
    else:
        st.error("Login failed. Please check your credentials.")

# Displaying Data
st.header("View Crimes")
cursor.execute("SELECT * FROM crimes")
crimes_data = cursor.fetchall()
st.table(crimes_data)

# Check if the trigger already exists
def check_trigger_exists(update_status):
    cursor.execute(f"SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_name = '{update_status}'")
    result = cursor.fetchone()
    return result[0] > 0

# Adding Crimes
st.header("Add New Crime")
crime_category = st.selectbox("Crime Category", ["Assault", "Robbery", "Burglary", "Murder", "Kidnapping", "Arson", "Vandalism", "Drug Trafficking", "Cybercrime", "Terrorism"])
investigation_team = st.selectbox("Investigation Team", ["Alpha Team", "Beta Team", "Gamma Team", "Delta Team", "Ruby Team", "Aqua Team", "Theta Team", "Epsilon Team", "Omega Team"])
date_opened = st.date_input("Date Opened", value=None)
date_closed = st.date_input("Date Closed", value=None)
location = st.text_input("Location")
status = st.selectbox("Status", ["Open", "Closed"])
add_crime_button = st.button("Add Crime")

if add_crime_button:
    try:
        # Convert category and team names to corresponding IDs
        category_id = get_category_id(crime_category)
        team_id = get_team_id(investigation_team)

        # Insert the new crime record
        cursor.execute("""
        INSERT INTO crimes (category_id, investigation_team_id, date_opened, date_closed, location, status)
        VALUES (%s, %s, %s, %s, %s, %s)
        """, (category_id, team_id, date_opened, date_closed, location, status))

        # Commit the transaction
        db_connection.commit()

        st.success("Crime added successfully!")
    except Exception as e:
        st.error(f"Error adding crime: {e}")

# Function to update crime details
def update_crime(crime_id, new_location, new_date_opened, new_date_closed, new_status):
    cursor.execute("""
        UPDATE crimes
        SET location = %s, date_opened = %s, date_closed = %s, status = %s
        WHERE crime_id = %s
    """, (new_location, new_date_opened, new_date_closed, new_status, crime_id))
    db_connection.commit()

# Function to delete a crime
def delete_crime(crime_id):
    cursor.execute("DELETE FROM crimes WHERE crime_id = %s", (crime_id,))
    db_connection.commit()

# UI section for updating crime details
st.header("Update Crime Details")
crime_id_to_update = st.number_input("Enter Crime ID to Update", min_value=1, step=1)
new_location = st.text_input("New Location")
new_date_opened = st.date_input("New Date Opened")
new_date_closed = st.date_input("New Date Closed")
new_status = st.selectbox("New Status", ["Open", "Closed"])

update_button = st.button("Update Crime")

if update_button:
    # Call the function to update crime details
    update_crime(crime_id_to_update, new_location, new_date_opened, new_date_closed, new_status)
    st.success("Crime details updated successfully!")

# UI section for deleting a crime
st.header("Delete Crime")

crime_id_to_delete = st.number_input("Enter Crime ID to Delete", min_value=1, step=1)
delete_button = st.button("Delete Crime")

if delete_button:
    # Call the function to delete a crime
    delete_crime(crime_id_to_delete)
    st.success("Crime deleted successfully!")


# Function

def calculate_average_age(category_name):
    cursor.execute(f"SELECT calculate_average_victim_age('{category_name}') AS avg_age")
    result = cursor.fetchone()
    average_age = result[0]
    return average_age

st.header("Function: Average Victim Age")
category_name = st.selectbox("Select Crime Category", ["Assault", "Robbery", "Burglary", "Murder", "Kidnapping", "Arson", "Vandalism", "Drug Trafficking", "Cybercrime", "Terrorism"])

# Button to trigger the function
if st.button("Calculate Average Age"):
    # Call the function when the button is clicked
    average_age_result = calculate_average_age(category_name)
    st.write(f"The average age of victims for the '{category_name}' category is: {average_age_result}")


#JOIN query

st.header("Join Query: Crime Information with Victims and Suspects")

# Placeholder to store the results
join_query_results = None
# Function to execute the JOIN query
def execute_join_query():
    global join_query_results
    query = """
        SELECT 
            crimes.crime_id,
            crimes.category_id,
            crime_categories.name AS crime_category,
            crimes.investigation_team_id,
            investigation_teams.name AS investigation_team,
            crimes.date_opened,
            crimes.date_closed,
            crimes.location,
            crimes.status,
            GROUP_CONCAT(DISTINCT victims.name SEPARATOR ', ') AS victim_names,
            GROUP_CONCAT(DISTINCT suspects.name SEPARATOR ', ') AS suspect_names
        FROM 
            crimes
        JOIN 
            crime_categories ON crimes.category_id = crime_categories.category_id
        JOIN 
            investigation_teams ON crimes.investigation_team_id = investigation_teams.investigation_team_id
        LEFT JOIN 
            crime_victims ON crimes.crime_id = crime_victims.crime_id
        LEFT JOIN 
            victims ON crime_victims.victim_id = victims.victim_id
        LEFT JOIN 
            crime_suspects ON crimes.crime_id = crime_suspects.crime_id
        LEFT JOIN 
            suspects ON crime_suspects.suspect_id = suspects.suspect_id
        GROUP BY 
            crimes.crime_id;
    """
    cursor.execute(query)
    join_query_results = cursor.fetchall()

# Button to execute the JOIN query
if st.button("Execute Join Query"):
    execute_join_query()
# Display the results in a table
if join_query_results is not None:
    st.table(join_query_results)


# Aggregate Query

st.header("Aggregate Query: Total Number of Crimes by Category")
# Placeholder to store the results
aggregate_query_results = None

# Function to execute the Aggregate Query
def execute_aggregate_query():
    global aggregate_query_results
    aggregate_query = """
        SELECT 
            crime_categories.name AS crime_category,
            COUNT(crimes.crime_id) AS total_crimes
        FROM 
            crimes
        JOIN 
            crime_categories ON crimes.category_id = crime_categories.category_id
        GROUP BY 
            crime_categories.name;
    """
    cursor.execute(aggregate_query)
    aggregate_query_results = cursor.fetchall()

# Button to execute the Aggregate Query
if st.button("Execute Aggregate Query"):
    execute_aggregate_query()
# Display the results in a table
if aggregate_query_results is not None:
    st.table(aggregate_query_results)


# Nested Query

st.header("Nested Query: Crimes with Average Victim Age Greater Than 30")
# Placeholder to store the results
nested_query_results = None

# Function to execute the Nested Query
def execute_nested_query():
    global nested_query_results
    nested_query = """
        SELECT 
            crimes.crime_id,
            crimes.location,
            crimes.date_opened,
            crimes.date_closed,
            crimes.status
        FROM 
            crimes
        WHERE 
            (
                SELECT AVG(YEAR(CURDATE()) - YEAR(v.birthday))
                FROM 
                    crime_victims cv
                JOIN 
                    victims v ON cv.victim_id = v.victim_id
                WHERE 
                    cv.crime_id = crimes.crime_id
            ) > 30;
    """
    cursor.execute(nested_query)
    nested_query_results = cursor.fetchall()

# Button to execute the Nested Query
if st.button("Execute Nested Query"):
    execute_nested_query()
# Display the results in a table
if nested_query_results is not None:
    st.table(nested_query_results)


# Close the database connection
cursor.close()
db_connection.close()
