#pragma once
#include "../../PatternModHelpers.h"

#include <cmath>

/// Hand-Agnostic PatternMod detecting 7k delays.
/// Looks for rows that land off the rhythm the previous rows set up, like a
/// 16th stream with notes pushed a few ms early or late. Gaps that double,
/// halve or stay the same are regular; anything in between is a delay.
/// Pushes up (never down) the Delay skillset.
struct DelayMod
{
	const CalcPatternMod _pmod = DelayRhythm;
	const std::string name = "DelayMod";

#pragma region params

	float min_mod = 1.F;
	float max_mod = 1.3F;

	// proportion of off rhythm rows that gives max_mod
	float prop_scaler = 8.F;

	// how far (in octaves of gap ratio) from 1:1, 1:2 or 2:1 a gap has to
	// be to count as off rhythm
	float ratio_tolerance = 0.15F;

	// gaps longer than this are breaks, not rhythm
	float max_gap_ms = 250.F;

	float decay_factor = 0.05F;

	const std::vector<std::pair<std::string, float*>> _params{
		{ "min_mod", &min_mod },
		{ "max_mod", &max_mod },
		{ "prop_scaler", &prop_scaler },
		{ "ratio_tolerance", &ratio_tolerance },
		{ "max_gap_ms", &max_gap_ms },
		{ "decay_factor", &decay_factor },
	};
#pragma endregion params and param map

	float last_ms = 0.F;
	float rows = 0.F;
	float delayed_rows = 0.F;
	float last_mod = min_mod;
	float pmod = min_mod;

	void full_reset()
	{
		last_ms = 0.F;
		last_mod = min_mod;
		pmod = min_mod;
		interval_end();
	}

	void interval_end()
	{
		rows = 0.F;
		delayed_rows = 0.F;
	}

	void advance_sequencing(const float& ms_now)
	{
		if (ms_now <= 0.F || ms_now > max_gap_ms) {
			last_ms = 0.F;
			return;
		}

		if (last_ms > 0.F) {
			rows += 1.F;
			const auto octaves = std::fabs(std::log2(ms_now / last_ms));
			if (std::fabs(octaves - std::round(octaves)) > ratio_tolerance) {
				delayed_rows += 1.F;
			}
		}
		last_ms = ms_now;
	}

	void decay_mod()
	{
		pmod = std::clamp(last_mod - decay_factor, min_mod, max_mod);
		last_mod = pmod;
	}

	auto operator()() -> float
	{
		if (rows == 0.F) {
			interval_end();
			return neutral;
		}

		if (delayed_rows == 0.F) {
			decay_mod();
			interval_end();
			return pmod;
		}

		const auto prop = std::min(delayed_rows / rows * prop_scaler, 1.F);
		pmod = std::clamp(min_mod + (max_mod - min_mod) * fastsqrt(prop),
						  min_mod,
						  max_mod);
		last_mod = pmod;

		interval_end();
		return pmod;
	}
};
