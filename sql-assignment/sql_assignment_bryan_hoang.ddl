USE university;

SELECT
  course_id,
  sec_id,
  semester,
  room_no,
  year
FROM
  section
WHERE
  year >= 2008;

SELECT
  d.dept_name,
  building,
  course_id,
  title
FROM
  department d,
  course c
WHERE
  d.dept_name = c.dept_name;

SELECT
  course_id
FROM
  instructor i,
  teaches t
WHERE
  i.id = t.id
  AND i.name = 'Crick';

SELECT
  i.name AS Instructor,
  s.name AS Student
FROM
  instructor i,
  advisor a,
  student s
WHERE
  i.id = a.i_id
  AND a.s_id = s.id;

SELECT
  name,
  course_id,
  grade
FROM
  student s,
  takes t
WHERE
  s.id = t.id
  AND t.year = 2009
  AND (
    s.dept_name = 'Finance'
    OR s.dept_name = 'Physics'
  );

SELECT
  COUNT(course_id)
FROM
  student s,
  takes t
WHERE
  s.id = t.id
  AND s.name = 'Levy';

SELECT
  dept_name AS DeptName,
  COUNT(id) AS NumProfs,
  AVG(salary) AS AvgSalary
FROM
  instructor i
GROUP BY
  dept_name;

SELECT
  title,
  c.course_id AS 'Course',
  p.prereq_id AS 'Prerequisite Course'
FROM
  course c
  LEFT JOIN prereq p ON c.course_id = p.course_id;

SELECT
  course_id
FROM
  course
WHERE
  course_id IN (
    SELECT
      course_id
    FROM
      section
    WHERE
      year = 2009
      AND semester = 'Fall'
    INTERSECT
    SELECT
      course_id
    FROM
      takes
    WHERE
      year = 2010
      AND semester = 'Spring'
  );

SELECT
  name,
  salary
FROM
  instructor
WHERE
  salary > (
    SELECT
      AVG(salary)
    FROM
      instructor
  );
