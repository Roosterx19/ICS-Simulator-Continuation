-- 20260420213051_fix_polyhaven_hdri_urls.sql
-- Repairs Polyhaven HDRI URLs in scenario_skyboxes created before
-- lib/skybox/client.ts:73 was updated to the correct URL scheme.
--
-- Fix 1: move from deprecated /HDRIs/jpg/<res>/ to /HDRIs/extra/Tonemapped%20JPG/
-- Fix 2: strip _1k/_2k/_4k resolution suffix from slugs (the extra-JPG
--        archive stores one canonical size per slug, no suffix).
--
-- Affects file_url only. thumb_url already uses the correct
-- cdn.polyhaven.com path (verified: 0 stale thumbs).

BEGIN;

-- Pass 1: directory relocation
UPDATE public.scenario_skyboxes
SET file_url = regexp_replace(
      file_url,
      '/HDRIs/jpg/[^/]+/([^/?]+)\.jpg',
      '/HDRIs/extra/Tonemapped%20JPG/\1.jpg'
    ),
    updated_at = now()
WHERE file_url LIKE '%/HDRIs/jpg/%';

-- Pass 2: strip resolution suffix
UPDATE public.scenario_skyboxes
SET file_url = regexp_replace(
      file_url,
      '(/HDRIs/extra/Tonemapped%20JPG/[^/?]+?)_[124]k\.jpg',
      '\1.jpg'
    ),
    updated_at = now()
WHERE file_url ~ '/HDRIs/extra/Tonemapped%20JPG/[^/?]+_[124]k\.jpg';

COMMIT;
