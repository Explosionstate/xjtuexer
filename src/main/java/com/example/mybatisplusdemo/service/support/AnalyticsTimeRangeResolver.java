package com.example.mybatisplusdemo.service.support;

import org.springframework.util.StringUtils;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.time.temporal.TemporalAdjusters;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Resolve analytics time filters in a backward-compatible way.
 * Priority: explicit date range > month > year > quick range > (optional) semester fallback.
 */
public final class AnalyticsTimeRangeResolver {

    private static final Pattern YEAR_PATTERN = Pattern.compile("^(\\d{4})$");
    private static final Pattern MONTH_PATTERN = Pattern.compile("^(\\d{4})-(\\d{1,2})$");
    private static final Pattern TERM_CODE_PATTERN = Pattern.compile("^(\\d{4})-(FALL|SPRING)$", Pattern.CASE_INSENSITIVE);
    private static final Pattern ACADEMIC_PREFIX_PATTERN = Pattern.compile("^(\\d{4})-(\\d{4})");

    private static final String FIRST_TERM_CN = "\u7B2C\u4E00";
    private static final String SECOND_TERM_CN = "\u7B2C\u4E8C";

    private AnalyticsTimeRangeResolver() {
    }

    public static ResolvedTimeRange resolve(String semester,
                                            String year,
                                            String month,
                                            String startDate,
                                            String endDate,
                                            String quickRange) {
        return resolveInternal(semester, year, month, startDate, endDate, quickRange, false);
    }

    public static ResolvedTimeRange resolveWithSemesterFallback(String semester,
                                                                String year,
                                                                String month,
                                                                String startDate,
                                                                String endDate,
                                                                String quickRange) {
        return resolveInternal(semester, year, month, startDate, endDate, quickRange, true);
    }

    private static ResolvedTimeRange resolveInternal(String semester,
                                                     String year,
                                                     String month,
                                                     String startDate,
                                                     String endDate,
                                                     String quickRange,
                                                     boolean semesterFallback) {
        SemesterResolution semesterResolution = resolveSemester(normalize(semester));
        String normalizedSemester = semesterResolution.filterValue();
        LocalDate parsedStart = parseDate(startDate);
        LocalDate parsedEnd = parseDate(endDate);

        if (parsedStart != null || parsedEnd != null) {
            return new ResolvedTimeRange(
                    normalizedSemester,
                    formatDate(parsedStart),
                    formatDate(parsedEnd)
            );
        }

        DateRange byMonthOrYear = resolveByMonthOrYear(normalize(year), normalize(month));
        if (byMonthOrYear != null) {
            return new ResolvedTimeRange(
                    normalizedSemester,
                    formatDate(byMonthOrYear.start()),
                    formatDate(byMonthOrYear.end())
            );
        }

        DateRange byQuickRange = resolveByQuickRange(normalize(quickRange));
        if (byQuickRange != null) {
            return new ResolvedTimeRange(
                    normalizedSemester,
                    formatDate(byQuickRange.start()),
                    formatDate(byQuickRange.end())
            );
        }

        if (semesterFallback && semesterResolution.dateRange() != null) {
            DateRange bySemester = semesterResolution.dateRange();
            return new ResolvedTimeRange(
                    normalizedSemester,
                    formatDate(bySemester.start()),
                    formatDate(bySemester.end())
            );
        }

        if (semesterFallback && StringUtils.hasText(normalizedSemester)) {
            DateRange bySemester = resolveBySemesterFallback(normalizedSemester);
            if (bySemester != null) {
                return new ResolvedTimeRange(
                        normalizedSemester,
                        formatDate(bySemester.start()),
                        formatDate(bySemester.end())
                );
            }
        }

        return new ResolvedTimeRange(normalizedSemester, null, null);
    }

    private static DateRange resolveByMonthOrYear(String year, String month) {
        if (StringUtils.hasText(month)) {
            Matcher monthMatcher = MONTH_PATTERN.matcher(month);
            if (monthMatcher.matches()) {
                int y = Integer.parseInt(monthMatcher.group(1));
                int m = Integer.parseInt(monthMatcher.group(2));
                if (m >= 1 && m <= 12) {
                    YearMonth ym = YearMonth.of(y, m);
                    return new DateRange(ym.atDay(1), ym.atEndOfMonth());
                }
            }
            if (StringUtils.hasText(year)) {
                Matcher yearMatcher = YEAR_PATTERN.matcher(year);
                Matcher monthOnlyMatcher = Pattern.compile("^(\\d{1,2})$").matcher(month);
                if (yearMatcher.matches() && monthOnlyMatcher.matches()) {
                    int y = Integer.parseInt(yearMatcher.group(1));
                    int m = Integer.parseInt(monthOnlyMatcher.group(1));
                    if (m >= 1 && m <= 12) {
                        YearMonth ym = YearMonth.of(y, m);
                        return new DateRange(ym.atDay(1), ym.atEndOfMonth());
                    }
                }
            }
        }

        if (StringUtils.hasText(year)) {
            Matcher yearMatcher = YEAR_PATTERN.matcher(year);
            if (yearMatcher.matches()) {
                int y = Integer.parseInt(yearMatcher.group(1));
                return new DateRange(LocalDate.of(y, 1, 1), LocalDate.of(y, 12, 31));
            }
        }

        return null;
    }

