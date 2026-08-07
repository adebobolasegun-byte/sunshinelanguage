# Paginated Lessons & Quick Assessments Plan

Transform the lesson presentation from a single scrollable page into an interactive, step-by-step learning experience with periodic assessments.

## User Review Required

> [!IMPORTANT]
> This change will shift the app from a "Read-Only" scrollable view to a "Step-by-Step" interactive view. Users will need to complete a quick assessment before moving to the next sub-topic.

- **Navigation**: We will use a `PageView`. A "Continue" button will appear at the bottom of each page.
- **Assessments**: After every sub-topic, a "Quick Check" page will appear with a simple question (e.g., "What does 'Guten Tag' mean?").
- **UI Scaling**: Sub-topic headers will be significantly enlarged (32pt+) to act as clear entry points for each page.

## Proposed Changes

### [Component Name] Pagination Logic
#### [MODIFY] [lesson_note_screen.dart](file:///C:/Users/DELL/AndroidStudioProjects/sunshinelanguage/lib/screens/lesson_note_screen.dart)
- Replace `SingleChildScrollView` with `PageView.builder`.
- Refactor `_getContentForWeek()` to return a `List<Widget>` instead of a single widget.
- Implement `_buildAssessmentPage(String topic)` helper.

### [Component Name] UI Enhancements
- **Headers**: Update `_buildSectionHeader` to use a larger font and potentially a background card style.
- **Progress**: Add a top progress bar (dots or linear) to show how far the learner is in the current week.

### [Component Name] Content Refactoring
- **Batch Refactor**: Convert the 60+ lesson builders to return page lists.
  - *Strategy*: Group existing `Column` children into discrete sub-topic pages.

## Verification Plan

### Automated Tests
- `flutter analyze` to ensure no syntax errors in the new `PageView` logic.
- Verify state management: ensures the "Ask AI" tutor still references the correct week.

### Manual Verification
- Test the flow: Content Page 1 -> Assessment 1 -> Content Page 2 -> Assessment 2.
- Verify that "Mark as Read" only appears at the very end of the last page.
- Check TTS: ensure the audio button still works on paginated content.
