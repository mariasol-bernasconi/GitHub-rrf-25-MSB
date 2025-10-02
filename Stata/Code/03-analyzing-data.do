* RRF 2025 - Analyzing Data Template	
*-------------------------------------------------------------------------------	
* Load data
*------------------------------------------------------------------------------- 
	
	*load analysis data 
	use "${data}/Final/TZA_CCT_analysis.dta", clear
	
*-------------------------------------------------------------------------------	
* Exploratory Analysis
*------------------------------------------------------------------------------- 
	
	* Area over treatment by districts 
	gr bar 	area_acre_w, ///
			over(treatment) ///
			by(district)

*-------------------------------------------------------------------------------	
* Final Analysis
*------------------------------------------------------------------------------- 


	* Bar graph by treatment for all districts 
	gr bar 	area_acre_w, ///
			over(treatment) ///
			asy ///
			by(district, row(1) note("") ///
			title("Area cultivated by treatment assignment across districts") ///
			legend(pos(6))) ///
			legend(order(0 "Assignment:" 1 "Control" 2 "Treatment") cols(3)) ///
			ytit("Average area cultivated (Acre)") ///
			blabel(bar, position(outside) size(small) format(%9.1f)) ///
			bar(1, color(stc1)) bar(2, color(stc2)) ///
			subtitle(, pos(6) bcolor(none))
			
	gr export "$outputs/fig1.png", replace	
	
	* Distribution of non food consumption by female headed hhs with means
	
	forvalues hh_head = 0/1 {
		sum nonfood_cons_usd_w if female_head ==`hh_head'
		local mean_`hh_head' = round(r(mean), 0.01)
	}
	
	twoway	(kdensity nonfood_cons_usd_w if female_head==1, color(stc2)) ///
			(kdensity nonfood_cons_usd_w if female_head==0, color(stc1)) ///
			, ///
			xline(`mean_1', lcolor(stc2) 	lpattern(dash)) ///
			xline(`mean_0', lcolor(stc1) 	lpattern(dash)) ///
			leg(order(0 "Household Head:" 1 "Female" 2 "Male" ) row(1) pos(6)) ///
			xtitle("Distribution") ///
			ytitle("Density") ///
			title("Distribution of Non food consumption across household heads") ///
			note("Dashed lines represent the mean by gender of household head") ///
			xlabel(`mean_1', add custom labcolor(stc2))
			
	gr export "$outputs/fig2.png", replace	
	
*-------------------------------------------------------------------------------	
* Summary stats
*------------------------------------------------------------------------------- 

	* defining globals with variables used for summary
	global sumvars 		hh_size n_child_5 n_elder read sick female_head ///
						livestock_now area_acre_w drought_flood crop_damage
	
	* Summary table - overall and by districts
	eststo all: 		estpost sum $sumvars
	eststo district_1: 	estpost sum $sumvars if district == 1
	eststo district_2: 	estpost sum $sumvars if district == 2
	eststo district_3: 	estpost sum $sumvars if district == 3
	
	
	* Exporting table in csv
	esttab 	all district_* ///
			using "${outputs}/summary_1.csv", replace ///
			label ///
			refcat(hh_size "HH chars" drought_flood "Shocks", nolabel) ///
			main(mean %6.2f) aux(sd) ///
			mtitle("Full Sample" "Kibaha" "Bagamoyo" "Chamwino") ///
			nonotes addn(Mean with standard deviations in parentheses.)
	
	* Also export in tex for latex
	esttab 	all district_* ///
			using "${outputs}/summary_1.tex", replace ///
			label ///
			refcat(hh_size "HH chars" drought_flood "Shocks", nolabel) ///
			main(mean %6.2f) aux(sd) ///
			mtitle("Full Sample" "Kibaha" "Bagamoyo" "Chamwino") ///
			nonotes addn(Mean with standard deviations in parentheses.)
			
			
*-------------------------------------------------------------------------------	
* Balance tables
*------------------------------------------------------------------------------- 	
	
	* Balance (if they purchased cows or not)
	iebaltab 	${sumvars}, ///
				grpvar(treatment) ///
				rowvarlabels	///
				format(%9.2f)	///
				savecsv("${outputs}/baltab_1") ///
				savetex("${outputs}/baltab_1") ///
				nonote addnote("Significance: ***.01, **.05, *.1") replace 		

				
*-------------------------------------------------------------------------------	
* Regressions
*------------------------------------------------------------------------------- 				
				
	* Model 1: Regress of food consumption value on treatment
	regress food_cons_usd_w treatment

	eststo mod1		// store regression results
	
	estadd local clustering "No"
	estadd local controls "No"
	
	* Model 2: Add controls 
	regress food_cons_usd_w treatment crop_damage drought_flood
	
	eststo mod2
	
	estadd local clustering "No"
	estadd local controls "Yes"
	
	* Model 3: Add clustering by village
	regress food_cons_usd_w treatment crop_damage drought_flood, vce(cluster vid)
	
	eststo mod3
	
	estadd local clustering "Yes"
	estadd local controls "Yes"
	
	* Export results in tex
	esttab 	mod* ///
			using "$outputs/regression.tex" , ///
			label ///
			b(%9.2f) se(%9.2f) ///
			nomtitles ///
			mgroup("Food Consumption (USD)", pattern(1 0 0 ) span) ///
			scalars("clustering Clustering" "controls Controls") ///
			replace
			
*-------------------------------------------------------------------------------			
* Graphs: Secondary data
*-------------------------------------------------------------------------------			
			
	use "${data}/Final/TZA_amenity_analysis.dta", clear
	
	* createa  variable to highlight the districts in sample
	gen insample = inlist(district, 1, 3, 6)
	
	* Separate indicators by sample
	separate n_school		, by(insample)
	separate n_medical		, by(insample)
	
	* Graph bar for number of schools by districts
	gr hbar 	n_school0 n_school1, ///
				nofill ///
				over(district, sort(n_school)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("Number of Schools") ///
				name(g1, replace)
				
	* Graph bar for number of medical facilities by districts				
	gr hbar 	n_medical0 n_medical1, ///
				nofill ///
				over(district, sort(n_medical)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("Number of Medical Facilities") ///
				name(g2, replace)
				
	grc1leg2 	g1 g2, ///
				row(1) ///
				ycommon xcommon ///
				title("Access to Amenities: By Districts", size(medsmall))
			
	
	gr export "$outputs/fig3.png", replace		

****************************************************************************end!			
