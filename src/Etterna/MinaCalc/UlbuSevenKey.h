#pragma once

#include "UlbuBase.h"

#include "./Agnostic/HA_PatternMods/SpiderBracket.h"
#include "./Agnostic/HA_PatternMods/Delay.h"

/// 7k shares the skillset slots with 4k but rates them differently:
/// Stream is Delay, Jumpstream is Chordstream and Handstream is Bracket
struct TheSevenFootedBazoinkazoink : public Bazoinkazoink
{
	SpiderBracketMod _sb;
	DelayMod _delay;

	diffz _diffz;

	explicit TheSevenFootedBazoinkazoink(Calc& calc)
	  : Bazoinkazoink(calc)
	{
		_gchordstream.all_chord_sizes = true;
		// singles on a hand are delay here and should be able to stand
		// level with chordstream and brackets
		_gstream.max_mod = 1.06F;
	}

  private:
	const std::array<std::vector<int>, NUM_Skillset> pmods = { {
	  // Overall
	  {},

	  // Stream (Delay)
	  {
		  GStream,
		  DelayRhythm,
	  },

	  // Jumpstream (Chordstream)
	  {
		  GChordStream,
	  },

	  // Handstream (Bracket)
	  {
		  SpiderBracket,
	  },

	  // Stamina
	  {},

	  // Jackspeed
	  {},

	  // Chordjack
	  {
		  CJ,
	  },

	  // Technical
	  {
		  HandBalance,
	  },
	} };

	const std::array<float, NUM_Skillset> basescalers = {
		0.F, 1.F, 1.F, 0.98F, 0.93F, 1.F, 1.F, 1.F
	};

  public:
	const std::array<std::vector<int>, NUM_Skillset>& get_pmods() const override
	{
		return pmods;
	}
	const std::array<float, NUM_Skillset>& get_basescalers() const override
	{
		return basescalers;
	}
	void adj_diff_func(
	  const size_t& itv,
	  const int& hand,
	  float*& adj_diff,
	  float*& stam_base,
	  const float& adj_npsbase,
	  const int& ss,
	  std::array<float, NUM_Skillset>& pmod_product_cur_interval) override
	{
		switch (ss) {
			case Skill_Stream:
				break;
			case Skill_Jumpstream: {
				auto a = *adj_diff;
				auto b =
				  _calc.init_base_diff_vals.at(hand).at(NPSBase).at(itv) *
				  pmod_product_cur_interval[Skill_Handstream];
				*stam_base = std::max<float>(a, b);
			} break;
			case Skill_Handstream: {
				auto a = adj_npsbase;
				auto b =
				  _calc.init_base_diff_vals.at(hand).at(NPSBase).at(itv) *
				  pmod_product_cur_interval[Skill_Jumpstream];
				*stam_base = std::max<float>(a, b);
			} break;
			case Skill_JackSpeed:
				break;
			case Skill_Chordjack:
				break;
			case Skill_Technical:
				*adj_diff =
				  _calc.init_base_diff_vals.at(hand).at(TechBase).at(itv) *
				  pmod_product_cur_interval.at(ss) * basescalers.at(ss) /
				  std::max<float>(
					fastpow(_calc.pmod_vals.at(hand).at(CJ).at(itv) + 0.05F,
							2.F),
					1.F);
				break;
			default:
				break;
		}
	}

	void full_agnostic_reset() override
	{
		Bazoinkazoink::full_agnostic_reset();
		_sb.full_reset();
		_delay.full_reset();
	}

	void advance_agnostic_sequencing() override
	{
		Bazoinkazoink::advance_agnostic_sequencing();
		_sb.advance_sequencing(_mri->notes);
		_delay.advance_sequencing(_mri->ms_now);
	}

	void set_agnostic_pmods(const int& itv) override
	{
		Bazoinkazoink::set_agnostic_pmods(itv);
		PatternMods::set_agnostic(_sb._pmod, _sb(), itv, _calc);
		PatternMods::set_agnostic(_delay._pmod, _delay(), itv, _calc);
	}

	void full_hand_reset() override
	{
		Bazoinkazoink::full_hand_reset();
		_diffz.full_reset();
	}

	void set_sequenced_base_diffs(const int& itv) const override
	{
		_calc.init_base_diff_vals.at(hand)[TechBase].at(itv) =
		  _diffz._tc.get_itv_diff(
			_calc.init_base_diff_vals.at(hand)[NPSBase].at(itv), _calc);
	}

	void handle_dependent_interval_end(const int& itv) override
	{
		Bazoinkazoink::handle_dependent_interval_end(itv);
		_diffz.interval_end();
	}

#if !defined(STANDALONE_CALC) && !defined(PHPCALC)
	const std::string get_calc_param_xml() const override
	{
		return "Save/CalcParams_7k.xml";
	}

	void load_calc_params_internal(const XNode& params) const override
	{
		Bazoinkazoink::load_calc_params_internal(params);
		load_params_for_mod(&params, _sb._params, _sb.name);
		load_params_for_mod(&params, _delay._params, _delay.name);
	}

	XNode* make_param_node_internal(XNode* calcparams) const override
	{
		Bazoinkazoink::make_param_node_internal(calcparams);
		calcparams->AppendChild(make_mod_param_node(_sb._params, _sb.name));
		calcparams->AppendChild(
		  make_mod_param_node(_delay._params, _delay.name));
		return calcparams;
	}
#endif
};
