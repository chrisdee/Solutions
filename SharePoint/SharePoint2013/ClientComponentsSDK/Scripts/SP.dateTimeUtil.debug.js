Type.registerNamespace('SP.DateTimeUtil');
SP.DateTimeUtil.SPCalendarType = function() {
};
SP.DateTimeUtil.SPCalendarType.prototype = {
    none: 0,
    gregorian: 1,
    japan: 3,
    taiwan: 4,
    korea: 5,
    hijri: 6,
    thai: 7,
    hebrew: 8,
    gregorianMEFrench: 9,
    gregorianArabic: 10,
    gregorianXLITEnglish: 11,
    gregorianXLITFrench: 12,
    koreaJapanLunar: 14,
    chineseLunar: 15,
    sakaEra: 16,
    umAlQura: 23
};
SP.DateTimeUtil.SPCalendarType.registerEnum('SP.DateTimeUtil.SPCalendarType', false);
SP.DateTimeUtil.ISPCalendar = function() {
};
SP.DateTimeUtil.ISPCalendar.registerInterface('SP.DateTimeUtil.ISPCalendar');
SP.DateTimeUtil.GregorianCalendarImpl = function SP_DateTimeUtil_GregorianCalendarImpl() {
    SP.DateTimeUtil.GregorianCalendarImpl.initializeBase(this);
};
SP.DateTimeUtil.GregorianCalendarImpl.$6 = function SP_DateTimeUtil_GregorianCalendarImpl$$6() {
    return SP.DateTimeUtil.SolarCalendarImpl.$6();
};
SP.DateTimeUtil.GregorianCalendarImpl.$8 = function SP_DateTimeUtil_GregorianCalendarImpl$$8($p0) {
    return SP.DateTimeUtil.SolarCalendarImpl.$8($p0);
};
SP.DateTimeUtil.GregorianCalendarImpl.$M = function SP_DateTimeUtil_GregorianCalendarImpl$$M($p0, $p1, $p2) {
    return SP.DateTimeUtil.GregorianCalendarImpl.$r($p0) + SP.DateTimeUtil.GregorianCalendarImpl.$7[SP.DateTimeUtil.SolarCalendarImpl.$8($p0) ? 1 : 0][$p1 - 1] + $p2 - 1;
};
SP.DateTimeUtil.GregorianCalendarImpl.$r = function SP_DateTimeUtil_GregorianCalendarImpl$$r($p0) {
    var $v_0 = $p0 - 1601;

    return 365 * $v_0 + Math.floor($v_0 / 4) - Math.floor($v_0 / 100) + Math.floor($v_0 / 400);
};
SP.DateTimeUtil.GregorianCalendarImpl.$K = function SP_DateTimeUtil_GregorianCalendarImpl$$K($p0) {
    var $v_0 = $p0;
    var $v_1 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);
    var $v_2;

    $v_1.set_year(Math.floor(1601 + ($v_0 * 400 + 600) / SP.DateTimeUtil.SolarCalendarImpl._DaysIn400Years));
    $v_0 -= SP.DateTimeUtil.GregorianCalendarImpl.$r($v_1.get_year());
    if ($v_0 < 0) {
        $v_1.set_year($v_1.get_year() - 1);
        $v_2 = SP.DateTimeUtil.GregorianCalendarImpl.$8($v_1.get_year());
        $v_0 += $v_2 ? 366 : 365;
    }
    else {
        $v_2 = SP.DateTimeUtil.GregorianCalendarImpl.$8($v_1.get_year());
    }
    $v_1.set_month(1 + ($v_0 >> 5));
    if ($v_1.get_month() < SP.DateTimeUtil.SolarCalendarImpl._MonthsInYear && $v_0 >= SP.DateTimeUtil.GregorianCalendarImpl.$7[$v_2 ? 1 : 0][$v_1.get_month()]) {
        $v_1.set_month($v_1.get_month() + 1);
    }
    $v_1.set_day(1 + $v_0 - SP.DateTimeUtil.GregorianCalendarImpl.$7[$v_2 ? 1 : 0][$v_1.get_month() - 1]);
    return $v_1;
};
SP.DateTimeUtil.GregorianCalendarImpl.$A = function SP_DateTimeUtil_GregorianCalendarImpl$$A($p0, $p1) {
    var $v_0 = SP.DateTimeUtil.GregorianCalendarImpl.$8($p0);

    return SP.DateTimeUtil.GregorianCalendarImpl.$7[$v_0 ? 1 : 0][$p1] - SP.DateTimeUtil.GregorianCalendarImpl.$7[$v_0 ? 1 : 0][$p1 - 1];
};
SP.DateTimeUtil.SPIntlCal = function SP_DateTimeUtil_SPIntlCal() {
};
SP.DateTimeUtil.SPIntlCal.get_$1Y = function SP_DateTimeUtil_SPIntlCal$get_$1Y() {
    if (!SP.DateTimeUtil.SPIntlCal.$c) {
        SP.DateTimeUtil.SPIntlCal.$c = new SP.DateTimeUtil.SPGregorianCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$c;
};
SP.DateTimeUtil.SPIntlCal.get_$1k = function SP_DateTimeUtil_SPIntlCal$get_$1k() {
    if (!SP.DateTimeUtil.SPIntlCal.$f) {
        SP.DateTimeUtil.SPIntlCal.$f = new SP.DateTimeUtil.SPJapaneseCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$f;
};
SP.DateTimeUtil.SPIntlCal.get_$1w = function SP_DateTimeUtil_SPIntlCal$get_$1w() {
    if (!SP.DateTimeUtil.SPIntlCal.$j) {
        SP.DateTimeUtil.SPIntlCal.$j = new SP.DateTimeUtil.SPTaiwaneseCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$j;
};
SP.DateTimeUtil.SPIntlCal.get_$1m = function SP_DateTimeUtil_SPIntlCal$get_$1m() {
    if (!SP.DateTimeUtil.SPIntlCal.$h) {
        SP.DateTimeUtil.SPIntlCal.$h = new SP.DateTimeUtil.SPKoreanCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$h;
};
SP.DateTimeUtil.SPIntlCal.get_$1s = function SP_DateTimeUtil_SPIntlCal$get_$1s() {
    if (!SP.DateTimeUtil.SPIntlCal.$i) {
        SP.DateTimeUtil.SPIntlCal.$i = new SP.DateTimeUtil.SPSakaCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$i;
};
SP.DateTimeUtil.SPIntlCal.get_$1a = function SP_DateTimeUtil_SPIntlCal$get_$1a() {
    if (!SP.DateTimeUtil.SPIntlCal.$e) {
        SP.DateTimeUtil.SPIntlCal.$e = new SP.DateTimeUtil.SPHijriCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$e;
};
SP.DateTimeUtil.SPIntlCal.get_$1Z = function SP_DateTimeUtil_SPIntlCal$get_$1Z() {
    if (!SP.DateTimeUtil.SPIntlCal.$d) {
        SP.DateTimeUtil.SPIntlCal.$d = new SP.DateTimeUtil.SPHebrewCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$d;
};
SP.DateTimeUtil.SPIntlCal.get_$1x = function SP_DateTimeUtil_SPIntlCal$get_$1x() {
    if (!SP.DateTimeUtil.SPIntlCal.$k) {
        SP.DateTimeUtil.SPIntlCal.$k = new SP.DateTimeUtil.SPThaiCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$k;
};
SP.DateTimeUtil.SPIntlCal.get_$1R = function SP_DateTimeUtil_SPIntlCal$get_$1R() {
    if (!SP.DateTimeUtil.SPIntlCal.$Z) {
        SP.DateTimeUtil.SPIntlCal.$Z = new SP.DateTimeUtil.SPChineseLunarCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$Z;
};
SP.DateTimeUtil.SPIntlCal.get_$1l = function SP_DateTimeUtil_SPIntlCal$get_$1l() {
    if (!SP.DateTimeUtil.SPIntlCal.$g) {
        SP.DateTimeUtil.SPIntlCal.$g = new SP.DateTimeUtil.SPJapaneseLunarCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$g;
};
SP.DateTimeUtil.SPIntlCal.get_$1z = function SP_DateTimeUtil_SPIntlCal$get_$1z() {
    if (!SP.DateTimeUtil.SPIntlCal.$l) {
        SP.DateTimeUtil.SPIntlCal.$l = new SP.DateTimeUtil.SPUmAlQuraCalendar();
    }
    return SP.DateTimeUtil.SPIntlCal.$l;
};
SP.DateTimeUtil.SPIntlCal.isCalendarSupported = function SP_DateTimeUtil_SPIntlCal$isCalendarSupported(calType) {
    try {
        SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType);
        return true;
    }
    catch ($$e_1) { }
    return false;
};
SP.DateTimeUtil.SPIntlCal.getLocalCalendar = function SP_DateTimeUtil_SPIntlCal$getLocalCalendar(calType) {
    switch (calType) {
    case 1:
    case 9:
    case 10:
    case 11:
    case 12:
        return SP.DateTimeUtil.SPIntlCal.get_$1Y();
    case 3:
        return SP.DateTimeUtil.SPIntlCal.get_$1k();
    case 4:
        return SP.DateTimeUtil.SPIntlCal.get_$1w();
    case 5:
        return SP.DateTimeUtil.SPIntlCal.get_$1m();
    case 16:
        return SP.DateTimeUtil.SPIntlCal.get_$1s();
    case 6:
        return SP.DateTimeUtil.SPIntlCal.get_$1a();
    case 8:
        return SP.DateTimeUtil.SPIntlCal.get_$1Z();
    case 7:
        return SP.DateTimeUtil.SPIntlCal.get_$1x();
    case 15:
        return SP.DateTimeUtil.SPIntlCal.get_$1R();
    case 14:
        return SP.DateTimeUtil.SPIntlCal.get_$1l();
    case 23:
        return SP.DateTimeUtil.SPIntlCal.get_$1z();
    default:
        throw Error.argument();
    }
};
SP.DateTimeUtil.SPIntlCal.isSupportedLocalYear = function SP_DateTimeUtil_SPIntlCal$isSupportedLocalYear(calType, year) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isSupportedYear(year);
};
SP.DateTimeUtil.SPIntlCal.isSupportedLocalMonth = function SP_DateTimeUtil_SPIntlCal$isSupportedLocalMonth(calType, year, month) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isSupportedMonth(year, month);
};
SP.DateTimeUtil.SPIntlCal.isSupportedLocalDate = function SP_DateTimeUtil_SPIntlCal$isSupportedLocalDate(calType, di) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isSupportedDate(di);
};
SP.DateTimeUtil.SPIntlCal.isLocalDateValid = function SP_DateTimeUtil_SPIntlCal$isLocalDateValid(calType, di) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isDateValid(di, 0, 0);
};
SP.DateTimeUtil.SPIntlCal.isSupportedLocalJulianDay = function SP_DateTimeUtil_SPIntlCal$isSupportedLocalJulianDay(calType, jDay) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isSupportedJulianDay(jDay);
};
SP.DateTimeUtil.SPIntlCal.localToJulianDay = function SP_DateTimeUtil_SPIntlCal$localToJulianDay(calType, di) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).dateToJulianDay(di, 0);
};
SP.DateTimeUtil.SPIntlCal.julianDayToLocal = function SP_DateTimeUtil_SPIntlCal$julianDayToLocal(calType, jDay) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).julianDayToDate(jDay, 0, 0);
};
SP.DateTimeUtil.SPIntlCal.julianDayToLocal2 = function SP_DateTimeUtil_SPIntlCal$julianDayToLocal2(calType, jDay, iAdvance) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).julianDayToDate(jDay, iAdvance, 0);
};
SP.DateTimeUtil.SPIntlCal.eraOffset = function SP_DateTimeUtil_SPIntlCal$eraOffset(calType, era) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).getEraOffset(era);
};
SP.DateTimeUtil.SPIntlCal.getEraJulianDay = function SP_DateTimeUtil_SPIntlCal$getEraJulianDay(calType, era) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).getEraJulianDay(era);
};
SP.DateTimeUtil.SPIntlCal.isLocalYearLeap = function SP_DateTimeUtil_SPIntlCal$isLocalYearLeap(calType, year) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).isYearLeap(year, 0);
};
SP.DateTimeUtil.SPIntlCal.monthsInLocalYear = function SP_DateTimeUtil_SPIntlCal$monthsInLocalYear(calType, di) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).monthsInYear(di);
};
SP.DateTimeUtil.SPIntlCal.daysInLocalMonth = function SP_DateTimeUtil_SPIntlCal$daysInLocalMonth(calType, di) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).daysInMonth(di, 0);
};
SP.DateTimeUtil.SPIntlCal.getMonthLeap = function SP_DateTimeUtil_SPIntlCal$getMonthLeap(calType, year) {
    return (SP.DateTimeUtil.SPIntlCal.getLocalCalendar(calType)).getMonthLeap(year);
};
SP.DateTimeUtil.SPIntlCal.getWeekNumber = function SP_DateTimeUtil_SPIntlCal$getWeekNumber(calType, di, FirstDayOfWeek, FirstWeekOfYear) {
    var $v_0 = di.get_day();
    var $v_1 = di.get_month();
    var $v_2;

    while (--$v_1 > 0) {
        var $v_6 = new SP.DateTimeUtil.SimpleDate(di.get_year(), $v_1, 1, di.get_era());

        $v_0 += SP.DateTimeUtil.SPIntlCal.daysInLocalMonth(calType, $v_6);
    }
    var $v_3 = new SP.DateTimeUtil.SimpleDate(di.get_year(), 1, 1, di.get_era());
    var $v_4 = SP.DateTimeUtil.SPIntlCal.localToJulianDay(calType, $v_3);
    var $v_5 = ($v_4 + 1) % 7;

    $v_2 = Math.floor(($v_0 - 1) / 7 + 1);
    if ($v_5 < FirstDayOfWeek) {
        $v_5 += 7;
    }
    if (FirstDayOfWeek < 7 && FirstDayOfWeek >= 0 && (FirstWeekOfYear === 2 && $v_5 > FirstDayOfWeek + 3 || FirstWeekOfYear === 1 && $v_5 !== FirstDayOfWeek)) {
        $v_2--;
    }
    return $v_2;
};
SP.DateTimeUtil.SPGregorianCalendar = function SP_DateTimeUtil_SPGregorianCalendar() {
};
SP.DateTimeUtil.SPGregorianCalendar.prototype = {
    isSupportedYear: function SP_DateTimeUtil_SPGregorianCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1601, 8900);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPGregorianCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1601, 1, 8900, 12) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPGregorianCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1601, 1, 1, 8900, 12, 31) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPGregorianCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month()));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPGregorianCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 0 && $p0 <= 2666269;
    },
    dateToJulianDay: function SP_DateTimeUtil_SPGregorianCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedDate($p0)) {
            throw Error.argumentOutOfRange();
        }
        return SP.DateTimeUtil.GregorianCalendarImpl.$M($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month(), $p0.get_day());
    },
    julianDayToDate: function SP_DateTimeUtil_SPGregorianCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        var $v_0 = SP.DateTimeUtil.GregorianCalendarImpl.$K($p0);

        $v_0.set_year($v_0.get_year() - this.getEraOffset($v_0.get_era()));
        $v_0.set_era(1);
        return $v_0;
    },
    getMonthLeap: function SP_DateTimeUtil_SPGregorianCalendar$getMonthLeap($p0) {
        return -1;
    },
    isYearLeap: function SP_DateTimeUtil_SPGregorianCalendar$isYearLeap($p0, $p1) {
        if (!this.isSupportedYear($p0)) {
            throw Error.argumentOutOfRange();
        }
        return SP.DateTimeUtil.GregorianCalendarImpl.$8($p0 + this.getEraOffset($p1));
    },
    monthsInYear: function SP_DateTimeUtil_SPGregorianCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    daysInMonth: function SP_DateTimeUtil_SPGregorianCalendar$daysInMonth($p0, $p1) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        return SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month());
    },
    getEraOffset: function SP_DateTimeUtil_SPGregorianCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPGregorianCalendar$getEraJulianDay($p0) {
        return 1;
    }
};
SP.DateTimeUtil.SPJapaneseCalendar = function SP_DateTimeUtil_SPJapaneseCalendar() {
    this.$N_1 = [97770, 113800, 119061, 141721];
    SP.DateTimeUtil.SPJapaneseCalendar.initializeBase(this);
};
SP.DateTimeUtil.SPJapaneseCalendar.prototype = {
    isSupportedYear: function SP_DateTimeUtil_SPJapaneseCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1, 2011);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPJapaneseCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1, 1, 2011, 12) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPJapaneseCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1, 1, 1, 2011, 12, 31) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPJapaneseCalendar$isDateValid($p0, $p1, $p2) {
        var $v_0;

        try {
            $v_0 = this.dateToJulianDay($p0, 0);
        }
        catch ($$e_4) {
            return false;
        }
        return $p0.get_year() > 0 && ($p0.get_era() > 3 ? true : $p0.get_year() <= this.getEraOffset($p0.get_era() + 1) - this.getEraOffset($p0.get_era()) + 1) && ($p0.get_era() > 3 ? $v_0 >= this.$N_1[$p0.get_era() - 1] : $v_0 < this.$N_1[$p0.get_era()] && $v_0 >= this.$N_1[$p0.get_era() - 1]) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6() && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month()));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPJapaneseCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 97770 && $p0 <= 876215;
    },
    julianDayToDate: function SP_DateTimeUtil_SPJapaneseCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        var $v_0 = SP.DateTimeUtil.GregorianCalendarImpl.$K($p0);

        $v_0.set_era(this.$1U_1($p0));
        $v_0.set_year($v_0.get_year() - this.getEraOffset($v_0.get_era()));
        return $v_0;
    },
    getEraOffset: function SP_DateTimeUtil_SPJapaneseCalendar$getEraOffset($p0) {
        var $v_0 = [1867, 1911, 1925, 1988];

        if ($p0 <= 4 && $p0 > 0) {
            return $v_0[$p0 - 1];
        }
        else {
            return $v_0[0];
        }
    },
    getEraJulianDay: function SP_DateTimeUtil_SPJapaneseCalendar$getEraJulianDay($p0) {
        if ($p0 <= 3 && $p0 > 0) {
            return this.$N_1[$p0];
        }
        else {
            return this.$N_1[0];
        }
    },
    $1U_1: function SP_DateTimeUtil_SPJapaneseCalendar$$1U_1($p0) {
        for (var $v_0 = 4; $v_0 > 0; --$v_0) {
            if ($p0 >= this.$N_1[$v_0 - 1]) {
                return $v_0;
            }
        }
        return 1;
    }
};
SP.DateTimeUtil.SPThaiCalendar = function SP_DateTimeUtil_SPThaiCalendar() {
    SP.DateTimeUtil.SPThaiCalendar.initializeBase(this);
};
SP.DateTimeUtil.SPThaiCalendar.prototype = {
    isSupportedYear: function SP_DateTimeUtil_SPThaiCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 2144, 4542);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPThaiCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 2144, 1, 4542, 12) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPThaiCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 2144, 1, 1, 4542, 12, 31) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPThaiCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month()));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPThaiCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 0 && $p0 <= 876215;
    },
    getEraOffset: function SP_DateTimeUtil_SPThaiCalendar$getEraOffset($p0) {
        return -543;
    }
};
SP.DateTimeUtil.SPTaiwaneseCalendar = function SP_DateTimeUtil_SPTaiwaneseCalendar() {
    SP.DateTimeUtil.SPTaiwaneseCalendar.initializeBase(this);
};
SP.DateTimeUtil.SPTaiwaneseCalendar.prototype = {
    isSupportedYear: function SP_DateTimeUtil_SPTaiwaneseCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1, 2088);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPTaiwaneseCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1, 1, 2088, 12) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPTaiwaneseCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1, 1, 1, 2088, 12, 31) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPTaiwaneseCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month()));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPTaiwaneseCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 113589 && $p0 <= 876215;
    },
    getEraOffset: function SP_DateTimeUtil_SPTaiwaneseCalendar$getEraOffset($p0) {
        return 1911;
    }
};
SP.DateTimeUtil.SPKoreanCalendar = function SP_DateTimeUtil_SPKoreanCalendar() {
    SP.DateTimeUtil.SPKoreanCalendar.initializeBase(this);
};
SP.DateTimeUtil.SPKoreanCalendar.prototype = {
    isSupportedYear: function SP_DateTimeUtil_SPKoreanCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 3934, 6332);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPKoreanCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 3934, 1, 6332, 12) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPKoreanCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 3934, 1, 1, 6332, 12, 31) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPKoreanCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= SP.DateTimeUtil.GregorianCalendarImpl.$A($p0.get_year() + this.getEraOffset($p0.get_era()), $p0.get_month()));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPKoreanCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 0 && $p0 <= 876215;
    },
    getEraOffset: function SP_DateTimeUtil_SPKoreanCalendar$getEraOffset($p0) {
        return -2333;
    }
};
SP.DateTimeUtil.SPSakaCalendar = function SP_DateTimeUtil_SPSakaCalendar() {
    this.$0_0 = new SP.DateTimeUtil.SakaCalendarImpl();
};
SP.DateTimeUtil.SPSakaCalendar.prototype = {
    $0_0: null,
    isSupportedYear: function SP_DateTimeUtil_SPSakaCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1522, 3921);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPSakaCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1522, 11, 3921, 9) && $p1 >= 1 && $p1 <= SP.DateTimeUtil.SolarCalendarImpl.$6();
    },
    isSupportedDate: function SP_DateTimeUtil_SPSakaCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1522, 11, 1, 3921, 9, 30) && $p0.get_month() >= 1 && $p0.get_month() <= SP.DateTimeUtil.SolarCalendarImpl.$6();
    },
    isDateValid: function SP_DateTimeUtil_SPSakaCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= this.daysInMonth($p0, 0));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPSakaCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 20 && $p0 <= 876205;
    },
    dateToJulianDay: function SP_DateTimeUtil_SPSakaCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedDate($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$M_1($p0.get_year(), $p0.get_month(), $p0.get_day());
    },
    julianDayToDate: function SP_DateTimeUtil_SPSakaCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$K_1($p0);
    },
    daysInMonth: function SP_DateTimeUtil_SPSakaCalendar$daysInMonth($p0, $p1) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$A_1($p0.get_year(), $p0.get_month());
    },
    getMonthLeap: function SP_DateTimeUtil_SPSakaCalendar$getMonthLeap($p0) {
        return -1;
    },
    isYearLeap: function SP_DateTimeUtil_SPSakaCalendar$isYearLeap($p0, $p1) {
        return SP.DateTimeUtil.SakaCalendarImpl.$8($p0);
    },
    monthsInYear: function SP_DateTimeUtil_SPSakaCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return SP.DateTimeUtil.GregorianCalendarImpl.$6();
    },
    getEraOffset: function SP_DateTimeUtil_SPSakaCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPSakaCalendar$getEraJulianDay($p0) {
        return 1;
    }
};
SP.DateTimeUtil.SPHijriCalendar = function SP_DateTimeUtil_SPHijriCalendar() {
    this.$0_0 = new SP.DateTimeUtil.HijriCalendarImpl();
};
SP.DateTimeUtil.SPHijriCalendar.isSupportedAdvance = function SP_DateTimeUtil_SPHijriCalendar$isSupportedAdvance($p0) {
    return $p0 >= SP.DateTimeUtil.SPHijriCalendar.$1J && $p0 <= 3;
};
SP.DateTimeUtil.SPHijriCalendar.prototype = {
    $0_0: null,
    isSupportedYear: function SP_DateTimeUtil_SPHijriCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1009, 3482);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPHijriCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1009, 7, 3482, 1) && $p1 >= 1 && $p1 <= this.$0_0.$6_0();
    },
    isSupportedDate: function SP_DateTimeUtil_SPHijriCalendar$isSupportedDate($p0) {
        return this.isSupportedAdvanceDate($p0, 0);
    },
    isSupportedAdvanceDate: function SP_DateTimeUtil_SPHijriCalendar$isSupportedAdvanceDate($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1009, 7, 1, 3482, 1, 30) && $p0.get_month() >= 1 && $p0.get_month() <= this.$0_0.$6_0();
    },
    isDateValid: function SP_DateTimeUtil_SPHijriCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedAdvanceDate($p0, $p1) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= this.daysInMonth3($p0, $p1, $p2));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPHijriCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 4 && $p0 <= 876204;
    },
    dateToJulianDay: function SP_DateTimeUtil_SPHijriCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedAdvanceDate($p0, $p1)) {
            throw Error.argumentOutOfRange();
        }
        if (!SP.DateTimeUtil.SPHijriCalendar.isSupportedAdvance($p1)) {
            throw Error.argumentOutOfRange();
        }
        var $v_0 = this.$0_0.$n_0();

        return this.$0_0.$M_0($p0.get_year(), $p0.get_month(), $p0.get_day(), $p1, $v_0);
    },
    julianDayToDate: function SP_DateTimeUtil_SPHijriCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        if (!SP.DateTimeUtil.SPHijriCalendar.isSupportedAdvance($p1)) {
            throw Error.argumentOutOfRange();
        }
        if ($p1 && $p2 && !this.isSupportedJulianDay($p2)) {
            throw Error.argumentOutOfRange();
        }
        $p2 = this.$0_0.$n_0();
        return this.$0_0.$K_0($p0, $p1, $p2);
    },
    daysInMonth3: function SP_DateTimeUtil_SPHijriCalendar$daysInMonth3($p0, $p1, $p2) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        if (!SP.DateTimeUtil.SPHijriCalendar.isSupportedAdvance($p1)) {
            throw Error.argumentOutOfRange();
        }
        if ($p1 && $p2 && !this.isSupportedJulianDay($p2)) {
            throw Error.argumentOutOfRange();
        }
        var $v_0 = this.$0_0.$n_0();

        return this.$0_0.$A_0($p0.get_year(), $p0.get_month(), $p1, $v_0);
    },
    daysInMonth: function SP_DateTimeUtil_SPHijriCalendar$daysInMonth($p0, $p1) {
        var $v_0 = 0;

        return this.daysInMonth3($p0, $p1, $v_0);
    },
    monthsInYear: function SP_DateTimeUtil_SPHijriCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$6_0();
    },
    getMonthLeap: function SP_DateTimeUtil_SPHijriCalendar$getMonthLeap($p0) {
        return -1;
    },
    isYearLeap: function SP_DateTimeUtil_SPHijriCalendar$isYearLeap($p0, $p1) {
        return this.$0_0.$8_0($p0);
    },
    getEraOffset: function SP_DateTimeUtil_SPHijriCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPHijriCalendar$getEraJulianDay($p0) {
        return 1;
    }
};
SP.DateTimeUtil.SPHebrewCalendar = function SP_DateTimeUtil_SPHebrewCalendar() {
    this.$0_0 = new SP.DateTimeUtil.HebrewCalendarImpl();
};
SP.DateTimeUtil.SPHebrewCalendar.prototype = {
    $0_0: null,
    isSupportedYear: function SP_DateTimeUtil_SPHebrewCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 5361, 5999);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPHebrewCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 5361, 5, 5999, 13) && $p1 >= 1 && $p1 <= this.$0_0.$6_0($p0);
    },
    isSupportedDate: function SP_DateTimeUtil_SPHebrewCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 5361, 5, 1, 5999, 13, 30) && $p0.get_month() >= 1 && $p0.get_month() <= this.$0_0.$6_0($p0.get_year());
    },
    isDateValid: function SP_DateTimeUtil_SPHebrewCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= this.daysInMonth($p0, 0));
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPHebrewCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 3 && $p0 <= 233296;
    },
    dateToJulianDay: function SP_DateTimeUtil_SPHebrewCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedDate($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$M_0($p0.get_year(), $p0.get_month(), $p0.get_day());
    },
    julianDayToDate: function SP_DateTimeUtil_SPHebrewCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$K_0($p0);
    },
    getMonthLeap: function SP_DateTimeUtil_SPHebrewCalendar$getMonthLeap($p0) {
        return this.$0_0.$1V_0($p0);
    },
    isYearLeap: function SP_DateTimeUtil_SPHebrewCalendar$isYearLeap($p0, $p1) {
        return this.$0_0.$6_0($p0) === 13;
    },
    monthsInYear: function SP_DateTimeUtil_SPHebrewCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$6_0($p0.get_year());
    },
    daysInMonth: function SP_DateTimeUtil_SPHebrewCalendar$daysInMonth($p0, $p1) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$A_0($p0.get_year(), $p0.get_month());
    },
    getEraOffset: function SP_DateTimeUtil_SPHebrewCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPHebrewCalendar$getEraJulianDay($p0) {
        return 1;
    }
};
SP.DateTimeUtil.SPFarEastLunarCalendar = function SP_DateTimeUtil_SPFarEastLunarCalendar($p0) {
    this.$0_0 = $p0;
};
SP.DateTimeUtil.SPFarEastLunarCalendar.prototype = {
    $0_0: null,
    isSupportedYear: function SP_DateTimeUtil_SPFarEastLunarCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1960, 2049);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPFarEastLunarCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1960, 1, 2049, 12) && $p1 >= 1 && $p1 <= this.$0_0.$6_0($p0);
    },
    isSupportedDate: function SP_DateTimeUtil_SPFarEastLunarCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1960, 1, 1, 2049, 12, 7) && $p0.get_month() >= 1 && $p0.get_month() <= this.$0_0.$6_0($p0.get_year());
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPFarEastLunarCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 131148 && $p0 <= 163994;
    },
    getMonthLeap: function SP_DateTimeUtil_SPFarEastLunarCalendar$getMonthLeap($p0) {
        return this.$0_0.getMonthLeap($p0);
    },
    isYearLeap: function SP_DateTimeUtil_SPFarEastLunarCalendar$isYearLeap($p0, $p1) {
        return this.$0_0.$6_0($p0) === 13;
    },
    getEraOffset: function SP_DateTimeUtil_SPFarEastLunarCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPFarEastLunarCalendar$getEraJulianDay($p0) {
        return 1;
    },
    dateToJulianDay: function SP_DateTimeUtil_SPFarEastLunarCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedDate($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$M_0($p0.get_year(), $p0.get_month(), $p0.get_day(), this.$0_0.$$d_$1o_0);
    },
    julianDayToDate: function SP_DateTimeUtil_SPFarEastLunarCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$K_0($p0, this.$0_0.$$d_$1o_0);
    },
    monthsInYear: function SP_DateTimeUtil_SPFarEastLunarCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$6_0($p0.get_year());
    },
    daysInMonth: function SP_DateTimeUtil_SPFarEastLunarCalendar$daysInMonth($p0, $p1) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$A_0($p0.get_year(), $p0.get_month(), this.$0_0.$$d_$1o_0);
    },
    isDateValid: function SP_DateTimeUtil_SPFarEastLunarCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= this.daysInMonth($p0, 0));
    }
};
SP.DateTimeUtil.SPChineseLunarCalendar = function SP_DateTimeUtil_SPChineseLunarCalendar() {
    SP.DateTimeUtil.SPChineseLunarCalendar.initializeBase(this, [new SP.DateTimeUtil.ChineseLunarCalendarImpl()]);
};
SP.DateTimeUtil.SPJapaneseLunarCalendar = function SP_DateTimeUtil_SPJapaneseLunarCalendar() {
    SP.DateTimeUtil.SPJapaneseLunarCalendar.initializeBase(this, [new SP.DateTimeUtil.JapaneseLunarCalendarImpl()]);
};
SP.DateTimeUtil.SPUmAlQuraCalendar = function SP_DateTimeUtil_SPUmAlQuraCalendar() {
    this.$0_0 = new SP.DateTimeUtil.UmAlQuraCalendarImpl();
};
SP.DateTimeUtil.SPUmAlQuraCalendar.prototype = {
    $0_0: null,
    isSupportedYear: function SP_DateTimeUtil_SPUmAlQuraCalendar$isSupportedYear($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$H($p0, 1318, 1450);
    },
    isSupportedMonth: function SP_DateTimeUtil_SPUmAlQuraCalendar$isSupportedMonth($p0, $p1) {
        return SP.DateTimeUtil.SPCalendarUtil.$I($p0, $p1, 1318, 1, 1451, 1) && $p1 >= 1 && $p1 <= this.$0_0.$6_0();
    },
    isSupportedDate: function SP_DateTimeUtil_SPUmAlQuraCalendar$isSupportedDate($p0) {
        return SP.DateTimeUtil.SPCalendarUtil.$G($p0.get_year(), $p0.get_month(), $p0.get_day(), 1318, 1, 1, 1451, 1, 7) && $p0.get_month() >= 1 && $p0.get_month() <= this.$0_0.$6_0();
    },
    isDateValid: function SP_DateTimeUtil_SPUmAlQuraCalendar$isDateValid($p0, $p1, $p2) {
        return this.isSupportedDate($p0) && $p0.get_day() > 0 && ($p0.get_day() < 29 ? true : $p0.get_day() <= this.daysInMonth($p0, $p1));
    },
    dateToJulianDay: function SP_DateTimeUtil_SPUmAlQuraCalendar$dateToJulianDay($p0, $p1) {
        if (!this.isSupportedDate($p0)) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$M_0($p0.get_year(), $p0.get_month(), $p0.get_day());
    },
    julianDayToDate: function SP_DateTimeUtil_SPUmAlQuraCalendar$julianDayToDate($p0, $p1, $p2) {
        if (!this.isSupportedJulianDay($p0)) {
            throw Error.argumentOutOfRange();
        }
        if ($p1 && $p2 && !this.isSupportedJulianDay($p2)) {
            throw Error.argumentOutOfRange();
        }
        $p2 = this.$0_0.$n_0();
        return this.$0_0.$K_0($p0);
    },
    isSupportedJulianDay: function SP_DateTimeUtil_SPUmAlQuraCalendar$isSupportedJulianDay($p0) {
        return $p0 >= 109326 && $p0 <= 174175;
    },
    getMonthLeap: function SP_DateTimeUtil_SPUmAlQuraCalendar$getMonthLeap($p0) {
        return -1;
    },
    isYearLeap: function SP_DateTimeUtil_SPUmAlQuraCalendar$isYearLeap($p0, $p1) {
        return 11 * ($p0 + 15) % 30 < 11;
    },
    monthsInYear: function SP_DateTimeUtil_SPUmAlQuraCalendar$monthsInYear($p0) {
        if (!this.isSupportedYear($p0.get_year())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$6_0();
    },
    daysInMonth: function SP_DateTimeUtil_SPUmAlQuraCalendar$daysInMonth($p0, $p1) {
        if (!this.isSupportedMonth($p0.get_year(), $p0.get_month())) {
            throw Error.argumentOutOfRange();
        }
        return this.$0_0.$A_0($p0.get_year(), $p0.get_month());
    },
    getEraOffset: function SP_DateTimeUtil_SPUmAlQuraCalendar$getEraOffset($p0) {
        return 0;
    },
    getEraJulianDay: function SP_DateTimeUtil_SPUmAlQuraCalendar$getEraJulianDay($p0) {
        return 1;
    }
};
SP.DateTimeUtil.IntlDate = function SP_DateTimeUtil_IntlDate($p0) {
    this.$1_0 = $p0;
};
SP.DateTimeUtil.IntlDate.createFromDateParts = function SP_DateTimeUtil_IntlDate$createFromDateParts(year, month, day, era, calendarType) {
    var $v_0 = new SP.DateTimeUtil.IntlDate(calendarType);

    $v_0.$2_0 = year;
    $v_0.$3_0 = month;
    $v_0.$4_0 = day;
    $v_0.$9_0 = era;
    $v_0.$5_0 = 0;
    $v_0.$E_0();
    return $v_0;
};
SP.DateTimeUtil.IntlDate.createFromTicks = function SP_DateTimeUtil_IntlDate$createFromTicks(ticks, calendarType) {
    var $v_0 = new SP.DateTimeUtil.IntlDate(calendarType);

    $v_0.set_ticks(ticks);
    return $v_0;
};
SP.DateTimeUtil.IntlDate.createFromJsLocalDate = function SP_DateTimeUtil_IntlDate$createFromJsLocalDate(jsDate, calendarType) {
    var $v_0 = SP.DateTimeUtil.IntlDate.createFromDateParts(jsDate.getFullYear(), jsDate.getMonth() + 1, jsDate.getDate(), 0, 1);

    $v_0.setTime(jsDate.getHours(), jsDate.getMinutes(), jsDate.getSeconds(), jsDate.getMilliseconds());
    $v_0.convertToCalendar(calendarType);
    return $v_0;
};
SP.DateTimeUtil.IntlDate.createFromJsUtcDate = function SP_DateTimeUtil_IntlDate$createFromJsUtcDate(jsDate, calendarType) {
    var $v_0 = SP.DateTimeUtil.IntlDate.createFromDateParts(jsDate.getUTCFullYear(), jsDate.getUTCMonth() + 1, jsDate.getUTCDate(), 0, 1);

    $v_0.setTime(jsDate.getUTCHours(), jsDate.getUTCMinutes(), jsDate.getUTCSeconds(), jsDate.getUTCMilliseconds());
    $v_0.convertToCalendar(calendarType);
    return $v_0;
};
SP.DateTimeUtil.IntlDate.get_utcNow = function SP_DateTimeUtil_IntlDate$get_utcNow() {
    return SP.DateTimeUtil.IntlDate.createFromJsUtcDate(MakeJsDateObject(), 1);
};
SP.DateTimeUtil.IntlDate.get_now = function SP_DateTimeUtil_IntlDate$get_now() {
    return SP.DateTimeUtil.IntlDate.createFromJsLocalDate(MakeJsDateObject(), 1);
};
SP.DateTimeUtil.IntlDate.prototype = {
    $2_0: 0,
    $3_0: 0,
    $4_0: 0,
    $9_0: 0,
    $B_0: 0,
    $5_0: 0,
    $1_0: 0,
    format: function SP_DateTimeUtil_IntlDate$format(format, userLocale) {
        if (!SP.DateTimeUtil.IntlDate.$q) {
            SP.DateTimeUtil.IntlDate.$q = new SP.DateTimeUtil.DateFormat();
        }
        return SP.DateTimeUtil.IntlDate.$q.format(this, format, userLocale);
    },
    julianDay: function SP_DateTimeUtil_IntlDate$julianDay() {
        return this.$B_0;
    },
    toJsDate: function SP_DateTimeUtil_IntlDate$toJsDate() {
        if (this.$1_0 === 1) {
            return MakeJsDateObjectFromDateTimeParts(this.$2_0, this.$3_0 - 1, this.$4_0, 0, 0, 0, this.$5_0);
        }
        else {
            var $v_0 = SP.DateTimeUtil.SPIntlCal.julianDayToLocal(1, this.$B_0);

            return MakeJsDateObjectFromDateTimeParts($v_0.get_year(), $v_0.get_month() - 1, $v_0.get_day(), 0, 0, 0, this.$5_0);
        }
    },
    clone: function SP_DateTimeUtil_IntlDate$clone() {
        var $v_0 = new SP.DateTimeUtil.IntlDate(this.$1_0);

        $v_0.$2_0 = this.$2_0;
        $v_0.$3_0 = this.$3_0;
        $v_0.$4_0 = this.$4_0;
        $v_0.$9_0 = this.$9_0;
        $v_0.$B_0 = this.$B_0;
        $v_0.$5_0 = this.$5_0;
        return $v_0;
    },
    equals: function SP_DateTimeUtil_IntlDate$equals(other) {
        return this.$B_0 === other.$B_0 && this.$5_0 === other.$5_0;
    },
    convertToCalendar: function SP_DateTimeUtil_IntlDate$convertToCalendar(calendarType) {
        if (calendarType !== this.$1_0 && calendarType) {
            this.$1_0 = calendarType;
            this.$t_0();
        }
    },
    setDate: function SP_DateTimeUtil_IntlDate$setDate(year, month, day, era) {
        this.$2_0 = year;
        this.$3_0 = month;
        this.$4_0 = day;
        this.$9_0 = era;
        this.$E_0();
    },
    setTime: function SP_DateTimeUtil_IntlDate$setTime(hours, minutes, seconds, milliseconds) {
        this.$5_0 = hours * SP.DateTimeUtil.IntlDate.$Q + minutes * SP.DateTimeUtil.IntlDate.$R + seconds * 1000 + milliseconds;
        this.$F_0();
    },
    get_year: function SP_DateTimeUtil_IntlDate$get_year() {
        return this.$2_0;
    },
    set_year: function SP_DateTimeUtil_IntlDate$set_year(value) {
        this.$2_0 = value;
        this.$E_0();
        return value;
    },
    get_month: function SP_DateTimeUtil_IntlDate$get_month() {
        return this.$3_0;
    },
    set_month: function SP_DateTimeUtil_IntlDate$set_month(value) {
        this.$3_0 = value;
        this.$E_0();
        return value;
    },
    get_day: function SP_DateTimeUtil_IntlDate$get_day() {
        return this.$4_0;
    },
    set_day: function SP_DateTimeUtil_IntlDate$set_day(value) {
        this.$4_0 = value;
        this.$E_0();
        return value;
    },
    get_hours: function SP_DateTimeUtil_IntlDate$get_hours() {
        return Math.floor(this.$5_0 / SP.DateTimeUtil.IntlDate.$Q);
    },
    set_hours: function SP_DateTimeUtil_IntlDate$set_hours(value) {
        this.$5_0 -= this.get_hours();
        this.$5_0 += value * SP.DateTimeUtil.IntlDate.$Q;
        this.$F_0();
        return value;
    },
    get_minutes: function SP_DateTimeUtil_IntlDate$get_minutes() {
        return Math.floor(this.$5_0 % SP.DateTimeUtil.IntlDate.$Q / SP.DateTimeUtil.IntlDate.$R);
    },
    set_minutes: function SP_DateTimeUtil_IntlDate$set_minutes(value) {
        this.$5_0 -= this.get_minutes();
        this.$5_0 += value * SP.DateTimeUtil.IntlDate.$R;
        this.$F_0();
        return value;
    },
    get_seconds: function SP_DateTimeUtil_IntlDate$get_seconds() {
        return Math.floor(this.$5_0 % SP.DateTimeUtil.IntlDate.$R / 1000);
    },
    set_seconds: function SP_DateTimeUtil_IntlDate$set_seconds(value) {
        this.$5_0 -= this.get_seconds();
        this.$5_0 += value * 1000;
        this.$F_0();
        return value;
    },
    get_milliSeconds: function SP_DateTimeUtil_IntlDate$get_milliSeconds() {
        return this.$5_0 % 1000;
    },
    set_milliSeconds: function SP_DateTimeUtil_IntlDate$set_milliSeconds(value) {
        this.$5_0 -= this.get_milliSeconds();
        this.$5_0 += value;
        this.$F_0();
        return value;
    },
    get_ticks: function SP_DateTimeUtil_IntlDate$get_ticks() {
        return this.$B_0 * SP.DateTimeUtil.IntlDate.$P + this.$5_0;
    },
    set_ticks: function SP_DateTimeUtil_IntlDate$set_ticks(value) {
        this.$B_0 = Math.floor(value / SP.DateTimeUtil.IntlDate.$P);
        this.$5_0 = value % SP.DateTimeUtil.IntlDate.$P;
        this.$t_0();
        this.$F_0();
        return value;
    },
    get_era: function SP_DateTimeUtil_IntlDate$get_era() {
        return this.$9_0;
    },
    set_era: function SP_DateTimeUtil_IntlDate$set_era(value) {
        this.$9_0 = value;
        this.$E_0();
        return value;
    },
    get_timezoneOffset: function SP_DateTimeUtil_IntlDate$get_timezoneOffset() {
        return (this.toJsDate()).getTimezoneOffset();
    },
    get_weekOfYear: function SP_DateTimeUtil_IntlDate$get_weekOfYear() {
        return SP.DateTimeUtil.SPIntlCal.getWeekNumber(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0), 0, 0);
    },
    get_quarter: function SP_DateTimeUtil_IntlDate$get_quarter() {
        return this.$1A_0(3);
    },
    get_monthThird: function SP_DateTimeUtil_IntlDate$get_monthThird() {
        if (this.$4_0 < 11) {
            return 1;
        }
        else if (this.$4_0 < 21) {
            return 2;
        }
        else {
            return 3;
        }
    },
    get_halfYear: function SP_DateTimeUtil_IntlDate$get_halfYear() {
        return this.$1A_0(6);
    },
    toString: function SP_DateTimeUtil_IntlDate$toString() {
        return 'blah!';
    },
    get_calendarType: function SP_DateTimeUtil_IntlDate$get_calendarType() {
        return this.$1_0;
    },
    get_dayOfWeek: function SP_DateTimeUtil_IntlDate$get_dayOfWeek() {
        return (this.$B_0 + 1) % 7;
    },
    lunarLeapMonth: function SP_DateTimeUtil_IntlDate$lunarLeapMonth() {
        return SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0);
    },
    isYearLeap: function SP_DateTimeUtil_IntlDate$isYearLeap() {
        return SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0);
    },
    monthsInYear: function SP_DateTimeUtil_IntlDate$monthsInYear() {
        return SP.DateTimeUtil.SPIntlCal.monthsInLocalYear(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));
    },
    daysInMonth: function SP_DateTimeUtil_IntlDate$daysInMonth() {
        return SP.DateTimeUtil.SPIntlCal.daysInLocalMonth(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));
    },
    addYears: function SP_DateTimeUtil_IntlDate$addYears(years) {
        if (years) {
            this.$2_0 += years;
            if (this.$3_0 > 12) {
                this.$3_0 = Math.min(SP.DateTimeUtil.SPIntlCal.monthsInLocalYear(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, 1, 1, 1)), this.$3_0);
            }
            this.$E_0();
        }
    },
    addMonthThirds: function SP_DateTimeUtil_IntlDate$addMonthThirds(monthThirds) {
        if (monthThirds) {
            var $v_0 = monthThirds % 3;
            var $v_1 = $v_0 > 0 ? 1 : -1;

            this.addMonths(Math.floor(monthThirds / 3));
            for (var $v_2 = $v_1 * $v_0; $v_2 > 0; $v_2--) {
                if ($v_0 < 0) {
                    if (this.$4_0 < 11 && this.$4_0 > 8) {
                        this.addMonths(-1);
                        var $v_3 = SP.DateTimeUtil.SPIntlCal.daysInLocalMonth(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));

                        this.$4_0 = Math.min($v_3, this.$4_0 + 20);
                        this.$E_0();
                    }
                    else if (this.$4_0 <= 8) {
                        this.addMonths(-1);
                        this.addDays(20);
                    }
                    else {
                        this.addDays(-10);
                    }
                }
                else {
                    if (this.$4_0 >= 18 && this.$4_0 < 21) {
                        var $v_4 = SP.DateTimeUtil.SPIntlCal.daysInLocalMonth(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));

                        this.$4_0 = Math.min($v_4, this.$4_0 + 10);
                        this.$E_0();
                    }
                    else if (this.$4_0 >= 21) {
                        this.addMonths(1);
                        this.addDays(-20);
                    }
                    else {
                        this.addDays(-10);
                    }
                }
            }
        }
    },
    addHalfYears: function SP_DateTimeUtil_IntlDate$addHalfYears(halfYears) {
        if (halfYears) {
            this.$s_0(halfYears, 6, true);
        }
    },
    addQuarters: function SP_DateTimeUtil_IntlDate$addQuarters(quarters) {
        if (quarters) {
            this.$s_0(quarters, 3, true);
        }
    },
    addMonths: function SP_DateTimeUtil_IntlDate$addMonths(months) {
        if (months) {
            this.$s_0(months, 1, false);
        }
    },
    addHours: function SP_DateTimeUtil_IntlDate$addHours(hours) {
        if (hours) {
            this.$5_0 += hours * SP.DateTimeUtil.IntlDate.$Q;
            this.$F_0();
        }
    },
    addMinutes: function SP_DateTimeUtil_IntlDate$addMinutes(minutes) {
        if (minutes) {
            this.$5_0 += minutes * SP.DateTimeUtil.IntlDate.$R;
            this.$F_0();
        }
    },
    addSeconds: function SP_DateTimeUtil_IntlDate$addSeconds(seconds) {
        if (seconds) {
            this.$5_0 += seconds * 1000;
            this.$F_0();
        }
    },
    addMilliSeconds: function SP_DateTimeUtil_IntlDate$addMilliSeconds(milliSeconds) {
        if (milliSeconds) {
            this.$5_0 += milliSeconds;
            this.$F_0();
        }
    },
    addDays: function SP_DateTimeUtil_IntlDate$addDays(days) {
        if (days) {
            this.$B_0 += days;
            this.$t_0();
        }
    },
    addWeeks: function SP_DateTimeUtil_IntlDate$addWeeks(weeks) {
        this.addDays(weeks * 7);
    },
    $E_0: function SP_DateTimeUtil_IntlDate$$E_0() {
        this.$B_0 = SP.DateTimeUtil.SPIntlCal.localToJulianDay(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));
    },
    $t_0: function SP_DateTimeUtil_IntlDate$$t_0() {
        var $v_0;

        if (this.$1_0 === 6) {
            $v_0 = SP.DateTimeUtil.SPIntlCal.julianDayToLocal2(this.$1_0, this.$B_0, _spRegionalSettings.adjustHijriDays);
        }
        else {
            $v_0 = SP.DateTimeUtil.SPIntlCal.julianDayToLocal(this.$1_0, this.$B_0);
        }
        this.$2_0 = $v_0.get_year();
        this.$3_0 = $v_0.get_month();
        this.$4_0 = $v_0.get_day();
        this.$9_0 = $v_0.get_era();
    },
    $F_0: function SP_DateTimeUtil_IntlDate$$F_0() {
        var $v_0 = this.$5_0 % SP.DateTimeUtil.IntlDate.$P;
        var $v_1 = Math.floor(this.$5_0 / SP.DateTimeUtil.IntlDate.$P);

        this.$5_0 = $v_0;
        if ($v_0 < 0) {
            this.$5_0 = SP.DateTimeUtil.IntlDate.$P - Math.abs(this.$5_0);
        }
        this.addDays($v_1);
    },
    $s_0: function SP_DateTimeUtil_IntlDate$$s_0($p0, $p1, $p2) {
        if (Math.abs($p0 * $p1) >= 12) {
            this.addYears(Math.floor($p0 * $p1 / 12));
        }
        var $v_0 = $p0 * $p1 % 12;

        if ($v_0 > 0) {
            var $v_1 = $p2 && SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0) ? SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0) : -1;
            var $v_2 = SP.DateTimeUtil.SPIntlCal.monthsInLocalYear(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, 1, 1, 1));

            for (var $v_3 = $v_0; $v_3 > 0; $v_3--) {
                if (this.$3_0 < $v_2) {
                    this.$3_0++;
                }
                else {
                    this.$2_0++;
                    this.$3_0 = 1;
                    $v_2 = SP.DateTimeUtil.SPIntlCal.monthsInLocalYear(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, 1, 1, 1));
                    $v_1 = $p2 && SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0) ? SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0) : -1;
                }
                if ($p2 && this.$3_0 === $v_1) {
                    this.$1H_0('MonthLeap {0} fixed++ in year {1}', this.$3_0.toString(), this.$2_0.toString());
                    $v_3++;
                }
            }
        }
        if ($v_0 < 0) {
            var $v_4 = $p2 && SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0) ? SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0) : -1;

            for (var $v_5 = $v_0; $v_5 < 0; $v_5++) {
                if (this.$3_0 !== 1) {
                    this.$3_0--;
                }
                else {
                    this.$2_0--;
                    this.$3_0 = SP.DateTimeUtil.SPIntlCal.monthsInLocalYear(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, 1, 1, 1));
                    $v_4 = $p2 && SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0) ? SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0) : -1;
                }
                if ($p2 && this.$3_0 === $v_4) {
                    this.$1H_0('MonthLeap {0} fixed-- in year {1}', this.$3_0.toString(), this.$2_0.toString());
                    $v_5--;
                }
            }
        }
        if (Math.abs($v_0) > 0) {
            var $v_6 = SP.DateTimeUtil.SPIntlCal.daysInLocalMonth(this.$1_0, new SP.DateTimeUtil.SimpleDate(this.$2_0, this.$3_0, this.$4_0, this.$9_0));

            this.$4_0 = Math.min(this.$4_0, $v_6);
            this.$E_0();
        }
    },
    $1A_0: function SP_DateTimeUtil_IntlDate$$1A_0($p0) {
        var $v_0 = SP.DateTimeUtil.SPIntlCal.isLocalYearLeap(this.$1_0, this.$2_0) ? SP.DateTimeUtil.SPIntlCal.getMonthLeap(this.$1_0, this.$2_0) : -1;

        if ($v_0 === -1 || this.$3_0 < $v_0) {
            return Math.ceil(this.$3_0 / $p0);
        }
        else {
            return Math.ceil((this.$3_0 - 1) / $p0);
        }
    },
    $1H_0: function SP_DateTimeUtil_IntlDate$$1H_0($p0, $p1, $p2) {
    }
};
SP.DateTimeUtil.GetMonthAdvanceInfoScriptSharpReturn = function SP_DateTimeUtil_GetMonthAdvanceInfoScriptSharpReturn() {
};
SP.DateTimeUtil.GetMonthAdvanceInfoScriptSharpReturn.prototype = {
    bInZone: false,
    iEffectiveAdvance: 0
};
SP.DateTimeUtil.SPCalendarUtil = function SP_DateTimeUtil_SPCalendarUtil() {
};
SP.DateTimeUtil.SPCalendarUtil.$H = function SP_DateTimeUtil_SPCalendarUtil$$H($p0, $p1, $p2) {
    return $p0 >= $p1 && $p0 <= $p2;
};
SP.DateTimeUtil.SPCalendarUtil.$I = function SP_DateTimeUtil_SPCalendarUtil$$I($p0, $p1, $p2, $p3, $p4, $p5) {
    return ($p0 > $p2 || $p0 === $p2 && $p1 >= $p3) && ($p0 < $p4 || $p0 === $p4 && $p1 <= $p5);
};
SP.DateTimeUtil.SPCalendarUtil.$G = function SP_DateTimeUtil_SPCalendarUtil$$G($p0, $p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8) {
    return ($p0 > $p3 || $p0 === $p3 && ($p1 > $p4 || $p1 === $p4 && $p2 >= $p5)) && ($p0 < $p6 || $p0 === $p6 && ($p1 < $p7 || $p1 === $p7 && $p2 <= $p8));
};
SP.DateTimeUtil.SakaCalendarImpl = function SP_DateTimeUtil_SakaCalendarImpl() {
    this.$7_1 = [0, 30, 61, 92, 123, 154, 185, 215, 245, 275, 305, 335, 365];
    this.$S_1 = [0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336, 366];
    SP.DateTimeUtil.SakaCalendarImpl.initializeBase(this);
};
SP.DateTimeUtil.SakaCalendarImpl.$8 = function SP_DateTimeUtil_SakaCalendarImpl$$8($p0) {
    return SP.DateTimeUtil.SolarCalendarImpl.$8($p0 + 78);
};
SP.DateTimeUtil.SakaCalendarImpl.prototype = {
    $M_1: function SP_DateTimeUtil_SakaCalendarImpl$$M_1($p0, $p1, $p2) {
        return this.$r_1($p0) + (SP.DateTimeUtil.SakaCalendarImpl.$8($p0) ? this.$S_1[$p1 - 1] : this.$7_1[$p1 - 1]) + $p2 - 1;
    },
    $r_1: function SP_DateTimeUtil_SakaCalendarImpl$$r_1($p0) {
        var $v_0 = $p0 - 1123;

        return 365 * $v_0 + Math.floor($v_0 / 4) - Math.floor($v_0 / 100) + Math.floor($v_0 / 400) + 80 - SP.DateTimeUtil.SolarCalendarImpl._DaysIn400Years;
    },
    $K_1: function SP_DateTimeUtil_SakaCalendarImpl$$K_1($p0) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);
        var $v_1 = $p0;
        var $v_2;

        $v_0.set_year(Math.floor(1123 + (($v_1 + SP.DateTimeUtil.SolarCalendarImpl._DaysIn400Years - 80) * 400 + 600) / SP.DateTimeUtil.SolarCalendarImpl._DaysIn400Years));
        $v_1 -= this.$r_1($v_0.get_year());
        if ($v_1 < 0) {
            $v_0.set_year($v_0.get_year() - 1);
            $v_2 = SP.DateTimeUtil.SakaCalendarImpl.$8($v_0.get_year());
            $v_1 += $v_2 ? 366 : 365;
        }
        else {
            $v_2 = SP.DateTimeUtil.SakaCalendarImpl.$8($v_0.get_year());
        }
        $v_0.set_month(1 + ($v_1 >> 5));
        if ($v_0.get_month() < SP.DateTimeUtil.SolarCalendarImpl._MonthsInYear && $v_1 >= ($v_2 ? this.$S_1[$v_0.get_month()] : this.$7_1[$v_0.get_month()])) {
            $v_0.set_month($v_0.get_month() + 1);
        }
        $v_0.set_day(1 + $v_1 - ($v_2 ? this.$S_1[$v_0.get_month() - 1] : this.$7_1[$v_0.get_month() - 1]));
        return $v_0;
    },
    $A_1: function SP_DateTimeUtil_SakaCalendarImpl$$A_1($p0, $p1) {
        var $v_0 = SP.DateTimeUtil.SakaCalendarImpl.$8($p0);

        return ($v_0 ? this.$S_1[$p1] : this.$7_1[$p1]) - ($v_0 ? this.$S_1[$p1 - 1] : this.$7_1[$p1 - 1]);
    }
};
SP.DateTimeUtil.HijriCalendarImpl = function SP_DateTimeUtil_HijriCalendarImpl() {
    this.$7_0 = [0, 30, 59, 89, 118, 148, 177, 207, 236, 266, 295, 325, 354];
};
SP.DateTimeUtil.HijriCalendarImpl.prototype = {
    $M_0: function SP_DateTimeUtil_HijriCalendarImpl$$M_0($p0, $p1, $p2, $p3, $p4) {
        if ($p3) {
            var $v_2 = this.$18_0($p0, $p1, $p3, $p4);
            var $v_3 = $v_2.iEffectiveAdvance;

            if ($v_3) {
                $p2 -= $v_3;
            }
        }
        var $v_0 = $p0 % 30;
        var $v_1 = Math.floor($p0 / 30) * 10631 + 354 * $v_0 + Math.floor(11 * ($v_0 + 14) / 30) + this.$7_0[$p1 - 1] + $p2 - 357735;

        return $v_1;
    },
    $8_0: function SP_DateTimeUtil_HijriCalendarImpl$$8_0($p0) {
        return 11 * ($p0 + 15) % 30 < 11;
    },
    $K_0: function SP_DateTimeUtil_HijriCalendarImpl$$K_0($p0, $p1, $p2) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);

        $v_0.set_year(Math.floor(1009 + ($p0 * 30 + 5216) / 10631));
        var $v_1 = $v_0.get_year() % 30;
        var $v_2 = ($p0 + 6906) % 10631 - (354 * $v_1 + Math.floor(11 * ($v_1 + 14) / 30) - 5);

        $v_0.set_month(1 + ($v_2 >> 5));
        if ($v_0.get_month() < 12 && $v_2 >= this.$7_0[$v_0.get_month()]) {
            $v_0.set_month($v_0.get_month() + 1);
        }
        $v_0.set_day(1 + $v_2 - this.$7_0[$v_0.get_month() - 1]);
        if ($p1) {
            var $v_3 = 0;
            var $v_4 = false;
            var $v_5 = this.$18_0($v_0.get_year(), $v_0.get_month(), $p1, $p2);

            $v_3 = $v_5.iEffectiveAdvance;
            $v_4 = $v_5.bInZone;
            if ($v_4) {
                $v_0.set_day($v_0.get_day() + $v_3);
                if ($v_0.get_day() <= 0) {
                    $v_0.set_month($v_0.get_month() - 1);
                    if ($v_0.get_month() <= 0) {
                        $v_0.set_year($v_0.get_year() - 1);
                        $v_0.set_month(12);
                    }
                    $v_0.set_day(this.$A_0($v_0.get_year(), $v_0.get_month(), $p1, $p2) + $v_0.get_day());
                }
                else {
                    var $v_6 = this.$A_0($v_0.get_year(), $v_0.get_month(), $p1, $p2);

                    if ($v_0.get_day() > $v_6) {
                        $v_0.set_month($v_0.get_month() + 1);
                        if ($v_0.get_month() > 12) {
                            $v_0.set_year($v_0.get_year() + 1);
                            $v_0.set_month(1);
                        }
                        $v_0.set_day($v_0.get_day() - $v_6);
                    }
                }
            }
        }
        return $v_0;
    },
    $6_0: function SP_DateTimeUtil_HijriCalendarImpl$$6_0() {
        return 12;
    },
    $A_0: function SP_DateTimeUtil_HijriCalendarImpl$$A_0($p0, $p1, $p2, $p3) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);

        if ($p2) {
            this.$K_0($p3, 0, $p3);
        }
        return this.$1S_0($p0, $p1, $p2, $v_0);
    },
    $1S_0: function SP_DateTimeUtil_HijriCalendarImpl$$1S_0($p0, $p1, $p2, $p3) {
        var $v_0 = this.$7_0[$p1] - this.$7_0[$p1 - 1] + (this.$8_0($p0) && $p1 === 12 ? 1 : 0);

        if ($p2) {
            var $v_1 = false;
            var $v_2 = this.$19_0($p0, $p1, $p2, $p3);

            $v_1 = $v_2.bInZone;
            if ($v_1) {
                if ($p2 > 0 && ($p3.get_year() > $p0 || $p3.get_year() === $p0 && $p3.get_month() > $p1) || $p2 < 0 && ($p3.get_year() < $p0 || $p3.get_year() === $p0 && $p3.get_month() <= $p1)) {
                    $v_0 = 29;
                }
                else {
                    $v_0 = 30;
                }
            }
        }
        return $v_0;
    },
    $18_0: function SP_DateTimeUtil_HijriCalendarImpl$$18_0($p0, $p1, $p2, $p3) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);

        if ($p2) {
            $v_0 = this.$K_0($p3, 0, $p3);
        }
        return this.$19_0($p0, $p1, $p2, $v_0);
    },
    $19_0: function SP_DateTimeUtil_HijriCalendarImpl$$19_0($p0, $p1, $p2, $p3) {
        var $v_0;
        var $v_1;

        $v_0 = 0;
        $v_1 = true;
        var $v_2 = this.$7_0[$p3.get_month()] - this.$7_0[$p3.get_month() - 1];
        var $v_3 = $v_2 === 30 && $p2 < 0 || $v_2 === 29 && $p2 > 0;
        var $v_4 = $p2 > 0 ? $p2 * 2 : $p2 * -2;

        if ($v_3) {
            $v_4--;
        }
        var $v_5 = $v_4;

        if ($p3.get_year() - $p0 === 1 && this.$8_0($p0)) {
            $v_4 -= $p2 > 0 ? 2 : -2;
        }
        if ($p0 - $p3.get_year() === 1 && this.$8_0($p3.get_year())) {
            $v_5 += $p2 > 0 ? 2 : -2;
        }
        var $v_6 = 12 * $p0 + $p1 - (12 * $p3.get_year() + $p3.get_month());

        if ($v_6 >= $v_5) {
            $v_1 = false;
        }
        else if ($v_6 < -$v_4) {
            $v_1 = false;
        }
        if ($v_1) {
            if ($p0 < $p3.get_year() || $p0 === $p3.get_year() && $p1 < $p3.get_month()) {
                $v_0 = Math.floor(($v_4 + 1 + $v_6) / 2);
            }
            else {
                $v_0 = Math.floor(($v_5 + 1 - $v_6) / 2);
            }
            if ($p2 < 0) {
                $v_0 = -$v_0;
            }
        }
        if ($v_4 < $v_5 && $p2 > 0 && $p3.get_month() - $v_4 === 1 && $p1 === 12) {
            $v_1 = true;
        }
        var $v_7 = new SP.DateTimeUtil.GetMonthAdvanceInfoScriptSharpReturn();

        $v_7.iEffectiveAdvance = $v_0;
        $v_7.bInZone = $v_1;
        return $v_7;
    },
    $n_0: function SP_DateTimeUtil_HijriCalendarImpl$$n_0() {
        var $v_0 = new Date();

        return SP.DateTimeUtil.GregorianCalendarImpl.$M($v_0.getFullYear(), $v_0.getMonth() + 1, $v_0.getDate());
    }
};
SP.DateTimeUtil.HebrewCalendarImpl = function SP_DateTimeUtil_HebrewCalendarImpl() {
    this.$y_0 = [0, 30, 59, 88, 117, 147, 176, 206, 235, 265, 294, 324, 353, 353];
    this.$z_0 = [0, 30, 59, 89, 118, 148, 177, 207, 236, 266, 295, 325, 354, 354];
    this.$10_0 = [0, 30, 60, 90, 119, 149, 178, 208, 237, 267, 296, 326, 355, 355];
    this.$v_0 = [0, 30, 59, 88, 117, 147, 177, 206, 236, 265, 295, 324, 354, 383];
    this.$w_0 = [0, 30, 59, 89, 118, 148, 178, 207, 237, 266, 296, 325, 355, 384];
    this.$x_0 = [0, 30, 60, 90, 119, 149, 179, 208, 238, 267, 297, 326, 356, 385];
    this.$u_0 = [30, 48, 37, 27, 47, 34, 53, 43, 33, 50, 39, 29, 49, 37, 25, 45, 34, 51, 41, 30, 50, 37, 26, 46, 36, 53, 42, 32, 50, 39, 28, 48, 38, 26, 44, 34, 52, 41, 30, 50, 39, 27, 46, 35, 53, 43, 31, 51, 39, 29, 47, 37, 25, 44, 33, 53, 41, 30, 49, 39, 28, 46, 35, 53, 42, 32, 51, 40, 28, 48, 37, 26, 44, 33, 53, 42, 30, 49, 39, 28, 46, 35, 55, 42, 31, 51, 41, 29, 47, 37, 26, 45, 33, 53, 42, 31, 49, 38, 28, 45, 35, 54, 44, 32, 50, 40, 30, 48, 36, 26, 46, 35, 52, 42, 31, 49, 38, 27, 47, 35, 54, 43, 33, 51, 39, 29, 47, 37, 25, 45, 33, 52, 41, 31, 49, 38, 28, 47, 36, 54, 44, 32, 50, 40, 29, 48, 36, 26, 45, 34, 52, 41, 31, 50, 38, 27, 47, 36, 54, 43, 33, 50, 39, 29, 49, 37, 25, 45, 34, 54, 41, 30, 50, 40, 27, 46, 36, 54, 43, 32, 52, 42, 30, 48, 38, 27, 44, 34, 54, 43, 30, 50, 39, 29, 46, 35, 55, 43, 32, 51, 41, 29, 48, 37, 27, 45, 34, 53, 43, 32, 50, 39, 28, 46, 36, 55, 44, 32, 52, 40, 30, 48, 37, 26, 44, 34, 53, 42, 30, 49, 39, 28, 46, 35, 55, 45, 33, 51, 41, 30, 49, 37, 26, 46, 35, 53, 42, 32, 49, 38, 28, 48, 35, 54, 44, 34, 51, 40, 30, 50, 38, 26, 46, 35, 52, 42, 31, 51, 39, 27, 47, 37, 55, 43, 33, 51, 41, 29, 49, 39, 28, 45, 35, 53, 42, 31, 51, 40, 28, 47, 36, 54, 44, 32, 52, 40, 30, 48, 38, 26, 45, 35, 52, 42, 31, 51, 40, 29, 47, 37, 54, 43, 33, 53, 41, 29, 49, 38, 27, 45, 34, 54, 43, 31, 50, 40, 29, 47, 36, 56, 43, 32, 52, 42, 31, 48, 38, 27, 47, 34, 54, 43, 33, 50, 39, 29, 47, 35, 55, 45, 33, 51, 41, 31, 49, 37, 27, 47, 36, 53, 43, 32, 50, 39, 28, 48, 36, 56, 44, 34, 52, 41, 30, 48, 38, 27, 46, 34, 53, 43, 32, 50, 39, 29, 48, 37, 55, 45, 33, 51, 41, 30, 49, 37, 27, 46, 35, 53, 42, 32, 51, 39, 28, 48, 38, 55, 44, 34, 52, 40, 30, 50, 39, 26, 46, 35, 55, 42, 31, 51, 41, 28, 47, 37, 55, 44, 33, 53, 43, 31, 49, 39, 28, 45, 35, 55, 44, 32, 51, 40, 30, 48, 36, 56, 44, 34, 52, 42, 30, 49, 38, 28, 46, 35, 54, 44, 33, 51, 40, 29, 47, 37, 56, 45, 33, 53, 41, 31, 49, 38, 28, 45, 35, 54, 44, 31, 50, 40, 30, 47, 36, 56, 46, 34, 52, 42, 31, 48, 38, 27, 47, 34, 54, 43, 33, 50, 39, 29, 49, 36, 55, 45, 35, 53, 41, 31, 51, 40, 27, 47, 36, 54, 43, 32, 52, 40, 28, 48, 38, 56, 44, 34, 52, 42, 30, 50, 40, 29, 46, 36, 54, 43, 32, 52, 41, 29, 49, 37, 55, 45, 34, 53, 41, 31, 50, 39, 27, 46, 36, 53, 43, 32, 52, 41, 30, 48, 38, 55, 44, 34, 54, 42, 30, 50, 39, 28, 46, 35, 55, 43, 32, 51, 41, 29, 47, 37, 57, 45, 33, 53, 43, 32, 49, 39, 28, 48, 35, 55, 44, 34, 51, 40, 30, 48, 36, 56, 46, 34, 52, 42, 32, 50, 39, 28, 48, 37, 55, 44, 33, 51, 41, 29, 49, 37, 57, 45, 35, 53, 42, 31, 49, 39, 28, 47, 35, 54, 44, 33, 51, 40, 30, 49, 38, 56, 46, 35, 52, 42, 31, 51];
};
SP.DateTimeUtil.HebrewCalendarImpl.prototype = {
    $U_0: function SP_DateTimeUtil_HebrewCalendarImpl$$U_0($p0, $p1, $p2) {
        if ($p0) {
            switch ($p1 - 383) {
            case 0:
                return this.$v_0[$p2];
            case 1:
                return this.$w_0[$p2];
            case 2:
                return this.$x_0[$p2];
            default:
                return -1;
            }
        }
        else {
            switch ($p1 - 353) {
            case 0:
                return this.$y_0[$p2];
            case 1:
                return this.$z_0[$p2];
            case 2:
                return this.$10_0[$p2];
            default:
                return -1;
            }
        }
    },
    $1V_0: function SP_DateTimeUtil_HebrewCalendarImpl$$1V_0($p0) {
        if (this.$8_0($p0)) {
            return 5;
        }
        else {
            return -1;
        }
    },
    $8_0: function SP_DateTimeUtil_HebrewCalendarImpl$$8_0($p0) {
        return ($p0 + 11) * 7 % 19 < 7;
    },
    $6_0: function SP_DateTimeUtil_HebrewCalendarImpl$$6_0($p0) {
        return this.$8_0($p0) ? 13 : 12;
    },
    $M_0: function SP_DateTimeUtil_HebrewCalendarImpl$$M_0($p0, $p1, $p2) {
        var $v_0 = this.$O_0($p0);
        var $v_1 = this.$O_0($p0 + 1);
        var $v_2 = $v_1 - $v_0;
        var $v_3 = $v_2 > 365;

        if ($v_3) {
            $v_0 += this.$U_0(true, $v_2, $p1 - 1);
        }
        else {
            $v_0 += this.$U_0(false, $v_2, $p1 - 1);
        }
        $v_0 += $p2 - 1;
        return $v_0;
    },
    $K_0: function SP_DateTimeUtil_HebrewCalendarImpl$$K_0($p0) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);
        var $v_1 = $p0;

        $v_0.set_year(Math.floor(400 * $v_1 / 146097) + 5361);
        if (this.$O_0($v_0.get_year() + 1) <= $v_1 && $v_1 !== 233296) {
            $v_0.set_year($v_0.get_year() + 1);
        }
        var $v_2 = this.$O_0($v_0.get_year());
        var $v_3 = this.$O_0($v_0.get_year() + 1);
        var $v_4 = $v_3 - $v_2;
        var $v_5 = $v_4 > 365;

        $v_1 -= $v_2;
        $v_0.set_month(1 + ($v_1 >> 5));
        if ($v_0.get_month() < 13 && $v_1 >= this.$U_0($v_5, $v_4, $v_0.get_month())) {
            $v_0.set_month($v_0.get_month() + 1);
        }
        $v_0.set_day(1 + $v_1 - this.$U_0($v_5, $v_4, $v_0.get_month() - 1));
        return $v_0;
    },
    $A_0: function SP_DateTimeUtil_HebrewCalendarImpl$$A_0($p0, $p1) {
        var $v_0 = this.$O_0($p0);
        var $v_1 = this.$O_0($p0 + 1);
        var $v_2 = $v_1 - $v_0;
        var $v_3 = $v_2 > 365;

        return this.$U_0($v_3, $v_2, $p1) - this.$U_0($v_3, $v_2, $p1 - 1);
    },
    $O_0: function SP_DateTimeUtil_HebrewCalendarImpl$$O_0($p0) {
        return Math.floor(($p0 - 5361) * 146097 / 400 - 114 + this.$u_0[$p0 - 5361] - 30);
    }
};
SP.DateTimeUtil.FarEastLunarCalendarImpl = function SP_DateTimeUtil_FarEastLunarCalendarImpl() {
    this.$$d_$1o_0 = Function.createDelegate(this, this.$1o_0);
    this.$L_0 = [0, 13, 25, 37, 50, 62, 74, 87, 99, 112, 124, 136, 149, 161, 173, 186, 198, 211, 223, 235, 248, 260, 272, 285, 297, 310, 322, 334, 347, 359, 371, 384, 396, 408, 421, 433, 446, 458, 470, 483, 495, 507, 520, 532, 544, 557, 569, 582, 594, 606, 619, 631, 643, 656, 668, 681, 693, 705, 718, 730, 742, 755, 767, 779, 792, 804, 817, 829, 841, 854, 866, 878, 891, 903, 916, 928, 940, 953, 965, 977, 990, 1002, 1014, 1027, 1039, 1052, 1064, 1076, 1089, 1101, 1113];
    this.$11_0 = [7, 0, 0, 5, 0, 0, 4, 0, 8, 0, 0, 6, 0, 0, 5, 0, 9, 0, 0, 7, 0, 0, 5, 0, 11, 0, 0, 7, 0, 0, 6, 0, 0, 4, 0, 9, 0, 0, 6, 0, 0, 5, 0, 0, 3, 0, 8, 0, 0, 6, 0, 0, 4, 0, 10, 0, 0, 6, 0, 0, 5, 0, 0, 3, 0, 7, 0, 0, 6, 0, 0, 4, 0, 12, 0, 0, 7, 0, 0, 6, 0, 0, 3, 0, 8, 0, 0, 6, 0, 0, 4];
};
SP.DateTimeUtil.FarEastLunarCalendarImpl.prototype = {
    getMonthLeap: function SP_DateTimeUtil_FarEastLunarCalendarImpl$getMonthLeap($p0) {
        var $v_0 = ($p0 - 1600) % 90;

        return this.$11_0[$v_0];
    },
    $1p_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$1p_0($p0) {
        return Math.floor(65735 * ($p0 + 1618) / 2226 - 47779);
    },
    $M_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$M_0($p0, $p1, $p2, $p3) {
        var $v_0 = Math.floor(($p0 - 1600) / 90);
        var $v_1 = ($p0 - 1600) % 90;
        var $v_2 = this.$L_0[$v_1] + ($p1 - 1);

        return 32868 * $v_0 + $p3($v_2) + ($p2 - 1) - 324;
    },
    $K_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$K_0($p0, $p1) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);
        var $v_1 = $p0;

        $v_1 += 324;
        var $v_2 = Math.floor($v_1 / 32868);
        var $v_3 = $v_1 % 32868;
        var $v_4 = Math.floor($v_3 / 30);

        $v_4 += Math.floor(($v_3 - $p1($v_4) + 15) / 29);
        if ($v_4 >= 1113 || $v_3 < $p1($v_4)) {
            --$v_4;
        }
        var $v_5 = Math.floor($v_4 / 13);

        $v_5 += Math.floor(($v_4 - this.$L_0[$v_5] + 6) / 12);
        if ($v_5 >= 90 || $v_4 < this.$L_0[$v_5]) {
            --$v_5;
        }
        $v_0.set_year(1600 + $v_2 * 90 + $v_5);
        $v_0.set_month(1 + $v_4 - this.$L_0[$v_5]);
        $v_0.set_day(1 + $v_3 - $p1($v_4));
        return $v_0;
    },
    $6_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$6_0($p0) {
        var $v_0 = ($p0 - 1600) % 90;
        var $v_1 = this.$L_0[$v_0];

        if (++$v_0 < 90) {
            return this.$L_0[$v_0] - $v_1;
        }
        else {
            return 1113 - $v_1;
        }
    },
    $A_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$A_0($p0, $p1, $p2) {
        var $v_0 = ($p0 - 1600) % 90;
        var $v_1 = this.$L_0[$v_0] + $p1 - 1;
        var $v_2 = $p2($v_1);

        if (++$v_1 < 1113) {
            return $p2($v_1) - $v_2;
        }
        else {
            return 32868 - $v_2;
        }
    },
    $1o_0: function SP_DateTimeUtil_FarEastLunarCalendarImpl$$1o_0($p0) {
        return this.$1p_0($p0) - this.$1n_0($p0);
    }
};
SP.DateTimeUtil.ChineseLunarCalendarImpl = function SP_DateTimeUtil_ChineseLunarCalendarImpl() {
    this.$b_1 = [1145324881, 1427181892, 1431585809, 22368512, 5608704, 269571396, 1145328913, 1360073796, 1430536469, 357896197, 89739265, 1397824, 1145328977, 1360069717, 1413742869, 1431371845, 1435828241, 23413760, 1078023440, 1360020820, 1413484885, 1430258773, 1498415381, 374620165, 68505856, 285496644, 1409291605, 1413497941, 1427116309, 1430519877, 1096093713, 272979008, 1073829201, 1140868437, 1360073045, 1145324629, 357630229, 72696836, 1398032, 1074025812, 286332244, 1145324625, 1427181908, 1163150401, 22368512, 4543808, 268523076, 1145324817, 286331204, 1430537233, 357896196, 72963072, 1401920, 1145327953, 1360073813, 1413759249, 1431371845, 89473025, 22430720, 1074074896, 1699743060, 1413742870, 1427112005, 1431306257, 358891524, 5591296, 268457284, 1413484885, 1426064469, 277];
    SP.DateTimeUtil.ChineseLunarCalendarImpl.initializeBase(this);
};
SP.DateTimeUtil.ChineseLunarCalendarImpl.prototype = {
    $1n_0: function SP_DateTimeUtil_ChineseLunarCalendarImpl$$1n_0($p0) {
        return this.$b_1[$p0 >> 4] >>> (($p0 & 15) << 1) & 3;
    }
};
SP.DateTimeUtil.JapaneseLunarCalendarImpl = function SP_DateTimeUtil_JapaneseLunarCalendarImpl() {
    this.$b_1 = [1145324881, 1427181892, 1431585809, 22368512, 4560128, 269571396, 1145324817, 1360073796, 1430536465, 357896197, 72962048, 1397824, 1145328977, 1360069716, 1413742865, 1431371845, 1435828241, 22365184, 1078023440, 1360020820, 1413484885, 1426064453, 1431306517, 357842948, 68505856, 285496644, 1409291605, 1409287253, 1426067733, 1430519877, 1096093697, 4543552, 1073829201, 1140868437, 1360073045, 1145308245, 357630229, 72696836, 1398032, 1074025812, 285218132, 1145324625, 1427181908, 1163150401, 22368512, 349504, 268506436, 1145324817, 286331204, 1430537233, 357896196, 5592064, 1139776, 1141133649, 286331973, 1413759249, 1431371845, 89473025, 22430720, 1074074896, 1360004436, 1413742869, 1427112005, 1431306257, 358891524, 5591296, 268457284, 1413484885, 1426064469, 277];
    SP.DateTimeUtil.JapaneseLunarCalendarImpl.initializeBase(this);
};
SP.DateTimeUtil.JapaneseLunarCalendarImpl.prototype = {
    $1n_0: function SP_DateTimeUtil_JapaneseLunarCalendarImpl$$1n_0($p0) {
        return this.$b_1[$p0 >> 4] >>> (($p0 & 15) << 1) & 3;
    }
};
SP.DateTimeUtil.UmAlQuraCalendarImpl = function SP_DateTimeUtil_UmAlQuraCalendarImpl() {
    this.$a_0 = [746, 1769, 3794, 3748, 3402, 2710, 1334, 2741, 3498, 2980, 2889, 2707, 1323, 2647, 1206, 2741, 1450, 3413, 3370, 2646, 1198, 2397, 748, 1749, 1706, 1365, 1195, 2395, 698, 1397, 2994, 1892, 1865, 1621, 683, 1371, 2778, 1748, 3785, 3474, 3365, 2637, 685, 1389, 2922, 2898, 2725, 2635, 1175, 2359, 694, 1397, 3434, 3410, 2710, 2349, 605, 1245, 2778, 1492, 3497, 3410, 2730, 1238, 2486, 884, 1897, 1874, 1701, 1355, 2731, 1370, 2773, 3538, 3492, 3401, 2709, 1325, 2653, 1370, 2773, 1706, 1685, 1323, 2647, 1198, 2422, 1388, 2901, 2730, 2645, 1197, 2397, 730, 1497, 3506, 2980, 2890, 2645, 693, 1397, 2922, 3026, 3012, 2953, 2709, 1325, 1453, 2922, 1748, 3529, 3474, 2726, 2390, 686, 1389, 874, 2901, 2730, 2381, 1181, 2397, 698, 1461, 1450, 3413, 2714, 2350, 622, 1373, 2778, 1748, 1701, 0];
    this.$V_0 = [0, 354, 709, 1064, 1418, 1772, 2126, 2480, 2835, 3190, 3544, 3898, 4252, 4606, 4961, 5315, 5670, 6024, 6379, 6733, 7087, 7441, 7796, 8150, 8505, 8859, 9213, 9567, 9922, 10276, 10631, 10986, 11340, 11694, 12048, 12402, 12757, 13112, 13466, 13821, 14175, 14529, 14883, 15237, 15592, 15947, 16301, 16655, 17009, 17363, 17718, 18072, 18427, 18782, 19136, 19490, 19844, 20198, 20553, 20908, 21262, 21617, 21971, 22325, 22679, 23034, 23388, 23743, 24097, 24451, 24805, 25160, 25514, 25869, 26224, 26578, 26932, 27286, 27640, 27995, 28349, 28704, 29058, 29412, 29766, 30121, 30475, 30830, 31184, 31539, 31893, 32247, 32601, 32956, 33310, 33665, 34020, 34374, 34728, 35082, 35436, 35791, 36146, 36501, 36855, 37209, 37563, 37917, 38272, 38627, 38981, 39336, 39690, 40044, 40398, 40752, 41107, 41461, 41816, 42170, 42524, 42878, 43233, 43587, 43942, 44296, 44651, 45005, 45359, 45713, 46068, 46423, 46777, 47131, 47151];
};
SP.DateTimeUtil.UmAlQuraCalendarImpl.prototype = {
    $M_0: function SP_DateTimeUtil_UmAlQuraCalendarImpl$$M_0($p0, $p1, $p2) {
        if ($p0 > 1451) {
            return 156477;
        }
        var $v_0 = 109326 + this.$V_0[$p0 - 1318] + 29 * ($p1 - 1) + $p2;
        var $v_1 = this.$a_0[$p0 - 1318];

        for (var $v_2 = 0; $v_2 < $p1 - 1; ++$v_2) {
            if ((1 & $v_1 >>> $v_2) === 1) {
                ++$v_0;
            }
        }
        return $v_0 - 1;
    },
    $K_0: function SP_DateTimeUtil_UmAlQuraCalendarImpl$$K_0($p0) {
        var $v_0 = new SP.DateTimeUtil.SimpleDate(0, 0, 0, 0);
        var $v_1 = $p0 - 109326 + 1;

        for (var $v_3 = 0; $v_3 < 134; ++$v_3) {
            if (this.$V_0[$v_3] <= $v_1 && this.$V_0[$v_3 + 1] >= $v_1) {
                $v_0.set_year(1318 + $v_3);
                $v_1 -= this.$V_0[$v_3];
            }
        }
        var $v_2 = this.$a_0[$v_0.get_year() - 1318];

        for (var $v_4 = 0; $v_4 < 12; ++$v_4) {
            var $v_5 = 29;

            $v_5 += 1 & $v_2 >> $v_4;
            if ($v_5 < $v_1) {
                $v_1 -= $v_5;
            }
            else {
                $v_0.set_month($v_4 + 1);
                $v_4 = 12;
            }
        }
        $v_0.set_day($v_1);
        return $v_0;
    },
    $6_0: function SP_DateTimeUtil_UmAlQuraCalendarImpl$$6_0() {
        return 12;
    },
    $A_0: function SP_DateTimeUtil_UmAlQuraCalendarImpl$$A_0($p0, $p1) {
        var $v_0 = this.$a_0[$p0 - 1318];
        var $v_1 = 29 + ((1 & $v_0 >>> $p1 - 1) === 1 ? 1 : 0);

        return $v_1;
    },
    $n_0: function SP_DateTimeUtil_UmAlQuraCalendarImpl$$n_0() {
        var $v_0 = new Date();

        return SP.DateTimeUtil.GregorianCalendarImpl.$M($v_0.getFullYear(), $v_0.getMonth() + 1, $v_0.getDate());
    }
};
SP.DateTimeUtil.SolarCalendarImpl = function SP_DateTimeUtil_SolarCalendarImpl() {
};
SP.DateTimeUtil.SolarCalendarImpl.$8 = function SP_DateTimeUtil_SolarCalendarImpl$$8($p0) {
    return 0 === $p0 % 400 ? true : 0 === $p0 % 100 ? false : 0 === $p0 % 4 ? true : false;
};
SP.DateTimeUtil.SolarCalendarImpl.$6 = function SP_DateTimeUtil_SolarCalendarImpl$$6() {
    return SP.DateTimeUtil.SolarCalendarImpl._MonthsInYear;
};
SP.DateTimeUtil.SimpleDate = function SP_DateTimeUtil_SimpleDate(year, month, day, era) {
    this.$2_0 = year;
    this.$3_0 = month;
    this.$4_0 = day;
    this.$9_0 = era;
    this.$1I_0 = year + month + day + era;
};
SP.DateTimeUtil.SimpleDate.dateGreater = function SP_DateTimeUtil_SimpleDate$dateGreater(di0, di) {
    return di0.get_era() > di.get_era() || di0.get_era() === di.get_era() && (di0.get_year() > di.get_year() || di0.get_year() === di.get_year() && (di0.get_month() > di.get_month() || di0.get_month() === di.get_month() && di0.get_day() > di.get_day()));
};
SP.DateTimeUtil.SimpleDate.dateLess = function SP_DateTimeUtil_SimpleDate$dateLess(di0, di) {
    return di0.get_era() < di.get_era() || di0.get_era() === di.get_era() && (di0.get_year() < di.get_year() || di0.get_year() === di.get_year() && (di0.get_month() < di.get_month() || di0.get_month() === di.get_month() && di0.get_day() < di.get_day()));
};
SP.DateTimeUtil.SimpleDate.dateGreaterEqual = function SP_DateTimeUtil_SimpleDate$dateGreaterEqual(di0, di) {
    return !SP.DateTimeUtil.SimpleDate.dateLess(di0, di);
};
SP.DateTimeUtil.SimpleDate.dateLessEqual = function SP_DateTimeUtil_SimpleDate$dateLessEqual(di0, di) {
    return !SP.DateTimeUtil.SimpleDate.dateGreater(di0, di);
};
SP.DateTimeUtil.SimpleDate.dateEquals = function SP_DateTimeUtil_SimpleDate$dateEquals(di0, di) {
    return di0.get_year() === di.get_year() && di0.get_month() === di.get_month() && di0.get_day() === di.get_day();
};
SP.DateTimeUtil.SimpleDate.prototype = {
    $2_0: 0,
    $3_0: 0,
    $4_0: 0,
    $9_0: 0,
    $1I_0: 0,
    get_year: function SP_DateTimeUtil_SimpleDate$get_year() {
        return this.$2_0;
    },
    set_year: function SP_DateTimeUtil_SimpleDate$set_year(value) {
        this.$2_0 = value << 0;
        return value;
    },
    get_month: function SP_DateTimeUtil_SimpleDate$get_month() {
        return this.$3_0;
    },
    set_month: function SP_DateTimeUtil_SimpleDate$set_month(value) {
        this.$3_0 = value << 0;
        return value;
    },
    get_day: function SP_DateTimeUtil_SimpleDate$get_day() {
        return this.$4_0;
    },
    set_day: function SP_DateTimeUtil_SimpleDate$set_day(value) {
        this.$4_0 = value << 0;
        return value;
    },
    get_era: function SP_DateTimeUtil_SimpleDate$get_era() {
        return this.$9_0;
    },
    set_era: function SP_DateTimeUtil_SimpleDate$set_era(value) {
        this.$9_0 = value << 0;
        return value;
    },
    equals: function SP_DateTimeUtil_SimpleDate$equals(o) {
        return SP.DateTimeUtil.SimpleDate.dateEquals(this, o);
    },
    getHashCode: function SP_DateTimeUtil_SimpleDate$getHashCode() {
        return this.$1I_0;
    }
};
SP.DateTimeUtil.SPRelativeDateTime = function SP_DateTimeUtil_SPRelativeDateTime() {
};
SP.DateTimeUtil.SPRelativeDateTime.getRelativeDateTimeString = function SP_DateTimeUtil_SPRelativeDateTime$getRelativeDateTimeString(date, bIncludeTime, calendarType, bAdjustToServersNowTime) {
    var $v_0 = SP.DateTimeUtil.SPRelativeDateTime.$1W(date, bIncludeTime, calendarType, bAdjustToServersNowTime);

    return GetRelativeDateTimeString($v_0);
};
SP.DateTimeUtil.SPRelativeDateTime.$1W = function SP_DateTimeUtil_SPRelativeDateTime$$1W($p0, $p1, $p2, $p3) {
    var $v_0 = Sys.CultureInfo.CurrentCulture.dateTimeFormat['FirstDayOfWeek'];
    var $v_1 = Sys.CultureInfo.CurrentCulture.name;
    var $v_2 = new Date();

    if ($p3) {
        var $v_3 = window.self._spPageContextInfo.clientServerTimeDelta;

        if ($v_3) {
            $v_2 = new Date($v_2.getTime() + $v_3);
        }
    }
    return SP.DateTimeUtil.SPRelativeDateTime.$1X($v_2, $p0, $p1, $v_0, $p2, function($p1_0) {
        return (SP.DateTimeUtil.SPRelativeDateTime.$p($p1_0, $p2)).format('t', $v_1);
    }, function($p1_0) {
        return (SP.DateTimeUtil.SPRelativeDateTime.$p($p1_0, $p2)).format('dddd', $v_1);
    }, function($p1_0) {
        return (SP.DateTimeUtil.SPRelativeDateTime.$p($p1_0, $p2)).format('M', $v_1);
    }, function($p1_0) {
        return (SP.DateTimeUtil.SPRelativeDateTime.$p($p1_0, $p2)).format('yyyy', $v_1);
    });
};
SP.DateTimeUtil.SPRelativeDateTime.$p = function SP_DateTimeUtil_SPRelativeDateTime$$p($p0, $p1) {
    return SP.DateTimeUtil.IntlDate.createFromJsLocalDate($p0, $p1);
};
SP.DateTimeUtil.SPRelativeDateTime.$1X = function SP_DateTimeUtil_SPRelativeDateTime$$1X($p0, $p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8) {
    var $v_0 = SP.DateTimeUtil.IntlDate.createFromJsLocalDate($p1, $p4);
    var $v_1 = SP.DateTimeUtil.IntlDate.createFromJsLocalDate($p0, $p4);
    var $v_2 = SP.DateTimeUtil.SPRelativeDateTime.$o($p1);
    var $v_3 = SP.DateTimeUtil.SPRelativeDateTime.$o($p0);
    var $v_4 = ($p1 - $p0) / 1000;
    var $v_5 = Math.abs($v_4);
    var $v_6 = $v_5 / 60;
    var $v_7 = $v_6 / 60;
    var $v_8 = $v_2 - $v_3;

    $v_8 = Math.round($v_8 / 1000 / 60 / SP.DateTimeUtil.SPRelativeDateTime.$X);
    var $v_9 = Math.abs($v_8);
    var $v_A = $v_4 > 6;

    if (!$p2 && SP.DateTimeUtil.SPRelativeDateTime.$1Q($p1, $p0)) {
        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 9);
    }
    if ($v_5 < 30) {
        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 1);
    }
    if ($v_5 < 120) {
        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 2);
    }
    if ($v_6 <= 50) {
        var $v_G = (Math.round($v_6)).toString();

        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 3, $v_G);
    }
    if ($v_6 <= 110) {
        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 4);
    }
    var $v_B = SP.DateTimeUtil.IntlDate.createFromJsLocalDate($v_3, $p4);

    $v_B.addDays(-1);
    var $v_C = SP.DateTimeUtil.IntlDate.createFromJsLocalDate($v_3, $p4);

    $v_C.addDays(1);
    var $v_D = ($v_B.toJsDate()).getTime() === $v_2.getTime();
    var $v_E = ($v_C.toJsDate()).getTime() === $v_2.getTime();

    if ($v_D || $v_E) {
        if ($p2) {
            return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 5, $p5($p1));
        }
        else {
            return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 5);
        }
    }
    if ($v_7 < 24) {
        var $v_H = SP.DateTimeUtil.SPRelativeDateTime.$1O(Math.round($v_7));

        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 6, $v_H);
    }
    var $v_F = SP.DateTimeUtil.SPRelativeDateTime.$1d($p1.getDay(), $p0.getDay(), $p3, $v_8);

    if ($v_F) {
        var $v_I = $p6($p1);

        if ($p2) {
            return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 7, $v_I, $p5($p1));
        }
        else {
            return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 7, $v_I);
        }
    }
    if ($v_9 <= 6) {
        var $v_J = SP.DateTimeUtil.SPRelativeDateTime.$1O($v_9);

        return SP.DateTimeUtil.SPRelativeDateTime.$D($v_A, 8, $v_J);
    }
    if (SP.DateTimeUtil.SPRelativeDateTime.$1e($p1, $p0)) {
        return String.format('0|{0}', $p7($p1));
    }
    else {
        var $v_K = Strings.STS.L_RelativeDateTime_Format_DateTimeFormattingString_Override;

        if ($v_K === 'ShortDatePattern') {
            return '0|' + $p1.localeFormat('d');
        }
        if ($v_K === 'LongDatePattern') {
            return '0|' + $p1.localeFormat('D');
        }
        var $v_L = $p7($p1);
        var $v_M = $p8($p1);
        var $v_N = '0|' + Strings.STS.L_RelativeDateTime_Format_DateTimeFormattingString;

        return String.format($v_N, $v_L, $v_M);
    }
};
SP.DateTimeUtil.SPRelativeDateTime.$1Q = function SP_DateTimeUtil_SPRelativeDateTime$$1Q($p0, $p1) {
    return (SP.DateTimeUtil.SPRelativeDateTime.$o($p0)).getTime() === (SP.DateTimeUtil.SPRelativeDateTime.$o($p1)).getTime();
};
SP.DateTimeUtil.SPRelativeDateTime.$o = function SP_DateTimeUtil_SPRelativeDateTime$$o($p0) {
    return new Date($p0.getFullYear(), $p0.getMonth(), $p0.getDate());
};
SP.DateTimeUtil.SPRelativeDateTime.$1e = function SP_DateTimeUtil_SPRelativeDateTime$$1e($p0, $p1) {
    return $p0.getFullYear() === $p1.getFullYear();
};
SP.DateTimeUtil.SPRelativeDateTime.$1O = function SP_DateTimeUtil_SPRelativeDateTime$$1O($p0) {
    return $p0.toString();
};
SP.DateTimeUtil.SPRelativeDateTime.$1d = function SP_DateTimeUtil_SPRelativeDateTime$$1d($p0, $p1, $p2, $p3) {
    var $v_0 = ($p0 + (7 - $p2)) % 7;
    var $v_1 = ($p1 + (7 - $p2)) % 7;
    var $v_2 = $p3 < 7 && $p3 > -7 && ($p3 > 0 && $v_0 - $v_1 > 0 || $p3 < 0 && $v_1 - $v_0 > 0 || !$p3);

    return $v_2;
};
SP.DateTimeUtil.SPRelativeDateTime.$D = function SP_DateTimeUtil_SPRelativeDateTime$$D($p0, $p1) {
    var $p2 = [];

    for (var $$pai_7 = 2; $$pai_7 < arguments.length; ++$$pai_7) {
        $p2[$$pai_7 - 2] = arguments[$$pai_7];
    }
    var $v_0 = '1';
    var $v_1 = String.format('{0}|{1}|{2}', $v_0, $p0 ? 1 : 0, $p1);

    for (var $v_2 = 0; $v_2 < $p2.length; $v_2++) {
        var $v_3 = $p2[$v_2];

        $v_1 += '|' + $v_3;
    }
    return $v_1;
};
SP.DateTimeUtil.DateFormat = function SP_DateTimeUtil_DateFormat() {
};
SP.DateTimeUtil.DateFormat.$$cctor = function SP_DateTimeUtil_DateFormat$$$cctor() {
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(1, 3, 1868, 9, 8, '\u660e\u6cbb'));
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(2, 3, 1912, 7, 30, '\u5927\u6b63'));
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(3, 3, 1926, 12, 25, '\u662d\u548c'));
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(4, 3, 1989, 1, 8, '\u5e73\u6210'));
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(1, 4, 1912, 1, 1, '\u4e2d\u83ef\u6c11\u570b'));
    Array.add(SP.DateTimeUtil.DateFormat.$J, new SP.DateTimeUtil.DateFormat.EraInfo(1, 5, 2333, 1, 1, '\ub2e8\uae30'));
};
SP.DateTimeUtil.DateFormat.$1h = function SP_DateTimeUtil_DateFormat$$1h($p0) {
    return SP.DateTimeUtil.DateFormat.$m(SP.DateTimeUtil.DateFormat.$1B, $p0);
};
SP.DateTimeUtil.DateFormat.$1i = function SP_DateTimeUtil_DateFormat$$1i($p0) {
    return SP.DateTimeUtil.DateFormat.$m(SP.DateTimeUtil.DateFormat.$1E, $p0);
};
SP.DateTimeUtil.DateFormat.$1b = function SP_DateTimeUtil_DateFormat$$1b($p0) {
    return SP.DateTimeUtil.DateFormat.$m(SP.DateTimeUtil.DateFormat.$13, $p0);
};
SP.DateTimeUtil.DateFormat.$1c = function SP_DateTimeUtil_DateFormat$$1c($p0) {
    return SP.DateTimeUtil.DateFormat.$m(SP.DateTimeUtil.DateFormat.$14, $p0);
};
SP.DateTimeUtil.DateFormat.$m = function SP_DateTimeUtil_DateFormat$$m($p0, $p1) {
    var $v_0 = new RegExp($p1.toLowerCase());

    return (($p0.join(',')).toLowerCase()).search($v_0) > 0;
};
SP.DateTimeUtil.DateFormat.$1g = function SP_DateTimeUtil_DateFormat$$1g($p0) {
    return $p0 === 15 || $p0 === 14;
};
SP.DateTimeUtil.DateFormat.$1j = function SP_DateTimeUtil_DateFormat$$1j($p0) {
    return $p0 === 8;
};
SP.DateTimeUtil.DateFormat.$1f = function SP_DateTimeUtil_DateFormat$$1f($p0) {
    return $p0 === 4 || $p0 === 3 || $p0 === 5;
};
SP.DateTimeUtil.DateFormat.$1T = function SP_DateTimeUtil_DateFormat$$1T($p0) {
    for (var $v_0 = 0; $v_0 < SP.DateTimeUtil.DateFormat.$J.length; $v_0++) {
        var $v_1 = SP.DateTimeUtil.DateFormat.$J[$v_0];

        if ($v_1.$12_0 === $p0.$1_0) {
            if ($p0.get_era() === $v_1.$16_0) {
                return $v_1.$1N_0;
            }
        }
    }
    throw Error.argumentOutOfRange();
};
SP.DateTimeUtil.DateFormat.$17 = function SP_DateTimeUtil_DateFormat$$17($p0, $p1, $p2) {
    var $v_0 = '';
    var $v_1;

    if ($p0.$1_0 === 4) {
        $v_1 = SP.DateTimeUtil.DateFormat.$1P;
    }
    else if ($p0.$1_0 === 5) {
        $v_1 = SP.DateTimeUtil.DateFormat.$1F;
    }
    else if ($p0.$1_0 === 3) {
        $v_1 = SP.DateTimeUtil.DateFormat.$1C;
    }
    else {
        throw Error.argumentOutOfRange();
    }
    switch ($p2) {
    case 2:
        $v_0 = ($p0.get_day()).toString();
        break;
    case 1:
        $v_0 = ($p0.get_month()).toString() + $v_1[$p2];
        break;
    case 0:
        $v_0 = ($p0.get_year()).toString();
        break;
    case 3:
        $v_0 = SP.DateTimeUtil.DateFormat.$1T($p0);
        break;
    }
    return $v_0;
};
SP.DateTimeUtil.DateFormat.prototype = {
    $1K_0: function SP_DateTimeUtil_DateFormat$$1K_0($p0, $p1, $p2) {
        var $v_0 = Sys.CultureInfo.CurrentCulture.dateTimeFormat;

        if (SP.DateTimeUtil.DateFormat.$1f($p0.$1_0)) {
            return SP.DateTimeUtil.DateFormat.$17($p0, $p1, 1);
        }
        else if (SP.DateTimeUtil.DateFormat.$1g($p0.$1_0) && $p0.lunarLeapMonth() !== -1) {
            var $v_1 = $p0.get_month() >= $p0.lunarLeapMonth() ? $p0.get_month() - 2 : $p0.get_month() - 1;
            var $v_2 = '';

            if ($p0.$1_0 === 14 && SP.DateTimeUtil.DateFormat.$1i($p1)) {
                $v_2 = SP.DateTimeUtil.DateFormat.$1G;
            }
            else if ($p0.$1_0 === 14 && SP.DateTimeUtil.DateFormat.$1h($p1)) {
                $v_2 = SP.DateTimeUtil.DateFormat.$1D;
            }
            else if ($p0.$1_0 === 15 && SP.DateTimeUtil.DateFormat.$1b($p1)) {
                $v_2 = SP.DateTimeUtil.DateFormat.$1L;
            }
            else if ($p0.$1_0 === 15 && SP.DateTimeUtil.DateFormat.$1c($p1)) {
                $v_2 = SP.DateTimeUtil.DateFormat.$15;
            }
            else {
                throw Error.argumentOutOfRange();
            }
            return $v_2 + $v_0[this.$1M_0($p2)][$v_1];
        }
        else if (SP.DateTimeUtil.DateFormat.$1j($p0.$1_0) && $p0.lunarLeapMonth() !== -1) {
            switch ($p2) {
            case 2:
            case 0:
                return $v_0['AbbreviatedLeapMonthNames'][$p0.get_month() - 1];
            case 3:
            case 1:
                return $v_0['LeapMonthNames'][$p0.get_month() - 1];
            default:
                throw Error.argumentOutOfRange();
            }
        }
        else {
            return $v_0[this.$1M_0($p2)][$p0.get_month() - 1];
        }
    },
    $1M_0: function SP_DateTimeUtil_DateFormat$$1M_0($p0) {
        switch ($p0) {
        case 2:
            return 'AbbreviatedMonthGenitiveNames';
        case 0:
            return 'AbbreviatedMonthNames';
        case 3:
            return 'MonthGenitiveNames';
        case 1:
            return 'MonthNames';
        default:
            throw Error.argumentOutOfRange();
        }
    },
    $C_0: function SP_DateTimeUtil_DateFormat$$C_0($p0, $p1, $p2) {
        if ($p0.length < $p1) {
            var $v_0 = '';

            for (var $v_1 = 0; $v_1 < $p1 - $p0.length; $v_1++) {
                $v_0 += $p2;
            }
            $p0 = $v_0 + $p0;
        }
        return $p0;
    },
    format: function SP_DateTimeUtil_DateFormat$format($p0, $p1, $p2) {
        var $v_0 = Sys.CultureInfo.CurrentCulture.dateTimeFormat;

        if (!$p2.length) {
            $p2 = Sys.CultureInfo.InvariantCulture.name;
        }
        if ($p1.length === 1) {
            switch ($p1.charAt(0)) {
            case 'f':
                $p1 = $v_0['LongDatePattern'] + ' ' + $v_0['ShortTimePattern'];
                break;
            case 'F':
                $p1 = $v_0['FullDateTimePattern'];
                break;
            case 'd':
                $p1 = $v_0['ShortDatePattern'];
                break;
            case 'D':
                $p1 = $v_0['LongDatePattern'];
                break;
            case 'm':
            case 'M':
                $p1 = $v_0['MonthDayPattern'];
                break;
            case 't':
                $p1 = $v_0['ShortTimePattern'];
                break;
            case 'T':
                $p1 = $v_0['LongTimePattern'];
                break;
            case 'g':
                $p1 = $v_0['ShortDatePattern'] + ' ' + $v_0['ShortTimePattern'];
                break;
            case 'G':
                $p1 = $v_0['ShortDatePattern'] + ' ' + $v_0['LongTimePattern'];
                break;
            case 'R':
            case 'r':
                $p1 = $v_0['RFC1123Pattern'];
                break;
            case 'u':
                $p1 = $v_0['UniversalSortableDateTimePattern'];
                break;
            case 'U':
                $p1 = $v_0['FullDateTimePattern'];
                break;
            case 's':
                $p1 = $v_0['SortableDateTimePattern'];
                break;
            }
        }
        if ($p1.charAt(0) === '%') {
            $p1 = $p1.substr(1);
        }
        var $v_1 = new Sys.StringBuilder();

        SP.DateTimeUtil.DateFormat.$W.lastIndex = 0;
        while (true) {
            var $v_2 = SP.DateTimeUtil.DateFormat.$W.lastIndex;
            var $v_3 = SP.DateTimeUtil.DateFormat.$W.exec($p1);

            $v_1.append($p1.substring($v_2, $v_3 ? $v_3.index : $p1.length));
            if (!$v_3) {
                break;
            }
            var $v_4 = $v_3.toString();
            var $v_5 = $v_4;

            switch ($v_4) {
            case '\'':
                var $v_6 = $p1.indexOf('\'', $v_2 + 1);

                if ($v_6 > $v_2) {
                    $v_5 = $p1.substring($v_2 + 1, $v_6);
                    SP.DateTimeUtil.DateFormat.$W.lastIndex = $v_6 + 1;
                }
                else {
                    $v_5 = '';
                }
                break;
            case 'w':
                $v_5 = ($p0.get_weekOfYear()).toString();
                break;
            case ':':
                $v_5 = $v_0['TimeSeparator'];
                break;
            case '/':
                $v_5 = $v_0['DateSeparator'];
                break;
            case 'rrr':
                var $v_8 = '';
                var $v_9 = $p0.get_monthThird();

                if ($v_9 === 1) {
                    $v_8 = '1';
                }
                else if ($v_9 === 2) {
                    $v_8 = '11';
                }
                else if ($v_9 === 3) {
                    $v_8 = '21';
                }
                else {
                    throw Error.argumentOutOfRange();
                }
                $v_5 = $v_8;
                break;
            case 'rr':
            case 'r':
                $v_5 = ($p0.get_monthThird()).toString();
                break;
            case 'l':
                $v_5 = ($p0.get_halfYear()).toString();
                break;
            case 'q':
                $v_5 = ($p0.get_quarter()).toString();
                break;
            case 'ddddd':
                $v_5 = $v_0['ShortestDayNames'][$p0.get_dayOfWeek()];
                break;
            case 'dddd':
                $v_5 = $v_0['DayNames'][$p0.get_dayOfWeek()];
                break;
            case 'ddd':
                $v_5 = $v_0['AbbreviatedDayNames'][$p0.get_dayOfWeek()];
                break;
            case 'dd':
                $v_5 = this.$C_0(($p0.get_day()).toString(), 2, '0');
                break;
            case 'd':
                $v_5 = ($p0.get_day()).toString();
                break;
            case 'MMMM':
                $v_5 = this.$1K_0($p0, $p2, 1);
                break;
            case 'MMM':
                $v_5 = this.$1K_0($p0, $p2, 0);
                break;
            case 'MM':
                $v_5 = this.$C_0(($p0.get_month()).toString(), 2, '0');
                break;
            case 'M':
                $v_5 = ($p0.get_month()).toString();
                break;
            case 'yyyy':
                $v_5 = ($p0.get_year()).toString();
                break;
            case 'yy':
                $v_5 = this.$C_0(($p0.get_year() % 100).toString(), 2, '0');
                break;
            case 'y':
                $v_5 = ($p0.get_year() % 100).toString();
                break;
            case 'h':
            case 'hh':
                var $v_7 = $p0.get_hours() % 12;

                if ($v_7) {
                    $v_5 = $v_7.toString();
                }
                else {
                    $v_5 = '12';
                }
                if ($v_4 === 'hh') {
                    $v_5 = this.$C_0($v_5.toString(), 2, '0');
                }
                break;
            case 'HH':
                $v_5 = this.$C_0(($p0.get_hours()).toString(), 2, '0');
                break;
            case 'H':
                $v_5 = ($p0.get_hours()).toString();
                break;
            case 'mm':
                $v_5 = this.$C_0(($p0.get_minutes()).toString(), 2, '0');
                break;
            case 'm':
                $v_5 = ($p0.get_minutes()).toString();
                break;
            case 'ss':
                $v_5 = this.$C_0(($p0.get_seconds()).toString(), 2, '0');
                break;
            case 's':
                $v_5 = ($p0.get_seconds()).toString();
                break;
            case 'am':
                $v_5 = $v_0['AMDesignator'];
                break;
            case 'pm':
                $v_5 = $v_0['PMDesignator'];
                break;
            case 't':
            case 'tt':
                $v_5 = $p0.get_hours() < 12 ? $v_0['AMDesignator'] : $v_0['PMDesignator'];
                if ($v_4 === 't') {
                    $v_5 = ($v_5.charAt(0)).toString();
                }
                break;
            case 'fff':
                $v_5 = this.$C_0(($p0.get_milliSeconds()).toString(), 3, '0');
                break;
            case 'ff':
                $v_5 = (this.$C_0(($p0.get_milliSeconds()).toString(), 3, ' ')).substr(0, 2);
                break;
            case 'f':
                $v_5 = ((this.$C_0(($p0.get_milliSeconds()).toString(), 3, ' ')).charAt(0)).toString();
                break;
            case 'gg':
                $v_5 = SP.DateTimeUtil.DateFormat.$17($p0, $p2, 3);
                break;
            case 'z':
                var $v_A = $p0.get_timezoneOffset() / 60;

                $v_5 = ($v_A >= 0 ? '-' : '+') + Math.floor(Math.abs($v_A));
                break;
            case 'zz':
            case 'zzz':
                var $v_B = $p0.get_timezoneOffset() / 60;

                $v_5 = ($v_B >= 0 ? '-' : '+') + this.$C_0((Math.floor(Math.abs($v_B))).toString(), 2, '0');
                if ($v_4 === 'zzz') {
                    $v_5 += $v_0['TimeSeparator'] + this.$C_0((Math.abs($p0.get_timezoneOffset() % 60)).toString(), 2, '0');
                }
                break;
            }
            $v_1.append($v_5);
        }
        return $v_1.toString();
    }
};
SP.DateTimeUtil.DateFormat.EraInfo = function SP_DateTimeUtil_DateFormat_EraInfo($p0, $p1, $p2, $p3, $p4, $p5) {
    this.$12_0 = $p1;
    this.$16_0 = $p0;
    this.$1v_0 = $p2;
    this.$1u_0 = $p3;
    this.$1t_0 = $p4;
    this.$1N_0 = $p5;
};
SP.DateTimeUtil.DateFormat.EraInfo.prototype = {
    $12_0: 0,
    $16_0: 0,
    $1v_0: 0,
    $1u_0: 0,
    $1t_0: 0,
    $1N_0: null
};
SP.DateTimeUtil.SolarCalendarImpl.registerClass('SP.DateTimeUtil.SolarCalendarImpl');
SP.DateTimeUtil.GregorianCalendarImpl.registerClass('SP.DateTimeUtil.GregorianCalendarImpl', SP.DateTimeUtil.SolarCalendarImpl);
SP.DateTimeUtil.SPIntlCal.registerClass('SP.DateTimeUtil.SPIntlCal');
SP.DateTimeUtil.SPGregorianCalendar.registerClass('SP.DateTimeUtil.SPGregorianCalendar', null, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPJapaneseCalendar.registerClass('SP.DateTimeUtil.SPJapaneseCalendar', SP.DateTimeUtil.SPGregorianCalendar);
SP.DateTimeUtil.SPThaiCalendar.registerClass('SP.DateTimeUtil.SPThaiCalendar', SP.DateTimeUtil.SPGregorianCalendar);
SP.DateTimeUtil.SPTaiwaneseCalendar.registerClass('SP.DateTimeUtil.SPTaiwaneseCalendar', SP.DateTimeUtil.SPGregorianCalendar);
SP.DateTimeUtil.SPKoreanCalendar.registerClass('SP.DateTimeUtil.SPKoreanCalendar', SP.DateTimeUtil.SPGregorianCalendar);
SP.DateTimeUtil.SPSakaCalendar.registerClass('SP.DateTimeUtil.SPSakaCalendar', null, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPHijriCalendar.registerClass('SP.DateTimeUtil.SPHijriCalendar', null, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPHebrewCalendar.registerClass('SP.DateTimeUtil.SPHebrewCalendar', null, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPFarEastLunarCalendar.registerClass('SP.DateTimeUtil.SPFarEastLunarCalendar');
SP.DateTimeUtil.SPChineseLunarCalendar.registerClass('SP.DateTimeUtil.SPChineseLunarCalendar', SP.DateTimeUtil.SPFarEastLunarCalendar, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPJapaneseLunarCalendar.registerClass('SP.DateTimeUtil.SPJapaneseLunarCalendar', SP.DateTimeUtil.SPFarEastLunarCalendar, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.SPUmAlQuraCalendar.registerClass('SP.DateTimeUtil.SPUmAlQuraCalendar', null, SP.DateTimeUtil.ISPCalendar);
SP.DateTimeUtil.IntlDate.registerClass('SP.DateTimeUtil.IntlDate');
SP.DateTimeUtil.GetMonthAdvanceInfoScriptSharpReturn.registerClass('SP.DateTimeUtil.GetMonthAdvanceInfoScriptSharpReturn');
SP.DateTimeUtil.SPCalendarUtil.registerClass('SP.DateTimeUtil.SPCalendarUtil');
SP.DateTimeUtil.SakaCalendarImpl.registerClass('SP.DateTimeUtil.SakaCalendarImpl', SP.DateTimeUtil.SolarCalendarImpl);
SP.DateTimeUtil.HijriCalendarImpl.registerClass('SP.DateTimeUtil.HijriCalendarImpl');
SP.DateTimeUtil.HebrewCalendarImpl.registerClass('SP.DateTimeUtil.HebrewCalendarImpl');
SP.DateTimeUtil.FarEastLunarCalendarImpl.registerClass('SP.DateTimeUtil.FarEastLunarCalendarImpl');
SP.DateTimeUtil.ChineseLunarCalendarImpl.registerClass('SP.DateTimeUtil.ChineseLunarCalendarImpl', SP.DateTimeUtil.FarEastLunarCalendarImpl);
SP.DateTimeUtil.JapaneseLunarCalendarImpl.registerClass('SP.DateTimeUtil.JapaneseLunarCalendarImpl', SP.DateTimeUtil.FarEastLunarCalendarImpl);
SP.DateTimeUtil.UmAlQuraCalendarImpl.registerClass('SP.DateTimeUtil.UmAlQuraCalendarImpl');
SP.DateTimeUtil.SimpleDate.registerClass('SP.DateTimeUtil.SimpleDate');
SP.DateTimeUtil.SPRelativeDateTime.registerClass('SP.DateTimeUtil.SPRelativeDateTime');
SP.DateTimeUtil.DateFormat.registerClass('SP.DateTimeUtil.DateFormat');
SP.DateTimeUtil.DateFormat.EraInfo.registerClass('SP.DateTimeUtil.DateFormat.EraInfo');
function sp_datetimeutil_initialize() {
    SP.DateTimeUtil.GregorianCalendarImpl.$7 = [[0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365], [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]];
    SP.DateTimeUtil.SPIntlCal.daysInWeek = 7;
    SP.DateTimeUtil.SPIntlCal.maxJDay = 2666269;
    SP.DateTimeUtil.SPIntlCal.$c = null;
    SP.DateTimeUtil.SPIntlCal.$f = null;
    SP.DateTimeUtil.SPIntlCal.$j = null;
    SP.DateTimeUtil.SPIntlCal.$h = null;
    SP.DateTimeUtil.SPIntlCal.$i = null;
    SP.DateTimeUtil.SPIntlCal.$e = null;
    SP.DateTimeUtil.SPIntlCal.$d = null;
    SP.DateTimeUtil.SPIntlCal.$k = null;
    SP.DateTimeUtil.SPIntlCal.$Z = null;
    SP.DateTimeUtil.SPIntlCal.$g = null;
    SP.DateTimeUtil.SPIntlCal.$l = null;
    SP.DateTimeUtil.SPHijriCalendar.$1J = -3;
    SP.DateTimeUtil.IntlDate.$R = 60 * 1000;
    SP.DateTimeUtil.IntlDate.$Q = 60 * SP.DateTimeUtil.IntlDate.$R;
    SP.DateTimeUtil.IntlDate.$P = 24 * SP.DateTimeUtil.IntlDate.$Q;
    SP.DateTimeUtil.IntlDate.$q = null;
    SP.DateTimeUtil.SolarCalendarImpl._MonthsInYear = 12;
    SP.DateTimeUtil.SolarCalendarImpl._DaysIn400Years = 146097;
    SP.DateTimeUtil.SPRelativeDateTime.$X = 24 * 60;
    SP.DateTimeUtil.SPRelativeDateTime.$1y = 2 * SP.DateTimeUtil.SPRelativeDateTime.$X;
    SP.DateTimeUtil.SPRelativeDateTime.$1r = 5 * SP.DateTimeUtil.SPRelativeDateTime.$X;
    SP.DateTimeUtil.SPRelativeDateTime.$1q = 32 * SP.DateTimeUtil.SPRelativeDateTime.$X;
    SP.DateTimeUtil.DateFormat.$1G = '\uc724';
    SP.DateTimeUtil.DateFormat.$1D = '\u958f';
    SP.DateTimeUtil.DateFormat.$15 = '\u958f';
    SP.DateTimeUtil.DateFormat.$1L = '\u95f0';
    SP.DateTimeUtil.DateFormat.$14 = ['zh-TW'];
    SP.DateTimeUtil.DateFormat.$13 = ['zh-Hant', 'zh-SG', 'zh-Hans', 'zh-CN', 'zh-MO'];
    SP.DateTimeUtil.DateFormat.$1E = ['ko', 'ko-KR'];
    SP.DateTimeUtil.DateFormat.$1B = ['ja', 'ja-JP'];
    SP.DateTimeUtil.DateFormat.$1C = ['\u5e74', '\u6708', '\u65e5'];
    SP.DateTimeUtil.DateFormat.$1F = ['\ub144', '\uc6d4', '\uc77c'];
    SP.DateTimeUtil.DateFormat.$1P = ['\u5e74', '\u6708', '\u65e5'];
    SP.DateTimeUtil.DateFormat.$J = [];
    SP.DateTimeUtil.DateFormat.$W = new RegExp('ddddd|dddd|ddd|dd|d|MMMM|MMM|MM|M|yyyy|yy|y|hh|h|HH|H|mm|m|q|l|rrr|rr|r|ss|s|am|pm|tt|t|fff|ff|f|w|gg|zzz|zz|z|\'', 'g');
    SP.DateTimeUtil.DateFormat.$$cctor();
}
;
sp_datetimeutil_initialize();
RegisterModuleInit("sp.datetimeutil.js", sp_datetimeutil_initialize);
function MakeJsDateObject() {
    return new Date();
}
function MakeJsDateObjectFromDateTimeParts(year, month, date, hours, minutes, seconds, milliseconds) {
    return new Date(year, month, date, hours, minutes, seconds, milliseconds);
}
function ULSHmB() {
    var a = {};

    a.ULSTeamName = "Microsoft SharePoint Foundation";
    a.ULSFileName = "datetime.commentedjs";
    return a;
}
function GetRelativeDateTimeString(g) {
    var b = null, c = null, d = g.split("|");

    if (d[0] == "0")
        return g.substring(2);
    var a = d[1] == "1", h = d[2], e = d.length >= 4 ? d[3] : null, f = d.length >= 5 ? d[4] : null;

    switch (h) {
    case "1":
        b = a ? Strings.STS.L_RelativeDateTime_AFewSecondsFuture : Strings.STS.L_RelativeDateTime_AFewSeconds;
        break;
    case "2":
        b = a ? Strings.STS.L_RelativeDateTime_AboutAMinuteFuture : Strings.STS.L_RelativeDateTime_AboutAMinute;
        break;
    case "3":
        c = GetLocalizedCountValue(a ? Strings.STS.L_RelativeDateTime_XMinutesFuture : Strings.STS.L_RelativeDateTime_XMinutes, a ? Strings.STS.L_RelativeDateTime_XMinutesFutureIntervals : Strings.STS.L_RelativeDateTime_XMinutesIntervals, Number(e));
        break;
    case "4":
        b = a ? Strings.STS.L_RelativeDateTime_AboutAnHourFuture : Strings.STS.L_RelativeDateTime_AboutAnHour;
        break;
    case "5":
        if (e == null)
            b = a ? Strings.STS.L_RelativeDateTime_Tomorrow : Strings.STS.L_RelativeDateTime_Yesterday;
        else
            c = a ? Strings.STS.L_RelativeDateTime_TomorrowAndTime : Strings.STS.L_RelativeDateTime_YesterdayAndTime;
        break;
    case "6":
        c = GetLocalizedCountValue(a ? Strings.STS.L_RelativeDateTime_XHoursFuture : Strings.STS.L_RelativeDateTime_XHours, a ? Strings.STS.L_RelativeDateTime_XHoursFutureIntervals : Strings.STS.L_RelativeDateTime_XHoursIntervals, Number(e));
        break;
    case "7":
        if (f == null)
            b = e;
        else
            c = Strings.STS.L_RelativeDateTime_DayAndTime;
        break;
    case "8":
        c = GetLocalizedCountValue(a ? Strings.STS.L_RelativeDateTime_XDaysFuture : Strings.STS.L_RelativeDateTime_XDays, a ? Strings.STS.L_RelativeDateTime_XDaysFutureIntervals : Strings.STS.L_RelativeDateTime_XDaysIntervals, Number(e));
        break;
    case "9":
        b = Strings.STS.L_RelativeDateTime_Today;
    }
    if (c != null) {
        b = c.replace("{0}", e);
        if (f != null)
            b = b.replace("{1}", f);
    }
    return b;
}
function GetLocalizedCountValue(m, l, f) {
    if (m == undefined || l == undefined || f == undefined)
        return null;
    var o = "", a = -1, h = [];

    Array.addRange(h, l.split("||"));
    for (var c = 0, r = h.length; c < r; c++) {
        var i = h[c];

        if (i == null || i == "")
            continue;
        var g = [];

        Array.addRange(g, i.split(","));
        for (var k = 0, q = g.length; k < q; k++) {
            var d = g[k];

            if (d == null || d == "")
                continue;
            if (isNaN(Number.parseInvariant(d))) {
                var b = d.split("-");

                if (b == null || b.length !== 2)
                    continue;
                var j, n;

                if (b[0] === "")
                    j = 0;
                else if (isNaN(Number.parseInvariant(b[0])))
                    continue;
                else
                    j = parseInt(b[0]);
                if (f >= j) {
                    if (b[1] === "") {
                        a = c;
                        break;
                    }
                    else if (isNaN(Number.parseInvariant(b[1])))
                        continue;
                    else
                        n = parseInt(b[1]);
                    if (f <= n) {
                        a = c;
                        break;
                    }
                }
            }
            else {
                var p = parseInt(d);

                if (f === p) {
                    a = c;
                    break;
                }
            }
        }
        if (a !== -1)
            break;
    }
    if (a !== -1) {
        var e = m.split("||");

        if (e != null && e[a] != null && e[a] != "")
            o = e[a];
    }
    return o;
}
function GetDaysAfterToday(d) {
    if (!("currentDateInLocalCalendar" in _spRegionalSettings))
        return 0;
    var a = _spRegionalSettings.currentDateInLocalCalendar;

    if (a == null)
        return 0;
    var b = new Date(a.getFullYear(), a.getMonth(), a.getDate()), e = d.getTime(), f = b.getTime(), c = e - f;

    return Math.floor(c / 864e5);
}
;
if (typeof Sys != "undefined" && Sys && Sys.Application) {
    Sys.Application.notifyScriptLoaded();
}
if (typeof NotifyScriptLoadedAndExecuteWaitingJobs == "function") {
    NotifyScriptLoadedAndExecuteWaitingJobs("sp.datetimeutil.js");
}
