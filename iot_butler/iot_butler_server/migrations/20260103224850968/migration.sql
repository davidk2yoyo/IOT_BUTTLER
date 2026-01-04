BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "alert" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "severity" text NOT NULL,
    "message" text NOT NULL,
    "resolved" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "resolvedAt" timestamp without time zone
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN IF NOT EXISTS "userId" text;

--
-- MIGRATION VERSION FOR iot_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('iot_butler', '20260103224850968', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260103224850968', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();


COMMIT;
