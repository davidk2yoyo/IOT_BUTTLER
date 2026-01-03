BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "location" text NOT NULL,
    "apiKeyHash" text NOT NULL,
    "status" text NOT NULL,
    "lastSeen" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sensor_reading" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "type" text NOT NULL,
    "value" double precision NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "alertTriggered" boolean NOT NULL
);


--
-- MIGRATION VERSION FOR iot_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('iot_butler', '20260103054631708', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260103054631708', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
