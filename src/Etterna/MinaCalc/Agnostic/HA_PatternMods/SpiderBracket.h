#pragma once
#include "../../PatternModHelpers.h"

#include <bit>

/// Hand-Agnostic PatternMod detecting 7k brackets.
/// Looks for chords alternating with chords that weave between their
/// columns without jacking, like [135][246] or [13][24] ("spider webs").
/// Plain chordstream ([12][34]) and chordjacks don't count.
struct SpiderBracketMod
{
	const CalcPatternMod _pmod = SpiderBracket;
	const std::string name = "SpiderBracketMod";

#pragma region params

	float min_mod = 0.5F;
	float max_mod = 1.08F;

	// proportion of bracketing taps that gives max_mod
	float prop_scaler = 1.6F;

	// a chord sitting inside the other's span without crossing it, like
	// [17][34], is a weaker bracket than a full weave
	float nested_weight = 0.5F;
	// single notes splitting a chord, like [13]2[13]2
	float single_weight = 0.5F;

	float decay_factor = 0.05F;

	const std::vector<std::pair<std::string, float*>> _params{
		{ "min_mod", &min_mod },
		{ "max_mod", &max_mod },
		{ "prop_scaler", &prop_scaler },
		{ "nested_weight", &nested_weight },
		{ "single_weight", &single_weight },
		{ "decay_factor", &decay_factor },
	};
#pragma endregion params and param map

	unsigned last_notes = 0U;
	bool bracketing = false;
	float total_taps = 0.F;
	float bracket_taps = 0.F;
	float last_mod = min_mod;
	float pmod = min_mod;

	void full_reset()
	{
		last_notes = 0U;
		bracketing = false;
		last_mod = min_mod;
		pmod = min_mod;
		interval_end();
	}

	void interval_end()
	{
		total_taps = 0.F;
		bracket_taps = 0.F;
	}

	/// true if any column of a lies strictly inside the span of b
	static auto inside_span(const unsigned& a, const unsigned& b) -> bool
	{
		const auto lo = std::countr_zero(b);
		const auto hi = 31 - std::countl_zero(b);
		const auto between = ((1U << hi) - 1U) & ~((2U << lo) - 1U);
		return (a & between) != 0U;
	}

	/// how much the move from b to a counts as a bracket, 0 to 1
	auto weave(const unsigned& a, const unsigned& b) const -> float
	{
		const auto ca = std::popcount(a);
		const auto cb = std::popcount(b);
		if ((a & b) != 0U || ca == 0 || cb == 0 || (ca < 2 && cb < 2)) {
			return 0.F;
		}

		const auto a_in_b = inside_span(a, b);
		const auto b_in_a = inside_span(b, a);
		auto w = a_in_b && b_in_a ? 1.F
				 : a_in_b || b_in_a ? nested_weight
									: 0.F;
		if (ca < 2 || cb < 2) {
			w *= single_weight;
		}
		return w;
	}

	void advance_sequencing(const unsigned& notes)
	{
		const auto taps = static_cast<float>(std::popcount(notes));
		total_taps += taps;

		const auto w = weave(notes, last_notes);
		if (w > 0.F) {
			bracket_taps += w * taps;
			// the row that started the bracket is part of it too
			if (!bracketing) {
				bracket_taps +=
				  w * static_cast<float>(std::popcount(last_notes));
			}
			bracketing = true;
		} else {
			bracketing = false;
		}
		last_notes = notes;
	}

	void decay_mod()
	{
		pmod = std::clamp(last_mod - decay_factor, min_mod, max_mod);
		last_mod = pmod;
	}

	auto operator()() -> float
	{
		// empty interval, don't decay mod or update last_mod
		if (total_taps == 0.F) {
			return neutral;
		}

		if (bracket_taps == 0.F) {
			decay_mod();
			interval_end();
			return pmod;
		}

		const auto prop =
		  std::min(bracket_taps / total_taps * prop_scaler, 1.F);
		pmod = std::clamp(min_mod + (max_mod - min_mod) * fastsqrt(prop),
						  min_mod,
						  max_mod);
		last_mod = pmod;

		interval_end();
		return pmod;
	}
};
