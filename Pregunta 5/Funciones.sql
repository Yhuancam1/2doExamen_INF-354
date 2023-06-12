drop table nombre;
DROP FUNCTION obtener_nombres()
CREATE OR REPLACE FUNCTION obtener_nombres()
  RETURNS TABLE (_M_ int, _A_ int, _R_ int, _T_ int, _H_ int, _A__ int) AS
$$
DECLARE
  nombre1 varchar(20);
  nombre2 varchar(20);
  longitud int;
  caracter varchar(4);
  contador int;
  sqlp varchar(4000);
  columna varchar(3);
BEGIN
  nombre1 := 'martha';
  nombre2 := 'marta';
  SELECT LENGTH(nombre1) INTO longitud;

  contador := 1;
  sqlp := 'create table nombre (';

  WHILE contador <= longitud LOOP
    SELECT LEFT(nombre1, 1) INTO caracter;
    SELECT RIGHT(nombre1, LENGTH(nombre1) - 1) INTO nombre1;
    caracter := TRIM(caracter) || CAST(contador AS varchar(1));
    sqlp := sqlp || ' ' || caracter || ' int,';
    RAISE NOTICE '%', sqlp;
    contador := contador + 1;
  END LOOP;

  sqlp := LEFT(sqlp, LENGTH(sqlp) - 1);
  sqlp := sqlp || ')';
  EXECUTE sqlp;

  SELECT LENGTH(nombre2) INTO longitud;
  contador := 1;

  WHILE contador <= longitud LOOP
    SELECT LEFT(nombre2, 1) INTO caracter;
    SELECT RIGHT(nombre2, LENGTH(nombre2) - 1) INTO nombre2;
    caracter := TRIM(caracter);
    SELECT column_name INTO columna
    FROM information_schema.columns
    WHERE table_name = 'nombre'
      AND LEFT(column_name, 1) = caracter
      AND ordinal_position >= contador
    ORDER BY ordinal_position
    LIMIT 1;
    sqlp := 'insert into nombre(' || columna || ') values(1)';
    EXECUTE sqlp;
    contador := contador + 1;
  END LOOP;

  RETURN QUERY SELECT * FROM nombre;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM obtener_nombres();

