CREATE DATABASE HospitalManagementSystem;

USE HospitalManagmentSystem;
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    contact_number VARCHAR(15),
    address VARCHAR(255),
    email VARCHAR(100),
    medical_history TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_patient_name (last_name, first_name)
);
CREATE TABLE Doctors(
	Doctor_id int auto_increment primary key,
    first_name varchar(50)not null,
    last_name varchar(50) not null,
    specialty varchar(50) not null,
    contact_number varchar(15) not null,
	email  varchar(50) unique,
    available_schedule varchar(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
     INDEX idx_specialty (specialty)
);
CREATE TABLE Departments(
	department_id int auto_increment primary key,
    department_name varchar(50),
    location varchar(100)
);
CREATE TABLE DoctorDepartment (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(Doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,  
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    purpose VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE SET NULL,
    INDEX idx_appointment_date (appointment_date, appointment_time)
);
CREATE TABLE Medical_Records(
	record_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int null,
    appointment_id int null,
    diagnosis varchar(255),
    treatment varchar(255),
    prescripotion varchar(255),
    created_at datetime default current_timestamp,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE SET NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE NO ACTION,

    INDEX idx_record_patient (patient_id)
);
CREATE TABLE Billing (
    bill_id INT auto_increment primary key,
    patient_id INT NOT NULL,
    appointment_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    payment_date DATE,
    insurance_provider VARCHAR(100),
    created_at datetime default current_timestamp,

    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE NO ACTION,

    INDEX idx_payment_status (payment_status)
);
CREATE TABLE Staff (
    staff_id INT auto_increment primary key,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(20) NOT NULL CHECK (role IN ('Nurse', 'Worker', 'Admin', 'Pharmacist', 'Technician', 'Lab Assistant', 'Driver')),
    department_id INT,
    contact_number varchar(15),
    email VARCHAR(50),
    address TEXT,
    hire_date DATE,

    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL,

    INDEX idx_staff_role (role)
);
CREATE TABLE Nurses (
    nurse_id INT auto_increment primary key,
    staff_id INT NOT NULL,
    specialization VARCHAR(50),
    shift_hours VARCHAR(255),

    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);
CREATE TABLE Workers (
    worker_id INT auto_increment primary key,
    staff_id INT,
    job_title VARCHAR(50),
    work_schedule VARCHAR(255),

    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);
CREATE TABLE Medicine (
    medicine_id INT auto_increment primary key,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    type VARCHAR(20) CHECK (type IN ('Tablet', 'Capsule', 'Liquid', 'Injection', 'Ointment')),
    dosage VARCHAR(50),
    stock_quantity INT CHECK (stock_quantity >= 0),
    expiry_date DATE,
    created_at DATETIME DEFAULT current_timestamp
);
CREATE TABLE Pharmacy (
    pharmacy_id INT auto_increment primary key,
    medicine_id INT,
    patient_id INT,
    quantity INT,
    prescription_date DATE,

    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE
);
CREATE TABLE Blood_Bank (
    blood_id INT auto_increment primary key,
    blood_type VARCHAR(3) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    stock_quantity INT CHECK (stock_quantity >= 0),
    last_updated DATE,

    INDEX idx_blood_type (blood_type)
);
CREATE TABLE Room_Types (
    room_type_id INT auto_increment primary key,
    room_type_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);
CREATE TABLE Rooms (
    room_id INT auto_increment primary key,
    room_number VARCHAR(10) UNIQUE NOT NULL,  
    room_type_id INT,                         
    capacity INT,                             
    status VARCHAR(20) CHECK (status IN ('Available', 'Occupied', 'Under Maintenance')),  
    last_serviced DATE,                       

    FOREIGN KEY (room_type_id) REFERENCES Room_Types(room_type_id) ON DELETE SET NULL
);
CREATE TABLE Room_Assignments (
    assignment_id INT auto_increment primary key,
    room_id INT,
    staff_id INT NULL,
    patient_id INT NULL,
    assignment_date DATETIME DEFAULT current_timestamp,
    end_date DATETIME NULL,                  
    
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE SET NULL
);
CREATE TABLE Cleaning_Service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    service_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    staff_id INT,
    notes VARCHAR(255),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE Prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    prescription_date datetime default current_timestamp,
    medication_name VARCHAR(100),
    dosage VARCHAR(100),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    notes VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
CREATE TABLE Ambulance (
    ambulance_id INT auto_increment primary key,
    ambulance_number VARCHAR(10) UNIQUE,
    availability VARCHAR(15) CHECK (availability IN ('Available', 'On Duty', 'Maintenance')),
    driver_id INT NULL,  
    last_service_date DATE,

    FOREIGN KEY (driver_id) REFERENCES Staff(staff_id) ON DELETE NO ACTION
);
CREATE TABLE Ambulance_Log (
    log_id INT auto_increment primary key,
    ambulance_id INT,
    patient_id INT,
    pickup_location VARCHAR(100),
    dropoff_location VARCHAR(100),
    pickup_time DATETIME,
    dropoff_time DATETIME,
    status VARCHAR(15) CHECK (status IN ('Completed', 'In Progress', 'Canceled')),

    FOREIGN KEY (ambulance_id) REFERENCES Ambulance(ambulance_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,

	INDEX idx_log_status (status)
);


CREATE TABLE Medical_Records_Medicine (
    record_id INT,
    medicine_id INT,
    dosage VARCHAR(50),

    PRIMARY KEY (record_id, medicine_id),
    FOREIGN KEY (record_id) REFERENCES Medical_Records(record_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id) ON DELETE CASCADE
);
CREATE INDEX idx_doctor_specialty ON Doctors(specialty);
CREATE INDEX idx_billing_status ON Billing(payment_status);
CREATE INDEX idx_medicine_type ON Medicine (type);
CREATE INDEX idx_medicine_expiry ON Medicine (expiry_date);




    
    