    private static DateRange resolveByQuickRange(String quickRange) {
        if (!StringUtils.hasText(quickRange)) {
            return null;
        }
        String normalized = quickRange.trim().toLowerCase(Locale.ROOT);
        LocalDate today = LocalDate.now();
        return switch (normalized) {
            case "day", "today" -> new DateRange(today, today);
            case "week", "weak" -> {
                LocalDate start = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                LocalDate end = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
                yield new DateRange(start, end);
            }
            case "month" -> new DateRange(today.withDayOfMonth(1), today.withDayOfMonth(today.lengthOfMonth()));
            case "year" -> new DateRange(today.withDayOfYear(1), today.withDayOfYear(today.lengthOfYear()));
            default -> null;
        };
    }

    private static SemesterResolution resolveSemester(String semester) {
        if (!StringUtils.hasText(semester)) {
            return new SemesterResolution(null, null);
        }
        String normalized = semester.trim()
                .replace('\uFF0D', '-')
                .replace('\u2014', '-');

        Matcher codeMatcher = TERM_CODE_PATTERN.matcher(normalized);
        if (codeMatcher.matches()) {
            int year = Integer.parseInt(codeMatcher.group(1));
            String flag = codeMatcher.group(2).toUpperCase(Locale.ROOT);
            DateRange range = "FALL".equals(flag)
                    ? new DateRange(LocalDate.of(year, 9, 1), LocalDate.of(year + 1, 1, 31))
                    : new DateRange(LocalDate.of(year, 2, 1), LocalDate.of(year, 8, 31));
            return new SemesterResolution(year + "-" + flag, range);
        }

        Matcher prefixMatcher = ACADEMIC_PREFIX_PATTERN.matcher(normalized);
        if (!prefixMatcher.find()) {
            return new SemesterResolution(normalized, null);
        }

        int startYear = Integer.parseInt(prefixMatcher.group(1));
        int endYear = Integer.parseInt(prefixMatcher.group(2));
        if (endYear != startYear + 1) {
            return new SemesterResolution(normalized, null);
        }

        String lowercase = normalized.toLowerCase(Locale.ROOT);
        boolean firstTerm = lowercase.contains("first")
                || lowercase.contains("fall")
                || normalized.contains(FIRST_TERM_CN);
        boolean secondTerm = lowercase.contains("second")
                || lowercase.contains("spring")
                || normalized.contains(SECOND_TERM_CN);

        if (firstTerm && !secondTerm) {
            return new SemesterResolution(
                    startYear + "-FALL",
                    new DateRange(LocalDate.of(startYear, 9, 1), LocalDate.of(endYear, 1, 31))
            );
        }
        if (secondTerm && !firstTerm) {
            return new SemesterResolution(
                    endYear + "-SPRING",
                    new DateRange(LocalDate.of(endYear, 2, 1), LocalDate.of(endYear, 8, 31))
            );
        }

        return new SemesterResolution(
                normalized,
                new DateRange(LocalDate.of(startYear, 9, 1), LocalDate.of(endYear, 8, 31))
        );
    }

    private static DateRange resolveBySemesterFallback(String semester) {
        SemesterResolution resolution = resolveSemester(semester);
        if (resolution.dateRange() != null) {
            return resolution.dateRange();
        }
        Matcher codeMatcher = TERM_CODE_PATTERN.matcher(semester);
        if (!codeMatcher.matches()) {
            return null;
        }
        int year = Integer.parseInt(codeMatcher.group(1));
        String flag = codeMatcher.group(2).toUpperCase(Locale.ROOT);
        if ("FALL".equals(flag)) {
            return new DateRange(LocalDate.of(year, 9, 1), LocalDate.of(year + 1, 1, 31));
        }
        return new DateRange(LocalDate.of(year, 2, 1), LocalDate.of(year, 8, 31));
    }

    private static LocalDate parseDate(String raw) {
        String normalized = normalize(raw);
        if (!StringUtils.hasText(normalized)) {
            return null;
        }
        try {
            return LocalDate.parse(normalized);
        } catch (DateTimeParseException ignored) {
            return null;
        }
    }

    private static String formatDate(LocalDate date) {
        return date == null ? null : date.toString();
    }

    private static String normalize(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private record DateRange(LocalDate start, LocalDate end) {
    }

    private record SemesterResolution(String filterValue, DateRange dateRange) {
    }

    public record ResolvedTimeRange(String semester, String startDate, String endDate) {
    }
}