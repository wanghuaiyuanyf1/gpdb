-- @author prabhd 
-- @created 2014-04-01 12:00:00
-- @modified 2012-04-01 12:00:00
-- @tags dml MPP-21090 ORCA
-- @optimizer_mode on	
-- @description Tests for MPP-21090
\echo --start_ignore
set gp_enable_column_oriented_table=on;
\echo --end_ignore
DROP TABLE IF EXISTS mpp21090_dropcol_splitdfpt_dml_float;
CREATE TABLE mpp21090_dropcol_splitdfpt_dml_float
(
    col1 float,
    col2 float,
    col3 char,
    col4 float,
    col5 int
) 
DISTRIBUTED by (col1)
PARTITION BY LIST(col2)
(
default partition def
);

INSERT INTO mpp21090_dropcol_splitdfpt_dml_float VALUES(2.00,2.00,'a',2.00,0);
SELECT * FROM mpp21090_dropcol_splitdfpt_dml_float ORDER BY 1,2,3,4;

ALTER TABLE mpp21090_dropcol_splitdfpt_dml_float DROP COLUMN col4;

ALTER TABLE mpp21090_dropcol_splitdfpt_dml_float SPLIT DEFAULT PARTITION at (5.00) into (partition partsplitone,partition def);

INSERT INTO mpp21090_dropcol_splitdfpt_dml_float SELECT 1.00, 1.00,'b', 1;
SELECT * FROM mpp21090_dropcol_splitdfpt_dml_float ORDER BY 1,2,3;

-- Update distribution key
UPDATE mpp21090_dropcol_splitdfpt_dml_float SET col1 = 35.00 WHERE col2 = 1.00 AND col1 = 1.00;
SELECT * FROM mpp21090_dropcol_splitdfpt_dml_float ORDER BY 1,2,3;

-- Update partition key
UPDATE mpp21090_dropcol_splitdfpt_dml_float SET col2 = 35.00 WHERE col2 = 1.00 AND col1 = 35.00;
SELECT * FROM mpp21090_dropcol_splitdfpt_dml_float ORDER BY 1,2,3;

DELETE FROM mpp21090_dropcol_splitdfpt_dml_float WHERE col3='b';
SELECT * FROM mpp21090_dropcol_splitdfpt_dml_float ORDER BY 1,2,3;
