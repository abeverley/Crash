-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Sep 28 18:53:11 2019
-- 
;
--
-- Table: casualty
--
CREATE TABLE "casualty" (
  "id" serial NOT NULL,
  "crash_id" integer,
  "casualty_class" integer,
  "casualty_mode" integer,
  "severity" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "casualty_idx_crash_id" on "casualty" ("crash_id");

;
--
-- Table: crash
--
CREATE TABLE "crash" (
  "id" serial NOT NULL,
  "reference" character varying(32),
  "easting" integer NOT NULL,
  "northing" integer NOT NULL,
  "location" text,
  "severity" smallint,
  "date" timestamp,
  PRIMARY KEY ("id")
);
CREATE INDEX "crash_idx_reference" on "crash" ("reference");

;
--
-- Table: vehicle
--
CREATE TABLE "vehicle" (
  "id" serial NOT NULL,
  "crash_id" integer,
  "vehicle_type" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "vehicle_idx_crash_id" on "vehicle" ("crash_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "casualty" ADD CONSTRAINT "casualty_fk_crash_id" FOREIGN KEY ("crash_id")
  REFERENCES "crash" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE;

;
ALTER TABLE "vehicle" ADD CONSTRAINT "vehicle_fk_crash_id" FOREIGN KEY ("crash_id")
  REFERENCES "crash" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE;

;
