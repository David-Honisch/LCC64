SELECT '<h4>INSERT INTO importscripts</h4>';
INSERT OR REPLACE INTO other (first_name,name,url) 
values 
('.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat');
SELECT '<h1>IMPORT SQL SCRIPT LOADED</h1>';
--.separator "\t"
--.import .\\plugins.csv importscripts
--SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;

