-- Define aircraft table
-- Data types used SERIAL (for primary key only), VARCHAR, TIMESTAMP and
-- BOOLEAN. VARCHAR with no limit used in order to accept strings of any size
-- due to unknown lengths in dataset. VARCHAR only stores the characters in the
-- input string (it does not space-pad), so this is not detrimental to storage
-- or performance. See:
-- https://www.postgresql.org/docs/12/datatype-character.html
CREATE TABLE aircraft(
    db_key SERIAL PRIMARY KEY,
    icao24 VARCHAR,
    registration VARCHAR,
    manufacturericao VARCHAR,
    manufacturername VARCHAR,
    model VARCHAR,
    typecode VARCHAR,
    serialnumber VARCHAR,
    linenumber VARCHAR,
    icaoaircrafttype VARCHAR,
    operator VARCHAR,
    operatorcallsign VARCHAR,
    operatoricao VARCHAR,
    operatoriata VARCHAR,
    owner VARCHAR,
    testreg VARCHAR,
    registered TIMESTAMP,
    reguntil TIMESTAMP,
    status VARCHAR,
    built TIMESTAMP,
    firstflightdate TIMESTAMP,
    seatconfiguration VARCHAR,
    engines VARCHAR,
    modes BOOLEAN,
    adsb BOOLEAN,
    acars BOOLEAN,
    notes VARCHAR,
    categoryDescription VARCHAR
);

-- Copy data from csv
-- Dataset obtained from The OpenSky Network, http://www.opensky-network.org.
-- 'aircraftDatabase-2020-12.csv' downloaded from
-- https://opensky-network.org/datasets/metadata/ on 12/12/2020. FORCE_NULL
-- used to convert empty string to NULL to work with TIMESTAMP datatype.
COPY aircraft(
    icao24,
    registration,
    manufacturericao,
    manufacturername,
    model,
    typecode,
    serialnumber,
    linenumber,
    icaoaircrafttype,
    operator,
    operatorcallsign,
    operatoricao,
    operatoriata,
    owner,
    testreg,
    registered,
    reguntil,
    status,
    built,
    firstflightdate,
    seatconfiguration,
    engines,
    modes,
    adsb,
    acars,
    notes,
    categoryDescription
)
FROM
    '/home/gregm/CSVs/aircraftDatabase-2020-12.csv' WITH (
        FORMAT CSV,
        HEADER,
        FORCE_NULL(registered, reguntil, built, firstflightdate)
    );

-- Define air traffic table
-- Data types used SERIAL (for primary key only), VARCHAR, TIMESTAMP, TIMESTAMP
-- WITH TIMEZONE, DOUBLE PRECISION and REAL. VARCHAR with no limit used in order
-- to accept strings of anysize due to unknown lengths in dataset. VARCHAR
-- reasoning as aricraft table. DOUBLE PRECISON (15 decimal digits precision)
-- chosen for longitude and latitude. REAL (6 decimal digits precision) chosen
-- for altitude.
CREATE TABLE traffic(
    db_key SERIAL PRIMARY KEY,
    callsign VARCHAR,
    number VARCHAR,
    icao24 VARCHAR,
    registration VARCHAR,
    typecode VARCHAR,
    origin VARCHAR,
    destination VARCHAR,
    firstseen TIMESTAMP WITH TIME ZONE,
    lastseen TIMESTAMP WITH TIME ZONE,
    day TIMESTAMP,
    latitude_1 DOUBLE PRECISION,
    longitude_1 DOUBLE PRECISION,
    altitude_1 REAL,
    latitude_2 DOUBLE PRECISION,
    longitude_2 DOUBLE PRECISION,
    altitude_2 REAL
);

-- Copy monthly air traffic data from csv
-- Each of the following 12 statements copy air traffic data for 1 of the past
-- 12 months. Dataset obtained from The OpenSky Network, 
-- http://www.opensky-network.org.
-- Monthly flight list CSVs from 2019-12-01 until 2020-11-30 downloaded from
-- https://zenodo.org/record/4299837#.X9T0FVOeQUE on 12/12/2020. 
COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20191201_20191231.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200101_20200131.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200201_20200229.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200301_20200331.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200401_20200430.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200501_20200531.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200601_20200630.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200701_20200731.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200801_20200831.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20200901_20200930.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20201001_20201031.csv' WITH (FORMAT CSV, HEADER);

COPY traffic(
    callsign,
    number,
    icao24,
    registration,
    typecode,
    origin,
    destination,
    firstseen,
    lastseen,
    day,
    latitude_1,
    longitude_1,
    altitude_1,
    latitude_2,
    longitude_2,
    altitude_2
)
FROM
    '/home/gregm/CSVs/flightlist_20201101_20201130.csv' WITH (FORMAT CSV, HEADER);