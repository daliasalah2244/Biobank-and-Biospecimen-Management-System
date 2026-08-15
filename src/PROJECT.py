from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysqldb import MySQL

app = Flask(__name__)
app.secret_key = "biobank_secret_key"

# Database Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''  # Enter your MySQL password
app.config['MYSQL_DB'] = 'BiobankDB'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# ==============================================================================
# 1. DONORS (donors)
# ==============================================================================
@app.route('/')
@app.route('/donors')
def donors():
    cur = mysql.connection.cursor()
    cur.execute("SELECT donor_id, first_name, last_name, gender, date_of_birth, blood_type, email, created_at FROM donors")
    donors_data = cur.fetchall()
    cur.close()
    return render_template('donors.html', donors=donors_data)

@app.route('/donor/insert', methods=['POST'])
def donor_insert():
    if request.method == "POST":
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        gender = request.form['gender']
        date_of_birth = request.form['date_of_birth']
        blood_type = request.form['blood_type']
        email = request.form['email']

        cur = mysql.connection.cursor()
        cur.execute("SELECT donor_id FROM donors WHERE email = %s", (email,))
        if cur.fetchone():
            flash(f"Error: Email {email} is already registered.", "danger")
            cur.close()
            return redirect(url_for('donors'))

        cur.execute(
            "INSERT INTO donors (first_name, last_name, gender, date_of_birth, blood_type, email) VALUES (%s, %s, %s, %s, %s, %s)",
            (first_name, last_name, gender, date_of_birth, blood_type, email)
        )
        mysql.connection.commit()
        cur.close()
        flash("Donor Registered Successfully", "success")
        return redirect(url_for('donors'))

@app.route('/donor/update', methods=['POST'])
def donor_update():
    if request.method == 'POST':
        donor_id = request.form['donor_id']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        gender = request.form['gender']
        date_of_birth = request.form['date_of_birth']
        blood_type = request.form['blood_type']
        email = request.form['email']

        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE donors SET first_name=%s, last_name=%s, gender=%s, date_of_birth=%s, blood_type=%s, email=%s WHERE donor_id=%s",
            (first_name, last_name, gender, date_of_birth, blood_type, email, donor_id)
        )
        mysql.connection.commit()
        cur.close()
        flash("Donor Profile Updated Successfully", "success")
        return redirect(url_for('donors'))

@app.route('/donor/delete/<int:donor_id>', methods=['GET'])
def donor_delete(donor_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM donors WHERE donor_id=%s", (donor_id,))
    mysql.connection.commit()
    cur.close()
    flash("Donor Deleted Successfully", "success")
    return redirect(url_for('donors'))


# ==============================================================================
# 2. BIOSPECIMENS (biospecimens)
# ==============================================================================
@app.route('/biospecimens')
def biospecimens():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT b.specimen_id, b.donor_id, b.sample_type_id, b.collection_date, b.initial_volume_ml, b.status,
               CONCAT(d.first_name, ' ', d.last_name) AS donor_name, st.type_name
        FROM biospecimens b
        JOIN donors d ON b.donor_id = d.donor_id
        JOIN sample_types st ON b.sample_type_id = st.sample_type_id
    """)
    specimens_data = cur.fetchall()

    cur.execute("SELECT donor_id, CONCAT(first_name, ' ', last_name) AS full_name FROM donors")
    donor_options = cur.fetchall()

    cur.execute("SELECT sample_type_id, type_name FROM sample_types")
    sample_type_options = cur.fetchall()
    cur.close()

    return render_template('biospecimens.html', biospecimens=specimens_data, donors=donor_options, sample_types=sample_type_options)

@app.route('/biospecimen/insert', methods=['POST'])
def biospecimen_insert():
    if request.method == "POST":
        donor_id = request.form['donor_id']
        sample_type_id = request.form['sample_type_id']
        collection_date = request.form['collection_date']
        initial_volume_ml = request.form['initial_volume_ml']
        status = request.form.get('status', 'Available')

        cur = mysql.connection.cursor()
        cur.execute(
            "INSERT INTO biospecimens (donor_id, sample_type_id, collection_date, initial_volume_ml, status) VALUES (%s, %s, %s, %s, %s)",
            (donor_id, sample_type_id, collection_date, initial_volume_ml, status)
        )
        mysql.connection.commit()
        cur.close()
        flash("Biospecimen Registered Successfully", "success")
        return redirect(url_for('biospecimens'))

@app.route('/biospecimen/update', methods=['POST'])
def biospecimen_update():
    if request.method == 'POST':
        specimen_id = request.form['specimen_id']
        donor_id = request.form['donor_id']
        sample_type_id = request.form['sample_type_id']
        collection_date = request.form['collection_date']
        initial_volume_ml = request.form['initial_volume_ml']
        status = request.form['status']

        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE biospecimens SET donor_id=%s, sample_type_id=%s, collection_date=%s, initial_volume_ml=%s, status=%s WHERE specimen_id=%s",
            (donor_id, sample_type_id, collection_date, initial_volume_ml, status, specimen_id)
        )
        mysql.connection.commit()
        cur.close()
        flash("Biospecimen Updated Successfully", "success")
        return redirect(url_for('biospecimens'))

@app.route('/biospecimen/delete/<int:specimen_id>', methods=['GET'])
def biospecimen_delete(specimen_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM biospecimens WHERE specimen_id=%s", (specimen_id,))
    mysql.connection.commit()
    cur.close()
    flash("Biospecimen Record Deleted", "success")
    return redirect(url_for('biospecimens'))


# ==============================================================================
# 3. STORAGE LOCATIONS (storage_locations)
# ==============================================================================
@app.route('/storage')
def storage():
    cur = mysql.connection.cursor()
    cur.execute("SELECT location_id, freezer_name, shelf_number, box_number, capacity FROM storage_locations")
    storage_data = cur.fetchall()
    cur.close()

    return render_template('storage.html', storage_locations=storage_data)

@app.route('/storage/insert', methods=['POST'])
def storage_insert():
    if request.method == "POST":
        freezer_name = request.form['freezer_name']
        shelf_number = request.form['shelf_number']
        box_number = request.form['box_number']
        capacity = request.form.get('capacity', 100)

        cur = mysql.connection.cursor()
        cur.execute(
            "INSERT INTO storage_locations (freezer_name, shelf_number, box_number, capacity) VALUES (%s, %s, %s, %s)",
            (freezer_name, shelf_number, box_number, capacity)
        )
        mysql.connection.commit()
        cur.close()
        flash("Storage Location Created", "success")
        return redirect(url_for('storage'))

@app.route('/storage/update', methods=['POST'])
def storage_update():
    if request.method == 'POST':
        location_id = request.form['location_id']
        freezer_name = request.form['freezer_name']
        shelf_number = request.form['shelf_number']
        box_number = request.form['box_number']
        capacity = request.form['capacity']

        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE storage_locations SET freezer_name=%s, shelf_number=%s, box_number=%s, capacity=%s WHERE location_id=%s",
            (freezer_name, shelf_number, box_number, capacity, location_id)
        )
        mysql.connection.commit()
        cur.close()
        flash("Storage Details Updated", "success")
        return redirect(url_for('storage'))

@app.route('/storage/delete/<int:location_id>', methods=['GET'])
def storage_delete(location_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM storage_locations WHERE location_id=%s", (location_id,))
    mysql.connection.commit()
    cur.close()
    flash("Storage Location Removed", "success")
    return redirect(url_for('storage'))


if __name__ == '__main__':
    app.run(debug=True)