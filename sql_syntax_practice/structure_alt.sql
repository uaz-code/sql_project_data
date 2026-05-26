CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
    );


ALTER TABLE job_applied
ADD contact VARCHAR(50);

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;



