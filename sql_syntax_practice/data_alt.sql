INSERT INTO job_applied 
    (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status 
    )
    
VALUES 

    (1,
    '2026-05-01',
     true,
     'resume_01.pdf',
     true,
     'cover_letter_01.pdf',
     'submitted'
    ),

    (2,
    '2026-05-02',
     false,
     'resume_02.pdf',
     false,
     'cover_letter_02.pdf',
     NULL
     ),

    (3,
    '2026-05-03',
     true,
     'resume_03.pdf',
     true,
     'cover_letter_03.pdf',
     NULL
     ),

    (4,
    '2026-05-04',
     true,
     'resume_04.pdf',
     false,
     'cover_letter_04.pdf',
     'ghoasted'
     ),

    (5,
    '2026-05-05',
     false,
     'resume_05.pdf',
     true,
     'cover_letter_05.pdf',
     'rejected');


--.........................................

UPDATE job_applied
SET contact = 'Adam Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Sarah Dean'
WHERE job_id = 2;

UPDATE job_applied
SET contact = CASE
    WHEN job_id = 3 THEN 'Emma Bell'
    WHEN job_id = 4 THEN 'Sarah Lee'
    WHEN job_id = 5 THEN 'Jam Smith'
    
END
WHERE job_id IN (3,4,5);
--....................................

