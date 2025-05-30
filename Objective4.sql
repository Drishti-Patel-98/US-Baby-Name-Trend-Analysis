/*
1. Find the 10 most popular androgynous names (names given to both females and males)
*/
SELECT NAME 
	 , COUNT(DISTINCT GENDER) AS NO_OF_GENDERS
	 , SUM(BIRTHS) AS NO_OF_BABIES
FROM NAMES
GROUP BY NAME
HAVING NO_OF_GENDERS = 2
ORDER BY NO_OF_BABIES DESC
LIMIT 10
;

/* 
2. Find the length of the shortest and longest names, 
   and identify the most popular short names (those with the fewest characters) 
   and long names (those with the most characters)
*/
-- STEP 1. FIND THE LENGTH OF THE SHORTEST NAMES
SELECT NAME, LENGTH(NAME) AS LENGTH
FROM NAMES
WHERE LENGTH(NAME) = (SELECT MIN(LENGTH(NAME)) FROM NAMES)
;

-- STEP 2. FIND THE LENGTH OF THE LONGEST NAMES
SELECT NAME, LENGTH(NAME) AS LENGTH
FROM NAMES
WHERE LENGTH(NAME) = (SELECT MAX(LENGTH(NAME)) FROM NAMES)
;

-- STEP 3. MOST POPULAR SHORT NAME
SELECT NAME, SUM(BIRTHS) AS NO_OF_BABIES
FROM NAMES
WHERE LENGTH(NAME) = (SELECT MIN(LENGTH(NAME)) FROM NAMES)
GROUP BY NAME
ORDER BY NO_OF_BABIES DESC
LIMIT 1;

-- STEP 4. MOST POPULAR LONG NAME
SELECT NAME, SUM(BIRTHS) AS NO_OF_BABIES
FROM NAMES
WHERE LENGTH(NAME) = (SELECT MAX(LENGTH(NAME)) FROM NAMES)
GROUP BY NAME
ORDER BY NO_OF_BABIES DESC
LIMIT 1;

/*
3. The founder of Maven Analytics is named Chris. 
   Find the state with the highest percent of babies named "Chris"
*/
-- STEP 1. CREATE A VIEW HAVING NUMBER OF CHRIS IN EACH STATE
CREATE OR REPLACE VIEW NO_OF_CHRIS AS
SELECT STATE, SUM(BIRTHS) AS NO_OF_CHRIS
FROM NAMES
WHERE UPPER(NAME) = 'CHRIS'
GROUP BY STATE;

-- STEP 2. CREATE A VIEW HAVING NUMBER OF BABIES IN EACH STATE
CREATE OR REPLACE VIEW NO_OF_BABIES AS
SELECT STATE, SUM(BIRTHS) AS NO_OF_BABIES
FROM NAMES
GROUP BY STATE;

-- STEP 3.Find the state with the highest percent of babies named "Chris"
SELECT T1.STATE, (NO_OF_CHRIS/NO_OF_BABIES)*100 AS PERCENTAGE
FROM NO_OF_CHRIS T1 INNER JOIN NO_OF_BABIES T2
  ON T1.STATE = T2.STATE
ORDER BY PERCENTAGE DESC
;
