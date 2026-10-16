# Quick Design Spec: Archivo typeface

**Type:** Tweak  
**System:** Exhibition UI typography  
**Date:** 2026-10-09  
**Reference:** `lib/core/theme/kifc_theme.dart`; no GDD or systems index is present in this Flutter project.

## Change

Use Archivo as the application typeface. Bundle Regular, Medium, SemiBold, Bold, and ExtraBold in the app and set Archivo in the global Flutter theme. Use Archivo Black on the opening titles only; use Archivo ExtraBold for chapter headings. Size the opening titles to fit a narrow portrait viewport. Keep text colors and game flow.

## Reason

The bundled typefaces keep Android and web consistent and available offline. Archivo gives instructions a clear, compact shape, while its heavier weights make key headings and buttons feel substantial on an exhibition screen. This replaces the earlier Plus Jakarta Sans selection after visual review.

## Acceptance

- Android and web resolve the same bundled fonts.
- Weights 400, 500, 600, 700, and 800 use their corresponding Archivo files.
- Opening titles use Archivo Black and chapter headings use Archivo ExtraBold.
- Game flow and layout behavior remain unchanged.

## Source and license

Font files are from Google Fonts' Archivo and Archivo Black directories and distributed under SIL OFL 1.1. Their licenses are stored separately at `assets/fonts/Archivo-OFL.txt` and `assets/fonts/ArchivoBlack-OFL.txt`.
